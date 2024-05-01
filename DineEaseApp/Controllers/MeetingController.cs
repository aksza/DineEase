using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
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
        
        public MeetingController(IMapper mapper, IConfiguration configuration,IMeetingRepository meetingRepository)
        {
            _mapper = mapper;
            _configuration = configuration;
            _meetingRepository = meetingRepository;
        }

        [HttpGet("{userId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Meeting>))]
        public async Task<IActionResult> GetMeetingsByUserId(int userId)
        {
            var meetings = _mapper.Map<List<MeetingDto>>(await _meetingRepository.GetMeetingsByUserId(userId));

            if (!ModelState.IsValid)
            {
                return BadRequest(meetings);
            }
            return Ok(meetings);
        }
    }
}
