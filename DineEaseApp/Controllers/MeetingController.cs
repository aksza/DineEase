using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using DineEaseApp.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

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

        [HttpGet("eventTypes"), Authorize]
        public async Task<IActionResult> GetEventTypes()
        {
            var eventtypes = _mapper.Map<List<EventTypeDto>>(await _eventTypeRepository.GetAllAsync());

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(eventtypes);
        }

        [HttpGet("acceptedRes/{restaurantId}"), Authorize]
        public async Task<IActionResult> GetAcceptedMeetingsByRestaurantId(int restaurantId)
        {
            var meetings = _mapper.Map<List<MeetingDto>>(await _meetingRepository.GetMeetingByRestaurantId(restaurantId));
            var acceptedMeetings = new List<MeetingDto>();
            foreach (var meeting in meetings)
            {
                if (meeting.Accepted == true)
                {
                    var ev = _mapper.Map<EventTypeDto>(await _eventTypeRepository.GetByIdAsync(meeting.EventId));
                    var restaurant = _mapper.Map<Restaurant>(await _restaurantRepository.GetRestaurantById(meeting.RestaurantId));
                    meeting.EventName = ev.EventName;
                    meeting.RestaurantName = restaurant.Name;
                    acceptedMeetings.Add(meeting);
                }
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(meetings);
            }
            return Ok(acceptedMeetings);
        }

        [HttpGet("accepted/{userId}"), Authorize]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Meeting>))]
        public async Task<IActionResult> GetAcceptedMeetingsByUserId(int userId)
        {
            var meetings = _mapper.Map<List<MeetingDto>>(await _meetingRepository.GetMeetingsByUserId(userId));
            var acceptedMeetings = new List<MeetingDto>();
            foreach(var meeting in meetings)
            {
                if(meeting.Accepted == true)
                {
                    var ev = _mapper.Map<EventTypeDto>(await _eventTypeRepository.GetByIdAsync(meeting.EventId));
                    var restaurant = _mapper.Map<Restaurant>(await _restaurantRepository.GetRestaurantById(meeting.RestaurantId));
                    meeting.EventName = ev.EventName;
                    meeting.RestaurantName = restaurant.Name;
                    acceptedMeetings.Add(meeting);
                }
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(meetings);
            }
            return Ok(acceptedMeetings);
        }

        [HttpPut("respond"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> RespondToMeeting(MeetingDto meetingDto)
        {
            try
            {
                if(meetingDto == null)
                {
                    return BadRequest();
                }

                var meet = await _meetingRepository.GetMeetingByRestaurantId(meetingDto.Id);
                if(meet == null)
                {
                    ModelState.AddModelError("", "Meeting does not exist");
                    return BadRequest(ModelState);
                }

                var meetingMap = _mapper.Map<Meeting>(meetingDto);

                if (!await _meetingRepository.UpdateMeeting(meetingMap))
                {
                    ModelState.AddModelError("", "Something went wrong while savind");
                    return StatusCode(500, ModelState);
                }
                return Ok(meetingMap.Id);

            }
            catch(Exception e)
            {
                return StatusCode(500,e.Message);
            }
        }

        [HttpGet("dailyMeetings/{restaurantId}"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetDailyMeetingsByRestaurantId(int restaurantId)
        {
            try
            {
                var dailyReservations = await _meetingRepository.AverageDailyMeetingsByRestaurantId(restaurantId);
                return Ok(dailyReservations);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("hourMeetings/{restaurantId}"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetHourMeetingsByRestaurantId(int restaurantId)
        {
            try
            {
                var dailyReservations = await _meetingRepository.AverageMeetingsPerHoursByRestaurantId(restaurantId);
                return Ok(dailyReservations);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("lastmonthMeetings/{restaurantId}"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetLastMonthMeetingsByRestaurantId(int restaurantId)
        {
            try
            {
                var dailyReservations = await _meetingRepository.AverageMeetingsLastMonthByRestaurantId(restaurantId);
                return Ok(dailyReservations);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("waitingRes/{restaurantId}"), Authorize]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Meeting>))]
        public async Task<IActionResult> GetWaitingMeetingsByRestaurantId(int restaurantId)
        {
            var meetings = _mapper.Map<List<MeetingDto>>(await _meetingRepository.GetMeetingByRestaurantId(restaurantId));
            var res = new List<MeetingDto>();
            foreach (var meeting in meetings)
            {
                if (meeting.Accepted == null)
                {
                    var ev = _mapper.Map<EventTypeDto>(await _eventTypeRepository.GetByIdAsync(meeting.EventId));
                    var restaurant = _mapper.Map<Restaurant>(await _restaurantRepository.GetRestaurantById(meeting.RestaurantId));
                    meeting.EventName = ev.EventName;
                    meeting.RestaurantName = restaurant.Name;
                    res.Add(meeting);
                }
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(meetings);
            }
            return Ok(res);
        }

        [HttpGet("waiting/{userId}"), Authorize]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Meeting>))]
        public async Task<IActionResult> GetWaitingMeetingsByUserId(int userId)
        {
            var meetings = _mapper.Map<List<MeetingDto>>(await _meetingRepository.GetMeetingsByUserId(userId));
            var res = new List<MeetingDto>();
            foreach (var meeting in meetings)
            {
                if (meeting.Accepted == null)
                {
                    var ev = _mapper.Map<EventTypeDto>(await _eventTypeRepository.GetByIdAsync(meeting.EventId));
                    var restaurant = _mapper.Map<Restaurant>(await _restaurantRepository.GetRestaurantById(meeting.RestaurantId));
                    meeting.EventName = ev.EventName;
                    meeting.RestaurantName = restaurant.Name;
                    res.Add(meeting);
                }
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(meetings);
            }
            return Ok(res);
        }

        [HttpPost("schedule"), Authorize]
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
