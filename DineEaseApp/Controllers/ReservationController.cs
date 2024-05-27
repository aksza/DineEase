using AutoMapper;
using DineEaseApp.Dto;
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
        private readonly IUserRepository _userRepository;
        private readonly IRestaurantRepository _restaurantRepository;

        public ReservationController(IMapper mapper, IConfiguration configuration, IReservationRepository reservationRepository,IRestaurantRepository restaurantRepository, IUserRepository userRepository)
        {
            _mapper = mapper;
            _configuration = configuration;
            _reservationRepository = reservationRepository;
            _userRepository = userRepository;
            _restaurantRepository = restaurantRepository;
        }

        [HttpGet("accepted/{userId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<ReservationDto>))]
        public async Task<IActionResult> GetAcceptedReservationsByUserId(int userId)
        {
            var reservations = _mapper.Map<List<ReservationDto>>(await _reservationRepository.GetReservationsByUserId(userId));
            var acceptedRes = new List<ReservationDto>();
            foreach(var reservation in reservations)
            {
                if (reservation.Accepted == true)
                {
                    var res = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(reservation.RestaurantId));
                    reservation.RestaurantName = res.Name;
                    acceptedRes.Add(reservation);
                }
            }
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(acceptedRes);
        }

        [HttpGet("waiting/{userId}")]
        public async Task<IActionResult> GetWaitingReservationsByUserId(int userId)
        {
            var reservations = _mapper.Map<List<ReservationDto>>(await _reservationRepository.GetReservationsByUserId(userId));
            var acceptedRes = new List<ReservationDto>();
            foreach (var reservation in reservations)
            {
                if (reservation.Accepted == null)
                {
                    var res = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(reservation.RestaurantId));
                    reservation.RestaurantName = res.Name;
                    acceptedRes.Add(reservation);
                }
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(acceptedRes);
        }

        [HttpPost("reserve")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> ReserveATable(ReservationCreateDto reservationDto)
        {
            try
            {
                if(reservationDto == null)
                {
                    return BadRequest(ModelState);
                }

                var res = await _restaurantRepository.GetRestaurantById(reservationDto.RestaurantId);
                if(res == null)
                {
                    ModelState.AddModelError("", "Restaurant does not exist");
                    return BadRequest(ModelState);
                }

                var user = await _userRepository.GetUserById(reservationDto.UserId);
                if(user == null)
                {
                    ModelState.AddModelError("", "User does not exist");
                    return BadRequest(ModelState);
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var reservationMap = _mapper.Map<Reservation>(reservationDto);
                if(!await _reservationRepository.PostReservation(reservationMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }
                return Ok(reservationMap.Id);
            }
            catch (Exception ex)
            {
                return StatusCode(500,ex.Message);
            }
        }
    }
}
