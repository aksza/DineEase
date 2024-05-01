using AutoMapper;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReservationController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;
        private readonly IReservationRepository _reservationRepository;

        public ReservationController(IMapper mapper, IConfiguration configuration, IReservationRepository reservationRepository)
        {
            _mapper = mapper;
            _configuration = configuration;
            _reservationRepository = reservationRepository;
        }

        [HttpGet("{userId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Reservation>))]
        public async Task<IActionResult> GetReservationsByUserId(int userId)
        {
            var reservations = _mapper.Map<List<Reservation>>(await _reservationRepository.GetReservationsByUserId(userId));
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(reservations);
        }
    }
}
