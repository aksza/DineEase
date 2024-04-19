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
    public class RestaurantController : Controller
    {
        private readonly IRestaurantRepository _restaurantRepository;
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;

        public RestaurantController(IRestaurantRepository restaurantRepository,IMapper mapper,IConfiguration configuration) 
        {
            _restaurantRepository = restaurantRepository;
            _mapper = mapper;
            _configuration = configuration;
        }

        [HttpGet]
        [ProducesResponseType(200,Type = typeof(IEnumerable<Restaurant>))]

        public async Task<IActionResult> GetRestaurants()
        {
            var restaurants = _mapper.Map<List<RestaurantDto>>(await _restaurantRepository.GetRestaurants());
            //var restaurants = _restaurantRepository.GetRestaurants();
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(restaurants);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(200,Type = typeof(Restaurant))]
        [ProducesResponseType(400)]
        public async Task<IActionResult> GetRestaurantById(int id)
        {
            try
            {
                var restaurant = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(id));
                return Ok(restaurant);
            }
            catch (Exception ex)
            {
                return StatusCode(500,ex.Message);
            }
        }

        [HttpGet("{id}/rating")]
        [ProducesResponseType(200, Type = typeof(double))]
        [ProducesResponseType(400)]
        public IActionResult GetRestaurantRating(int id)
        {
            if (!_restaurantRepository.RestaurantExists(id))
            {
                return NotFound();
            }

            var rating = _restaurantRepository.GetRestaurantRating(id);

            if (!ModelState.IsValid)
            {
                return BadRequest();
            }
            return Ok(rating);
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(RestaurantCreateDto restaurantDto)
        {
            try
            {
                if(restaurantDto == null)
                {
                    return BadRequest(ModelState);
                }
                var restaurant = await _restaurantRepository.GetRestaurantByEmail(restaurantDto.Email);
                if(restaurant != null)
                {
                    ModelState.AddModelError("", "Restaurant already exists");
                    return StatusCode(422, ModelState);
                }

                if(!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var restaurantMap = _mapper.Map<Restaurant>(restaurantDto);
                CreatePasswordHash(restaurantDto.Password,out byte[] passwordHash,out byte[] passwordSalt);

                restaurantMap.PasswordSalt = passwordSalt;
                restaurantMap.PasswordHash = passwordHash;

                if(!await _restaurantRepository.CreateRestaurant(restaurantMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }
                return Ok("Successfully created");
            }
            catch(Exception ex)
            {
                return(StatusCode(500, ex.Message));
            }
        }

        [HttpPost("login")]
        public async Task<ActionResult<string>> Login(RestaurantLoginDto request)
        {
            try
            {
                Restaurant restaurant = await _restaurantRepository.GetRestaurantByEmail(request.Email);
                if (restaurant == null)
                {
                    return BadRequest("Restaurant not found");
                }

                if(!VerifyPasswordHash(request.Password, restaurant.PasswordHash,restaurant.PasswordSalt))
                {
                    return BadRequest("Wrong password");
                }

                string token = CreateToken(restaurant);

                return Ok(token);
            }
            catch(Exception ex)
            {
                return(StatusCode(500, ex.Message));
            }
        }


        private string CreateToken(Restaurant restaurant)
        {
            List<Claim> claims = new List<Claim>();
            {
                new Claim(ClaimTypes.Email, restaurant.Email);
                new Claim(ClaimTypes.NameIdentifier, restaurant.Id.ToString());
                new Claim(ClaimTypes.Role, "Restaurant");
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

        private void CreatePasswordHash(string password,out byte[] passwordHash,out byte[] passwordSalt)
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
