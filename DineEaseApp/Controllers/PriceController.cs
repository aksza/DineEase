using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;


namespace DineEaseApp.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]
    public class PriceController : Controller
    {
        private readonly IPriceRepository _priceRepository;
        private readonly IMapper _mapper;

        public PriceController(IPriceRepository priceRepository, IMapper mapper)
        {
            this._priceRepository = priceRepository;
            this._mapper = mapper;
        }

        [HttpGet,Authorize]
        [ProducesResponseType(200,Type = typeof(IEnumerable<Price>))]
        public IActionResult GetPrices()
        {
            var prices = _mapper.Map<List<PriceDto>>(_priceRepository.GetPrices());
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(prices);
        }

        [HttpGet("{id}"), Authorize]
        [ProducesResponseType(200, Type = typeof(Owner))]
        [ProducesResponseType(400)]
        public IActionResult GetPrice(int id)
        {
            if(!_priceRepository.PriceExists(id))
            {
                return NotFound();
            }
            var price = _mapper.Map<PriceDto>(_priceRepository.GetPrice(id));
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(price);
        }

        [HttpGet("{priceId}/Restaurants"), Authorize]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Restaurant>))]
        [ProducesResponseType(400)]

        public IActionResult GetRestaurantByPrice(int priceId)
        {
            if (!_priceRepository.PriceExists(priceId))
            {
                return NotFound();
            }

            var restaurants = _mapper.Map<List<RestaurantDto>>(_priceRepository.GetRestaurantByPrice(priceId));
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            return Ok(restaurants);
        }

    }
}
