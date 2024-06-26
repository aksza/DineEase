﻿using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Authorization;


namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RestaurantController : Controller
    {
        private readonly ICuisinesRestaurantRepository _cuisinesRestaurantRepository;
        private readonly IRepository<Cuisine> _cuisine;
        private readonly ICategoriesRestaurantRepository _categoriesRestaurantRepository;
        private readonly IRepository<RCategory> _rcategoryRepository;
        private readonly IRestaurantRepository _restaurantRepository;
        private readonly IOwnerRepository _ownerRepository;
        private readonly IPriceRepository _priceRepository;
        private readonly IFavoritRepository _favoritRepository;
        private readonly IOpeningRepository _openingRepository;
        private readonly ISeatingsRestaurantRepository _seatingsRestaurantRepository;
        private readonly IRepository<Seating> _seating;
        private readonly IMapper _mapper;
        private readonly ILogger _logger;
        private readonly IConfiguration _configuration;

        public RestaurantController(ICuisinesRestaurantRepository cuisinesRestaurantRepository, IRepository<Cuisine> cuisine, ICategoriesRestaurantRepository categoriesRestaurantRepository, IRepository<RCategory> rcategoryRepository, ISeatingsRestaurantRepository seatingsRestaurantRepository,IRepository<Seating> seating,IRestaurantRepository restaurantRepository, IOpeningRepository openingRepository, IOwnerRepository ownerRepository,IPriceRepository priceRepository,IFavoritRepository favoritRepository, IMapper mapper,IConfiguration configuration) 
        {
            _cuisinesRestaurantRepository = cuisinesRestaurantRepository;
            _cuisine = cuisine;
            _categoriesRestaurantRepository = categoriesRestaurantRepository;
            _rcategoryRepository = rcategoryRepository;
            _seatingsRestaurantRepository  = seatingsRestaurantRepository;
            _seating = seating;
            _restaurantRepository = restaurantRepository;
            _openingRepository = openingRepository;
            _ownerRepository = ownerRepository;
            _priceRepository = priceRepository;
            _favoritRepository = favoritRepository;
            _mapper = mapper;
            _configuration = configuration;

        }

        [HttpGet("mostreservations"), Authorize]
        public async Task<IActionResult> GetRestaurantsWithMostReservations()
        {
            var restaurants = _mapper.Map<List<RestaurantDto>>(await _restaurantRepository.GetRestaurantsWithMostReservation());


            var restaurantDtos = restaurants
                .Select(restaurant =>
                {
                    var restaurantDto = restaurant;
                    restaurantDto.Owner = _mapper.Map<OwnerDto>(_ownerRepository.GetOwner(restaurant.OwnerId));
                    restaurantDto.Price = _mapper.Map<PriceDto>(_priceRepository.GetPrice(restaurant.PriceId));
                    return restaurantDto;
                });

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(restaurantDtos);
        }

        [HttpGet("lastReservations/{userId}"), Authorize]
        public async Task<IActionResult> GetLastReservationsByUserId(int userId)
        {
            var restaurants = _mapper.Map<List<RestaurantDto>>(await _restaurantRepository.LastFiveReservationByUserId(userId));


            var restaurantDtos = restaurants
                .Select(restaurant =>
                {
                    var restaurantDto = restaurant;
                    restaurantDto.Owner = _mapper.Map<OwnerDto>(_ownerRepository.GetOwner(restaurant.OwnerId));
                    restaurantDto.Price = _mapper.Map<PriceDto>(_priceRepository.GetPrice(restaurant.PriceId));
                    return restaurantDto;
                });

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(restaurantDtos);
        }

        [HttpGet("mostRated"), Authorize]
        public async Task<IActionResult> GetMostRated()
        {
            var restaurants = _mapper.Map<List<RestaurantDto>>(await _restaurantRepository.FiveMostRated());


            var restaurantDtos = restaurants
                .Select(restaurant =>
                {
                    var restaurantDto = restaurant;
                    restaurantDto.Owner = _mapper.Map<OwnerDto>(_ownerRepository.GetOwner(restaurant.OwnerId));
                    restaurantDto.Price = _mapper.Map<PriceDto>(_priceRepository.GetPrice(restaurant.PriceId));
                    return restaurantDto;
                });

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(restaurantDtos);
        }


        [HttpGet("search/{someText}"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> Search(string someText)
        {
            
            var results = _mapper.Map<List<RestaurantDto>?>(await _restaurantRepository.SearchRestaurants(someText));

            var restaurantDtos = results
                .Select(restaurant =>
                {
                    var restaurantDto = restaurant;
                    restaurantDto.Owner = _mapper.Map<OwnerDto>(_ownerRepository.GetOwner(restaurant.OwnerId));
                    restaurantDto.Price = _mapper.Map<PriceDto>(_priceRepository.GetPrice(restaurant.PriceId));
                    return restaurantDto;
                });

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(restaurantDtos);

        }

        [HttpGet("cuisines"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetCuisines()
        {
            var cuisines = _mapper.Map<List<CuisineDto>>(await _cuisine.GetAllAsync());

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(cuisines);
        }

        [HttpGet("categories"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetRCategories()
        {
            var categories = _mapper.Map<List<CategoryRDto>>(await _rcategoryRepository.GetAllAsync());

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(categories);
        }

        [HttpGet("prices"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetPrices()
        {
            var prices = _mapper.Map<List<PriceDto>>(_priceRepository.GetPrices());

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(prices);
        }
        [HttpGet("seatings"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetSeatings()
        {
            var seatings = _mapper.Map<List<SeatingDto>>(await _seating.GetAllAsync());

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(seatings);
        }
        [HttpGet("{restaurantId}/cuisines"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetCuisinesByRestaurantId(int restaurantId)
        {
            var cuisines = _mapper.Map<List<CuisineRestaurantDto>>(await _cuisinesRestaurantRepository.GetCuisinesRestaurantsByRestaurantId(restaurantId));

            if (cuisines == null || cuisines.Count == 0)
            {
                return Ok(null);
            }

            foreach (var cuisine in cuisines)
            {
                var cuisinename = await _cuisine.GetByIdAsync(cuisine.CuisineId);
                if (cuisinename == null)
                {
                    return BadRequest("Cuisine not found");
                }

                cuisine.CuisineName = cuisinename.CuisineName;
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(cuisines);
        }

        [HttpGet("{restaurantId}/categories"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetCategoriesByRestaurantId(int restaurantId)
        {
            var categories = _mapper.Map<List<CategoriesRestaurantDto>>(await _categoriesRestaurantRepository.GetCategoriesRestaurantsByRestaurantId(restaurantId));

            if (categories == null || categories.Count == 0)
            {
                return Ok(null);
            }

            foreach (var category in categories)
            {
                var categoryname = await _rcategoryRepository.GetByIdAsync(category.RCategoryId);
                if (categoryname == null)
                {
                    return BadRequest($"RCategory type with id {category.RCategoryId} not found");
                }

                category.RCategoryName = categoryname.RCategoryName;
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(categories);
        }


        [HttpGet("{restaurantId}/openings"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetOpeningsByRestaurantId(int restaurantId)
        {
            var openings = _mapper.Map<List<OpeningDto>>(await _openingRepository.GetOpeningsByRestaurantId(restaurantId));
            if(openings == null || openings.Count == 0)
            {
                return Ok(null);
            }

           if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

           return Ok(openings);
        }

        [HttpPut("updateOpenings"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> UpdateOpening(List<OpeningDto> openingDtos)
        {
            if(openingDtos == null)
            {
                return BadRequest(ModelState);
            }

            foreach (var openingDto in openingDtos)
            {
                var opening = await _openingRepository.GetByIdAsync(openingDto.Id);
                if (opening == null)
                {
                    return NotFound();
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var openingMap = _mapper.Map<Opening>(openingDto);

                if (!await _openingRepository.UpdateAsync(openingMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }
            }

            return Ok("Successfully updated");
        }

        [HttpPost("addOpenings"), Authorize]
        public async Task<IActionResult> AddOpenings(List<OpeningCreateDto> openings) 
        {
            try
            {
                if (openings == null)
                {
                    return BadRequest(ModelState);
                }

                var openingsMap = _mapper.Map<List<Opening>>(openings);
                foreach (var opening in openingsMap)
                {
                    if (!await _openingRepository.AddAsync(opening))
                    {
                        ModelState.AddModelError("", "Something went wrong while saving");
                        return StatusCode(500, ModelState);
                    }
                }

                return Ok("Successfully created");
            }
            catch(Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("{restaurantId}/seatings"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetSeatingsByRestaurantId(int restaurantId)
        {
            var seatings = _mapper.Map<List<SeatingsRestaurantDto>>(await _seatingsRestaurantRepository.GetSeatingsRestaurantsByRestaurantId(restaurantId));

            if(seatings == null || seatings.Count == 0)
            {
                return Ok(null);
            }

            foreach(var seating in seatings)
            {
                var seatingname = await _seating.GetByIdAsync(seating.SeatingId);
                if(seatingname == null)
                {
                    return BadRequest("Seating not found");
                }

                seating.SeatingName = seatingname.SeatingName;
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(seatings);
        }

        [HttpPost("addCuisines"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> AddCuisinesToRestaurant(List<CuisineRestaurantCreateDto> cuisinesRestaurantDto)
        {
            try
            {
                if(cuisinesRestaurantDto == null)
                {
                    return BadRequest();
                }

                var cuisineRestaurantMap = _mapper.Map<List<CuisinesRestaurant>>(cuisinesRestaurantDto);

                Restaurant? res = await _restaurantRepository.GetRestaurantById(cuisineRestaurantMap[0].RestaurantId);
                if (res == null)
                {
                    return NotFound();
                }

                foreach (var cuisine in cuisineRestaurantMap)
                {
                    var c = await _cuisine.GetByIdAsync(cuisine.CuisineId);
                    if(c == null)
                    {
                        return NotFound();
                    }

                    var c2 = await _cuisinesRestaurantRepository.GetCuisinesRestaurantsByRestaurantCuisineId(cuisine.RestaurantId,cuisine.CuisineId);

                    if (c2 == null)
                    {
                        if (!await _cuisinesRestaurantRepository.AddAsync(cuisine))
                        {
                            ModelState.AddModelError("", "Something went wrong while saving");
                            return StatusCode(500, ModelState);
                        }
                    }
                    c2 = null;
                }
                return Ok("Successfully added");

            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }

        [HttpDelete("deleteCuisines"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> DeleteCuisine(List<CuisineRestaurantCreateDto> cuisineRestaurantCreateDtos)
        {
            try
            {
                if(cuisineRestaurantCreateDtos == null)
                {
                    return BadRequest();
                }

                foreach (var cuisineRestaurant in cuisineRestaurantCreateDtos)
                {
                    var c = await _cuisine.GetByIdAsync(cuisineRestaurant.CuisineId);

                    if (c == null)
                    {
                        return BadRequest("Cuisine does not exist");
                    }

                    var r = await _restaurantRepository.GetRestaurantById(cuisineRestaurant.RestaurantId);
                    if (r == null)
                    {
                        return BadRequest("Restaurant does not exist");
                    }

                    if (!ModelState.IsValid)
                    {
                        return BadRequest(ModelState);
                    }

                    var cr = await _cuisinesRestaurantRepository.GetCuisinesRestaurantsByRestaurantCuisineId(cuisineRestaurant.RestaurantId, cuisineRestaurant.CuisineId);

                    if (cr == null)
                    {
                        return BadRequest(ModelState);
                    }
                    if (!await _cuisinesRestaurantRepository.DeleteAsync(cr))
                    {
                        ModelState.AddModelError("", "Something went wrong while saving");
                        return BadRequest(ModelState);
                    }
                }

                return Ok("Successfully removed");
            }
            catch(Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }


        [HttpPost("addCategories"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> AddCategoriesToRestaurant(List<CategoriesRestaurantCreateDto> categoriesRestaurantCreateDtos)
        {
            try
            {
                if (categoriesRestaurantCreateDtos == null)
                {
                    return BadRequest();
                }

                var categoriesRestaurantsMap = _mapper.Map<List<CategoriesRestaurant>>(categoriesRestaurantCreateDtos);

                Restaurant? res = await _restaurantRepository.GetRestaurantById(categoriesRestaurantsMap[0].RestaurantId);
                if (res == null)
                {
                    return NotFound();
                }

                foreach (var category in categoriesRestaurantsMap)
                {
                    var c = await _rcategoryRepository.GetByIdAsync(category.RCategoryId);
                    if (c == null)
                    {
                        return NotFound();
                    }

                    var c2 = await _categoriesRestaurantRepository.GetCategoriesRestaurantsByRestaurantCategoryId(category.RestaurantId, category.RCategoryId);

                    if (c2 == null)
                    {
                        if (!await _categoriesRestaurantRepository.AddAsync(category))
                        {
                            ModelState.AddModelError("", "Something went wrong while saving");
                            return StatusCode(500, ModelState);
                        }
                    }
                    c2 = null;
                }
                return Ok("Successfully added");

            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }

        [HttpDelete("deleteCategories"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> DeleteCategories(List<CategoriesRestaurantCreateDto> categoriesRestaurantCreateDtos)
        {
            try
            {
                if (categoriesRestaurantCreateDtos == null)
                {
                    return BadRequest();
                }

                foreach (var categoriesRestaurant in categoriesRestaurantCreateDtos)
                {
                    var c = await _rcategoryRepository.GetByIdAsync(categoriesRestaurant.RCategoryId);

                    if (c == null)
                    {
                        return BadRequest("Category does not exist");
                    }

                    var r = await _restaurantRepository.GetRestaurantById(categoriesRestaurant.RestaurantId);
                    if (r == null)
                    {
                        return BadRequest("Restaurant does not exist");
                    }

                    if (!ModelState.IsValid)
                    {
                        return BadRequest(ModelState);
                    }

                    var cr = await _categoriesRestaurantRepository.GetCategoriesRestaurantsByRestaurantCategoryId(categoriesRestaurant.RestaurantId, categoriesRestaurant.RCategoryId);

                    if (cr == null)
                    {
                        return BadRequest(ModelState);
                    }
                    if (!await _categoriesRestaurantRepository.DeleteAsync(cr))
                    {
                        ModelState.AddModelError("", "Something went wrong while saving");
                        return BadRequest(ModelState);
                    }
                }

                return Ok("Successfully removed");
            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }



        [HttpPost("addSeatings"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> AddSeatingsToRestaurant(List<SeatingsRestaurantCreateDto> seatingsRestaurantCreateDtos)
        {
            try
            {
                if (seatingsRestaurantCreateDtos == null)
                {
                    return BadRequest();
                }

                var seatinggsRestaurantMap = _mapper.Map<List<SeatingsRestaurant>>(seatingsRestaurantCreateDtos);

                Restaurant? res = await _restaurantRepository.GetRestaurantById(seatinggsRestaurantMap[0].RestaurantId);
                if (res == null)
                {
                    return NotFound();
                }

                foreach (var seating in seatinggsRestaurantMap)
                {
                    var c = await _seating.GetByIdAsync(seating.SeatingId);
                    if (c == null)
                    {
                        return NotFound();
                    }

                    var c2 = await _seatingsRestaurantRepository.GetSeatingsRestaurantsByRestaurantSeatingId(seating.RestaurantId, seating.SeatingId);

                    if (c2 == null)
                    {
                        if (!await _seatingsRestaurantRepository.AddAsync(seating))
                        {
                            ModelState.AddModelError("", "Something went wrong while saving");
                            return StatusCode(500, ModelState);
                        }
                    }
                    c2 = null;
                }
                return Ok("Successfully added");

            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }

        [HttpDelete("deleteSeatings"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> DeleteSeatings(List<SeatingsRestaurantCreateDto> seatingsRestaurantCreateDtos)
        {
            try
            {
                if (seatingsRestaurantCreateDtos == null)
                {
                    return BadRequest();
                }

                foreach (var seatingRestaurant in seatingsRestaurantCreateDtos)
                {
                    var c = await _seating.GetByIdAsync(seatingRestaurant.SeatingId);

                    if (c == null)
                    {
                        return BadRequest("Seating does not exist");
                    }

                    var r = await _restaurantRepository.GetRestaurantById(seatingRestaurant.RestaurantId);
                    if (r == null)
                    {
                        return BadRequest("Restaurant does not exist");
                    }

                    if (!ModelState.IsValid)
                    {
                        return BadRequest(ModelState);
                    }

                    var cr = await _seatingsRestaurantRepository.GetSeatingsRestaurantsByRestaurantSeatingId(seatingRestaurant.RestaurantId, seatingRestaurant.SeatingId);

                    if (cr == null)
                    {
                        return BadRequest(ModelState);
                    }
                    if (!await _seatingsRestaurantRepository.DeleteAsync(cr))
                    {
                        ModelState.AddModelError("", "Something went wrong while saving");
                        return BadRequest(ModelState);
                    }
                }

                return Ok("Successfully removed");
            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }


        [HttpGet]
        [ProducesResponseType(200,Type = typeof(IEnumerable<Restaurant>))]

        public async Task<IActionResult> GetRestaurants()
        {
            var restaurants = _mapper.Map<List<RestaurantDto>>(await _restaurantRepository.GetRestaurants());


            var restaurantDtos = restaurants
                .Select(restaurant =>
                {
                    var restaurantDto = restaurant;
                    restaurantDto.Owner = _mapper.Map<OwnerDto>(_ownerRepository.GetOwner(restaurant.OwnerId));
                    restaurantDto.Price = _mapper.Map<PriceDto>(_priceRepository.GetPrice(restaurant.PriceId));
                    return restaurantDto;
                });
                
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(restaurantDtos);
        }

        [HttpGet("{id}"), Authorize]
        [ProducesResponseType(200,Type = typeof(Restaurant))]
        [ProducesResponseType(400)]
        public async Task<IActionResult> GetRestaurantById(int id)
        {
            try
            {
                var restaurant = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(id));
                restaurant.Owner = _mapper.Map<OwnerDto>(_ownerRepository.GetOwner(restaurant.OwnerId));
                restaurant.Price = _mapper.Map<PriceDto>(_priceRepository.GetPrice(restaurant.PriceId));
                return Ok(restaurant);
            }
            catch (Exception ex)
            {
                return StatusCode(500,ex.Message);
            }
        }

        [HttpPut("update"), Authorize]
        [ProducesResponseType(400)]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> UpdateRestaurant(RestaurantUpdateDto updateRestaurant)
        {
            if(updateRestaurant == null)
            {
                return BadRequest(ModelState);
            }

            var restaurant = await _restaurantRepository.GetRestaurantById(updateRestaurant.Id);

            if(restaurant == null)
            {
                return NotFound();
            }

            if (!ModelState.IsValid)
            {
                return BadRequest();
            }

            var restaurantMap = _mapper.Map<Restaurant>(updateRestaurant);

            restaurantMap.PasswordSalt = restaurant.PasswordSalt;
            restaurantMap.PasswordHash = restaurant.PasswordHash;
            restaurantMap.Rating = restaurant.Rating;
            restaurantMap.ForEvent = restaurant.ForEvent;
            restaurantMap.OwnerId = restaurant.OwnerId;
            restaurantMap.TaxIdNum = restaurant.TaxIdNum;
            restaurantMap.BusinessLicense = restaurant.BusinessLicense;


            if(!await _restaurantRepository.UpdateRestaurant(restaurantMap))
            {
                ModelState.AddModelError("", "Something went wrong while saving");
                return StatusCode(500, ModelState);
            }

            return NoContent();
        }

        [HttpGet("{id}/rating"), Authorize]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        public async Task<IActionResult> GetRestaurantRating(int id)
        {
            if (!_restaurantRepository.RestaurantExists(id))
            {
                return NotFound();
            }

            var rating = await _restaurantRepository.GetRestaurantRating(id);

            if (!ModelState.IsValid)
            {
                return BadRequest();
            }
            return Ok(rating);
        }


        [HttpGet("favorits/{userId}"), Authorize]
        public async Task<IActionResult> GetFavoritRastaurantsByUserId(int userId)
        {
            try
            {
                var favorits = await _favoritRepository.GetFavoritsByUserId(userId);
                if (favorits.Count == 0)
                {
                    return Ok(new List<RestaurantDto>()); 
                }

                var favoritRestaurants = new List<RestaurantDto>();

                foreach (var favorit in favorits)
                {
                    var restaurant = await _restaurantRepository.GetRestaurantById(favorit.RestaurantId);
                    if (restaurant != null)
                    {
                        var restaurantDto = _mapper.Map<RestaurantDto>(restaurant);
                        restaurantDto.Owner = _mapper.Map<OwnerDto>(_ownerRepository.GetOwner(restaurant.OwnerId));
                        restaurantDto.Price = _mapper.Map<PriceDto>(_priceRepository.GetPrice(restaurant.PriceId));

                        favoritRestaurants.Add(restaurantDto);
                    }
                    else
                    {
                        _logger.LogWarning($"Restaurant with ID {favorit.RestaurantId} does not exist.");
                    }
                }

                return Ok(favoritRestaurants);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
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
