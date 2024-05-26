using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using DineEaseApp.Repository;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MeetingController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;
        private readonly IMeetingRepository _meetingRepository;
        private readonly IUserRepository _userRepository;
        private readonly IRestaurantRepository _restaurantRepository;
        private readonly IRepository<EventType> _eventTypeRepository;

        public MeetingController(IMapper mapper,IRepository<EventType> eventTypeRepository, IConfiguration configuration,IMeetingRepository meetingRepository, IUserRepository userRepository,IRestaurantRepository restaurantRepository)
        {
            _mapper = mapper;
            _eventTypeRepository= eventTypeRepository;
            _configuration = configuration;
            _meetingRepository = meetingRepository;
            _userRepository = userRepository;
            _restaurantRepository = restaurantRepository;
        }

        [HttpGet("eventTypes")]
        public async Task<IActionResult> GetEventTypes()
        {
            var eventtypes = _mapper.Map<List<EventTypeDto>>(await _eventTypeRepository.GetAllAsync());

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(eventtypes);
        }

        [HttpGet("accepted/{userId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Meeting>))]
        public async Task<IActionResult> GetAcceptedMeetingsByUserId(int userId)
        {
            var meetings = _mapper.Map<List<MeetingDto>>(await _meetingRepository.GetMeetingsByUserId(userId));
            var acceptedMeetings = new List<MeetingDto>();
            foreach(var meeting in meetings)
            {
                if(meeting.Accepted == true)
                {
                    meeting.Event = _mapper.Map<EventTypeDto>(await _eventTypeRepository.GetByIdAsync(meeting.EventId));
                    acceptedMeetings.Add(meeting);
                }
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(meetings);
            }
            return Ok(acceptedMeetings);
        }

        [HttpGet("waiting/{userId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Meeting>))]
        public async Task<IActionResult> GetWaitingMeetingsByUserId(int userId)
        {
            var meetings = _mapper.Map<List<MeetingDto>>(await _meetingRepository.GetMeetingsByUserId(userId));
            var res = new List<MeetingDto>();
            foreach (var meeting in meetings)
            {
                if (meeting.Accepted == null)
                {
                    meeting.Event = _mapper.Map<EventTypeDto>(await _eventTypeRepository.GetByIdAsync(meeting.EventId));
                    res.Add(meeting);
                }
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(meetings);
            }
            return Ok(res);
        }

        [HttpPost("schedule")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> ScheduleAMeeting(MeetingCreateDto meetingDto)
        {
            try
            {
                if(meetingDto == null)
                {
                    return BadRequest(ModelState);
                }

                var res = await _restaurantRepository.GetRestaurantById(meetingDto.RestaurantId);
                if (res == null)
                {
                    ModelState.AddModelError("", "Restaurant does not exist");
                    return BadRequest(ModelState);
                }

                var user = await _userRepository.GetUserById(meetingDto.UserId);
                if (user == null)
                {
                    ModelState.AddModelError("", "User does not exist");
                    return BadRequest(ModelState);
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var meetingMap = _mapper.Map<Meeting>(meetingDto);
                if(!await _meetingRepository.PostMeeting(meetingMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return BadRequest(ModelState);
                }
                return Ok("Successfully scheduled");

            }catch(Exception ex)
            {
                return StatusCode(500,ex.Message);
            }
        }
    }
}
