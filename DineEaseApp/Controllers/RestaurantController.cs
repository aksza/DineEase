using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RestaurantController : Controller
    {
        private readonly IRestaurantRepository _restaurantRepository;
        private readonly IMapper _mapper;

        public RestaurantController(IRestaurantRepository restaurantRepository,IMapper mapper) 
        {
            _restaurantRepository = restaurantRepository;
        }

        [HttpGet]
        [ProducesResponseType(200,Type = typeof(IEnumerable<Restaurant>))]

        public IActionResult GetRestaurants()
        {
            //var restaurants = _mapper.Map<List<RestaurantDto>>(_restaurantRepository.GetRestaurants());
            var restaurants = _restaurantRepository.GetRestaurants();
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(restaurants);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(200,Type = typeof(Restaurant))]
        [ProducesResponseType(400)]
        public IActionResult GetRestaurantById(int id)
        {
            if(!_restaurantRepository.RestaurantExists(id))
            {
                return NotFound();

            }
            //var restaurant = _mapper.Map<RestaurantDto>(_restaurantRepository.GetRestaurantById(id));
            var restaurant = _restaurantRepository.GetRestaurantById(id);
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(restaurant);
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

        //[HttpGet("{name}")]
        //[ProducesResponseType(200, Type = typeof(IEnumerable<Restaurant>))]
        //[ProducesResponseType(400)]
        //public IActionResult GetRestaurantByName(string name)
        //{
        //    var restaurants = _restaurantRepository.GetRestaurantByName(name);

        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }
        //    return Ok(restaurants);

        //}
    }
}
