using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : Controller
    {
        private readonly IUserRepository _userRepository;
        
        private readonly IRestaurantRepository _restaurantRepository;
        private readonly IOwnerRepository _ownerRepository;
        private readonly IPriceRepository _priceRepository;
        
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;

        public LoginController(IUserRepository userRepository,IRestaurantRepository restaurantRepository, IOwnerRepository ownerRepository, IPriceRepository priceRepository, IMapper mapper, IConfiguration configuration)
        {
            _userRepository = userRepository;
            _restaurantRepository = restaurantRepository;
            _ownerRepository = ownerRepository;
            _priceRepository = priceRepository;
            _mapper = mapper;
            _configuration = configuration;
        }

        [HttpPost("login")]
        public async Task<ActionResult<string>> Login(LoginDto request)
        {
            try
            {
                User user = await _userRepository.GetUserByEmail(request.Email);
                
                if(user != null)
                {
                    if (!VerifyPasswordHash(request.Password, user.PasswordHash, user.PasswordSalt))
                    {
                        return BadRequest("Wrong password");
                    }
                    string token;
                    if (user.Admin == false)
                    {
                        token = CreateTokenUser(user);
                    }
                    else
                    {
                        token = CreateTokenAdmin(user);
                    }

                    return Ok(token);
                }
                else
                {
                    Restaurant restaurant = await _restaurantRepository.GetRestaurantByEmail(request.Email);
                    if(restaurant == null)
                    {
                        return BadRequest("User or restaurant not found");
                    }

                    if (!VerifyPasswordHash(request.Password, restaurant.PasswordHash, restaurant.PasswordSalt))
                    {
                        return BadRequest("Wrong password");
                    }

                    string token = CreateTokenRestaurant(restaurant);

                    return Ok(token);
                }
            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }

        private string CreateTokenRestaurant(Restaurant restaurant)
        {
            List<Claim> claims = new List<Claim>
            {
                new Claim(ClaimTypes.Email, restaurant.Email),
                new Claim(ClaimTypes.NameIdentifier, restaurant.Id.ToString()),
                new Claim(ClaimTypes.Role, "Restaurant")
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

        private string CreateTokenUser(User user)
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
            using (var hmac = new HMACSHA512())
            {
                passwordSalt = hmac.Key;
                passwordHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));

            }
        }

        private bool VerifyPasswordHash(string password, byte[] passwordHash, byte[] passwordSalt)
        {
            using (var hmac = new HMACSHA512(passwordSalt))
            {
                var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                return computedHash.SequenceEqual(passwordHash);
            }
        }
    }
}
