using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventController : Controller
    {
        private readonly IEventRepository _eventRepository;
        private readonly IRestaurantRepository _restaurantRepository;
        private readonly ICategoriesEventRepository _categoriesEventRepository;
        private readonly IRepository<ECategory> _ecategoryRepository;
        private readonly IMapper _mapper;
        //private readonly IConfiguration _configuration;

        public EventController(ICategoriesEventRepository categoriesEventRepository, IRepository<ECategory> ecategoryRepository, IEventRepository eventRepository,IRestaurantRepository restaurantRepository, IMapper mapper, IConfiguration configuration)
        {
            _categoriesEventRepository = categoriesEventRepository;
            _ecategoryRepository = ecategoryRepository;
            _eventRepository = eventRepository;
            _restaurantRepository = restaurantRepository;
            _mapper = mapper;
            //_configuration = configuration;
        }


        [HttpGet("search/{someText}")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> Search(string someText)
        {
            var results = _mapper.Map<List<EventDto>>(await _eventRepository.SearchEvents(someText));

            var eventDtos = results
                .Select(async e =>
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

        [HttpGet]
        [ProducesResponseType(200,Type = typeof(IEnumerable<Event>))]
        public async Task<IActionResult> GetEvents()
        {
            var events = _mapper.Map<List<EventDto>>(await _eventRepository.GetEventsAsync());

            //var eventDtos = events
            //    .Select (async e =>
            //    {
            //        var eventDto = e;
            //        RestaurantDto res = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(eventDto.RestaurantId));
            //        eventDto.RestaurantName = res.Name;
            //        return eventDto;
            //    }
            //    );
            //var eventDtoList = await Task.WhenAll(eventDtos);
            foreach(var eventDto in events)
            {
                var res = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(eventDto.RestaurantId));
                eventDto.RestaurantName = res.Name;
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(events);
        }

        [HttpPost("addEvent")]
        public async Task<IActionResult> AddEvent(EventCreateDto eventDto)
        {
            try
            {
                if(eventDto == null)
                {
                    return BadRequest(ModelState);
                }

                var eventMAp = _mapper.Map<Event>(eventDto);
                if(!await _eventRepository.AddAsync(eventMAp))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }

                return Ok("Successfully created");

            }
            catch(Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }
        

        [HttpGet("restaurant/{restaurantId}")]
        public async Task<IActionResult> GetEventsByRestaurantId(int restaurantId)
        {
            var events = _mapper.Map<List<EventDto>>(await _eventRepository.GetEventsByRestaurantId(restaurantId));

            foreach (var eventDto in events)
            {
                var res = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(eventDto.RestaurantId));
                eventDto.RestaurantName = res.Name;
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(events);
        }

        [HttpGet("eCategories")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetECategories()
        {
            var categories = _mapper.Map<List<CategoryEDto>>(await _ecategoryRepository.GetAllAsync());

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(categories);
        }

        [HttpGet("{eventId}/eCategories")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetCategoriesByEventId(int eventId)
        {
            var categories = _mapper.Map<List<CategoriesEventDto>>(await _categoriesEventRepository.GetCategoriesEventsByEventId(eventId));

            if (categories == null || categories.Count == 0)
            {
                return NotFound();
            }

            foreach (var category in categories)
            {
                var categoryname = await _ecategoryRepository.GetByIdAsync(category.ECategoryId);
                if (categoryname == null)
                {
                    return BadRequest($"ECategory type with id {category.ECategoryId} not found");
                }

                category.ECategoryName = categoryname.ECategoryName;
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(categories);
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
