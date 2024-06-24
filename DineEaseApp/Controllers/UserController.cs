using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using DineEaseApp.Repository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : Controller
    {
        private readonly IUserRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;

        public UserController(IUserRepository userRepository,
            IMapper mapper, IConfiguration configuration)
        {
            _userRepository = userRepository;
            _mapper = mapper;
            _configuration = configuration;
        }

        [HttpGet, Authorize]
        [ProducesResponseType(200, Type = typeof(IEnumerable<User>))]

        public async Task<IActionResult> GetUsers()
        {
            var users = _mapper.Map<List<UserDto>>(await _userRepository.GetUsers());

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(users);
        }

        [HttpGet("{userId}"),Authorize]
        public async Task<IActionResult> GetUSerById(int userId)
        {
            try
            {
                var user = _mapper.Map<UserDto>(await _userRepository.GetUserById(userId));

                return Ok(user);
            }
            catch (Exception ex)
            {
                return StatusCode(500,ex.Message);
            }
        }

        [HttpPut("update/{userId}"), Authorize]
        [ProducesResponseType(400)]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> UpdateUser(int userId,[FromBody]UserUpdateDto updatedUser)
        {
            if(updatedUser == null)
            {
                return BadRequest(ModelState);
            }

            if (userId != updatedUser.Id)
            {
                return BadRequest(ModelState);
            }
            var user = await _userRepository.GetUserById(userId);
            if (user == null)
            {
                return NotFound();
            }

            if (!ModelState.IsValid)
            {
                return BadRequest();
            }

            var userMap = _mapper.Map<User>(updatedUser);

            userMap.PasswordSalt = user.PasswordSalt;
            userMap.PasswordHash = user.PasswordHash;
            if (!await _userRepository.UpdateUser(userMap))
            {
                ModelState.AddModelError("", "Something went wrong while saving");
                return StatusCode(500, ModelState);
            }

            return NoContent();
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(UserCreateDto userDto)
        {
            try
            {
                if(userDto == null)
                {
                    return BadRequest(ModelState);
                }

                var user = await _userRepository.GetUserByEmail(userDto.Email);

                if (user != null) 
                {
                    ModelState.AddModelError("", "User already exists");
                    return StatusCode(422, ModelState);
                }

                if(!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var userMap = _mapper.Map<User>(userDto);
                CreatePasswordHash(userDto.Password, out byte[] passwordHash, out byte[] passwordSalt);

                userMap.PasswordSalt = passwordSalt;
                userMap.PasswordHash = passwordHash;

                if(!await _userRepository.CreateUser(userMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }

                return Ok("Successfully created");
            }
            catch (Exception ex)
            {
                return(StatusCode(500,ex.Message));
            }


        }

        [HttpPost("login")]
        public async Task<ActionResult<string>> Login(UserLoginDto request)
        {
            try
            {
                User user = await _userRepository.GetUserByEmail(request.Email);
                if (user == null)
                {
                    return BadRequest("User not found"); 
                }

                if(!VerifyPasswordHash(request.Password,user.PasswordHash, user.PasswordSalt))
                {
                    return BadRequest("Wrong password");
                }
                string token;
                if (user.Admin == false)
                {
                    token = CreateToken(user);
                }
                else
                {
                    token = CreateTokenAdmin(user);
                }

                return Ok(token);
            }
            catch (Exception ex)
            {
                return StatusCode(500,ex.Message);
            }
        }

        private string CreateToken(User user)
        {
            List<Claim> claims = new List<Claim>
            {
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, "User")
            };

            var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(
                _configuration.GetSection("AppSettings:Token").Value)
                );
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.Now.AddDays(1),
                signingCredentials: creds);

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }

        private string CreateTokenAdmin(User user)
        {
            List<Claim> claims = new List<Claim>
            {
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, "Admin")
            };

            var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(
                _configuration.GetSection("AppSettings:Token").Value)
                );
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.Now.AddDays(1),
                signingCredentials: creds);

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }

        private void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt) 
        {
            using(var hmac = new HMACSHA512())
            {
                passwordSalt = hmac.Key;
                passwordHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));

            }
        }

        private bool VerifyPasswordHash(string password, byte[] passwordHash, byte[] passwordSalt)
        {
            using(var hmac = new HMACSHA512(passwordSalt))
            {
                var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                return computedHash.SequenceEqual(passwordHash);
            }
        }
    }
}
