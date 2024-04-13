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

        public RestaurantController(IRestaurantRepository restaurantRepository) 
        {
            _restaurantRepository = restaurantRepository;
        }

        [HttpGet]
        [ProducesResponseType(200,Type = typeof(IEnumerable<Restaurant>))]

        public IActionResult GetRestaurants()
        {
            var restaurants = _restaurantRepository.GetRestaurants();

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(restaurants);
        }
    }
}
