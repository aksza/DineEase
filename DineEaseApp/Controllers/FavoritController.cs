using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FavoritController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;
        private readonly ILogger _logger;

        private readonly IFavoritRepository _favoritRepository;

        public FavoritController(IMapper mapper, IConfiguration configuration, IFavoritRepository favoritRepository)
        {
            _mapper = mapper;
            _configuration = configuration;
            _favoritRepository = favoritRepository;
        }

        [HttpGet("{userId})")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Favorit>))]
        public async Task<IActionResult> GetFavoritsByUserId(int userId)
        {
            var favorits = _mapper.Map<List<FavoritDto>>(await _favoritRepository.GetFavoritsByUserId(userId));

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(favorits);
        }

        [HttpPost("addToFavorits")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> AddFavoritRestaurant(FavoritDto favoritDto)
        {
            try
            {
                if(favoritDto == null)
                {
                    return BadRequest(ModelState);
                }

                var favorit = await _favoritRepository.GetFavoritByUserRestaurantId(favoritDto.UserId, favoritDto.RestaurantId);
                if(favorit != null)
                {
                    ModelState.AddModelError("", "Favorit already exists");
                    return BadRequest(ModelState);
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var favoritMap = _mapper.Map<Favorit>(favoritDto);

                if(!await _favoritRepository.AddToFavorits(favoritMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return BadRequest(ModelState);
                }
                return Ok("Successfully created");

            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpDelete("removeFavorit")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> RemoveFavorit(FavoritDto favoritDto)
        {
            try
            {
                if(favoritDto == null)
                {
                    return BadRequest(ModelState);
                }
                
                var favorit = await _favoritRepository.GetFavoritByUserRestaurantId(favoritDto.UserId, favoritDto.RestaurantId);
                
                if(favorit == null)
                {
                    ModelState.AddModelError("", "Favorit does not exist");
                    return BadRequest(ModelState);
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var favoritMap = _mapper.Map<Favorit>(favorit);
                
                if(!await _favoritRepository.RemoveFavorits(favoritMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return BadRequest(ModelState);
                }

                return Ok("Successfully removed");
            }
            catch(Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
