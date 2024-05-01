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
        //private readonly IFavoritRepository _favoritRepository;
        //private readonly IMeetingRepository _meetingRepository;
        //private readonly IRatingRepository _ratingRepository;
        //private readonly IReservationRepository _reservationRepository;
        //private readonly IReviewRepository _reviewRepository;
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;

        public UserController(IUserRepository userRepository, IFavoritRepository favoritRepository,
            IMeetingRepository meetingRepository,IRatingRepository ratingRepository,
            IReservationRepository reservationRepository, IReviewRepository reviewRepository,
            IMapper mapper, IConfiguration configuration)
        {
            _userRepository = userRepository;
            //_favoritRepository = favoritRepository;
            //_meetingRepository = meetingRepository;
            //_ratingRepository = ratingRepository;
            //_reservationRepository = reservationRepository;
            //_reviewRepository = reviewRepository;
            _mapper = mapper;
            _configuration = configuration;
        }

        [HttpGet]
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
                //user.Favorits = _mapper.Map<List<FavoritDto>>(await _favoritRepository.GetFavoritsByUserId(userId));
                //user.Meetings = _mapper.Map<List<MeetingDto>>(await _meetingRepository.GetMeetingsByUserId(userId));
                //user.Ratings = _mapper.Map<List<RatingDto>>(await _ratingRepository.GetRatingsByUserId(userId));
                //user.Reservations = _mapper.Map<List<ReservationDto>>(await _reservationRepository.GetReservationsByUserId(userId));
                //user.Reviews = _mapper.Map<List<ReviewDto>>(await _reviewRepository.GetReviewsByUserId(userId));

                return Ok(user);
            }
            catch (Exception ex)
            {
                return StatusCode(500,ex.Message);
            }
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
                //username is lehetne
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, "User")
                //new Claim(ClaimTypes.Uri, user.ProfilePicture)
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
                //username is lehetne
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, "Admin")
                //new Claim(ClaimTypes.Uri, user.ProfilePicture)
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
