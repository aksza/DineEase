using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;


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

        [HttpGet("accepted/{userId}"),Authorize]
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
                    var user = await _userRepository.GetUserById(reservation.UserId);
                    reservation.Name = user.FirstName + ' ' + user.LastName;
                    acceptedRes.Add(reservation);
                }
            }
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(acceptedRes);
        }

        [HttpGet("waiting/{userId}"), Authorize]
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
                    var user = await _userRepository.GetUserById(reservation.UserId);
                    reservation.Name = user.FirstName + ' ' + user.LastName;
                    acceptedRes.Add(reservation);
                }
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(acceptedRes);
        }

        [HttpGet("acceptedRes/{restaurantId}"), Authorize]
        public async Task<IActionResult> GetAcceptedReservationsByRestaurantId(int restaurantId)
        {
            var reservations = _mapper.Map<List<ReservationDto>>(await _reservationRepository.GetReservationsByRestaurantId(restaurantId));
            var acceptedRes = new List<ReservationDto>();
            foreach (var reservation in reservations)
            {
                if (reservation.Accepted == true)
                {
                    var res = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(reservation.RestaurantId));
                    reservation.RestaurantName = res.Name;
                    var user = await _userRepository.GetUserById(reservation.UserId);
                    reservation.Name = user.FirstName + ' ' + user.LastName;
                    acceptedRes.Add(reservation);
                }
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(acceptedRes);
        }

        [HttpGet("waitingRes/{restaurantId}"), Authorize]
        public async Task<IActionResult> GetWaitingListByRestaurantId(int restaurantId)
        {
            var reservations = _mapper.Map<List<ReservationDto>>(await _reservationRepository.GetReservationsByRestaurantId(restaurantId));
            var acceptedRes = new List<ReservationDto>();
            foreach (var reservation in reservations)
            {
                if (reservation.Accepted == null)
                {
                    var res = _mapper.Map<RestaurantDto>(await _restaurantRepository.GetRestaurantById(reservation.RestaurantId));
                    reservation.RestaurantName = res.Name;
                    var user = await _userRepository.GetUserById(reservation.UserId);
                    reservation.Name = user.FirstName + ' ' + user.LastName;
                    acceptedRes.Add(reservation);
                }
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(acceptedRes);
        }

        [HttpPost("reserve"), Authorize]
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

        [HttpPut("respond"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> RespondToReservation(ReservationDto reservationDto)
        {
            try
            {
                if (reservationDto == null)
                {
                    return BadRequest(ModelState);
                }

                var res = await _reservationRepository.GetReservationById(reservationDto.Id);

                if(res == null)
                {
                    ModelState.AddModelError("", "Reservation does not exist");
                    return BadRequest(ModelState);

                }

                var reservationMap = _mapper.Map<Reservation>(reservationDto);

                if (!await _reservationRepository.UpdateReservation(reservationMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }
                return Ok(reservationMap.Id);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("dailyReservations/{restaurantId}"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetDailyReservationsByRestaurantId(int restaurantId)
        {
            try
            {
                var dailyReservations = await _reservationRepository.AverageDailyReservationsByRestaurantId(restaurantId);
                return Ok(dailyReservations);
            }
            catch(Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("hourReservations/{restaurantId}"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetReservationsPerHourByRestaurantId(int restaurantId)
        {
            try
            {
                var dailyReservations = await _reservationRepository.AverageReservationsPerHoursByRestaurantId(restaurantId);
                return Ok(dailyReservations);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("lastMonthReservation/{restaurantId}"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetLastMonthReservationsByRestaurantId(int restaurantId)
        {
            try
            {
                var dailyReservations = await _reservationRepository.AverageReservationsLastMonthByRestaurantId(restaurantId);
                return Ok(dailyReservations);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("ordersPerReservation/{restaurantId}"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetOrdersPerReservationsByRestaurantId(int restaurantId)
        {
            try
            {
                var dailyReservations = await _reservationRepository.OrdersPerReservationsByRestaurantId(restaurantId);
                return Ok(dailyReservations);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
