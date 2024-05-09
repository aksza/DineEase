using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventController : Controller
    {
        private readonly IEventRepository _eventRepository;
        private readonly IRestaurantRepository _restaurantRepository;
        private readonly IMapper _mapper;
        //private readonly IConfiguration _configuration;

        public EventController(IEventRepository eventRepository,IRestaurantRepository restaurantRepository, IMapper mapper, IConfiguration configuration)
        {
            _eventRepository = eventRepository;
            _restaurantRepository = restaurantRepository;
            _mapper = mapper;
            //_configuration = configuration;
        }

        [HttpGet]
        [ProducesResponseType(200,Type = typeof(IEnumerable<Event>))]
        public async Task<IActionResult> GetEvents()
        {
            var events = _mapper.Map<List<EventDto>>(await _eventRepository.GetEventsAsync());

            var eventDtos = events
                .Select (async e =>
                {
                    var eventDto = e;
                    RestaurantDto res = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(eventDto.RestaurantId));
                    eventDto.RestaurantName = res.Name;
                    return eventDto;
                }
                );
            var eventDtoList = await Task.WhenAll(eventDtos);
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(eventDtoList);
        }

        [HttpGet("{eventId}")]
        [ProducesResponseType(200, Type = typeof(Event))]
        public async Task<IActionResult> GetEventById(int eventId)
        {
            try
            {
                var eventt = _mapper.Map<EventDto>(await _eventRepository.GetEventById(eventId));
                try
                {
                    RestaurantDto res = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(eventt.RestaurantId));

                    eventt.RestaurantName = res.Name;
                }
                catch (Exception ex)
                {
                    return BadRequest(ModelState);
                }
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                return Ok(eventt);
            }
            catch(Exception ex)
            {
                return BadRequest(ex.Message);
            }
    }
    }

    
}
