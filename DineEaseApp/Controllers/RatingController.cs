using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RatingController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;
        private readonly IRatingRepository _ratingRepository;
        private readonly IRestaurantRepository _restaurantRepository;

        public RatingController(IMapper mapper, IConfiguration configuration, IRatingRepository ratingRepository, IRestaurantRepository restaurantRepository)
        {
            _mapper = mapper;
            _configuration = configuration;
            _ratingRepository = ratingRepository;
            _restaurantRepository = restaurantRepository;
        }

        [HttpGet("{userId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Rating>))]
        public async Task<IActionResult> GetRatingsByUserId(int userId)
        {
            var ratings = _mapper.Map<List<RatingDto>>(await _ratingRepository.GetRatingsByUserId(userId));
            
            foreach(var rating in ratings)
            {
                var res = await _restaurantRepository.GetRestaurantById(rating.RestaurantId);
                if (!ModelState.IsValid)
                {
                    return BadRequest(res);
                }

                rating.RestaurantName = res.Name;
            }

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(ratings);
        }

        [HttpPost("addRating")]
        public async Task<IActionResult> AddRating(RatingCreateDto ratingDto)
        {
            try
            {
                if(ratingDto == null)
                {
                    return BadRequest(ModelState);
                }

                var rating = await _ratingRepository.GetRatingByUserRestId(ratingDto.UserId, ratingDto.RestaurantId);

                if(rating != null)
                {
                    if (!await _ratingRepository.UpdateAsync(rating))
                    {
                        ModelState.AddModelError("", "Something went wrong while saving");
                        return StatusCode(500, ModelState);
                    }
                    var res2 = await _restaurantRepository.GetRestaurantById(ratingDto.RestaurantId);
                    if (res2 == null)
                    {
                        BadRequest("Restaurant not found");
                    }

                    if (!await _restaurantRepository.UpdateRestaurantRating(res2))
                    {
                        BadRequest(ModelState);
                    }
                    return Ok("Rating already existed, updated");
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var ratingMap = _mapper.Map<Rating>(ratingDto);

                if(!await _ratingRepository.AddAsync(ratingMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }

                var res = await _restaurantRepository.GetRestaurantById(ratingDto.RestaurantId);
                if (res == null)
                {
                    BadRequest("Restaurant not found");
                }

                if (!await _restaurantRepository.UpdateRestaurantRating(res))
                {
                    BadRequest(ModelState);
                }

                return Ok("Successfully created");
            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }

        [HttpPut("update/{id}")]
        [ProducesResponseType(400)]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> UpdateRating(int id, [FromBody]RatingDto updatedRatingDto)
        {
            if(updatedRatingDto == null)
            {
                return BadRequest(ModelState);
            }

            if(id != updatedRatingDto.Id)
            {
                return BadRequest(ModelState);
            }

            var r = await _ratingRepository.GetByIdAsync(id);
            if (r == null)
            {
                return NotFound();
            }

            if(!ModelState.IsValid)
            {
                return BadRequest();
            }

            if(r.UserId != updatedRatingDto.UserId || r.RestaurantId != updatedRatingDto.RestaurantId)
            {
                return BadRequest(ModelState);
            }

            var ratingMap = _mapper.Map<Rating>(updatedRatingDto);
            
            if(!await _ratingRepository.UpdateAsync(ratingMap))
            {
                ModelState.AddModelError("", "Something went wrong while saving");
                return StatusCode(500, ModelState);
            }

            var res = await _restaurantRepository.GetRestaurantById(r.RestaurantId);
            if (res == null)
            {
                BadRequest("Restaurant not found");
            }

            if (!await _restaurantRepository.UpdateRestaurantRating(res))
            {
                BadRequest(ModelState);
            }

            return NoContent();
        }

        [HttpDelete("delete/{id}")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> DeleteRating(int id)
        {
            try
            {
                var r = await _ratingRepository.GetByIdAsync(id);

                if(r == null)
                {
                    ModelState.AddModelError("", "Rating nem letezik");
                    return BadRequest(ModelState);
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                if(!await _ratingRepository.DeleteAsync(r))
                {
                    ModelState.AddModelError("", "Something went wrong");
                    return BadRequest(ModelState);
                }

                var res = await _restaurantRepository.GetRestaurantById(r.RestaurantId);
                if(res == null)
                {
                    BadRequest("Restaurant not found");
                }

                if(!await _restaurantRepository.UpdateRestaurantRating(res))
                {
                    BadRequest(ModelState);
                }
                return Ok("Successfully removed");
            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }


    }
}
