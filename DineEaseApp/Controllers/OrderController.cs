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
    public class OrderController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IOrderRepository _orderRepository;
        private readonly IReservationRepository _reservationRepository;
        private readonly IMenuRepository _menuRepository;

        public OrderController(IMapper mapper, IOrderRepository orderRepository, IReservationRepository reservationRepository,IMenuRepository menuRepository)
        {
            _mapper = mapper;
            _orderRepository = orderRepository;
            _reservationRepository = reservationRepository;
            _menuRepository = menuRepository;
        }

        [HttpGet("{reservationId}")]
        public async Task<IActionResult> GetOrderByReservationId(int reservationId) 
        {
            var orders = _mapper.Map<List<OrderDto>>(await _orderRepository.GetOrdersByReservationId(reservationId));
            
            foreach(var order in orders)
            {
                var menu = await _menuRepository.GetByIdAsync(order.MenuId);
                order.MenuName = menu.Name;
            }

            if(orders == null)
            {
                return NotFound();
            }

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(orders);
        }

        [HttpPost("addOrder")]
        public async Task<IActionResult> AddOrder(OrderCreateDto orderDto)
        {
            try
            {
                if (orderDto == null)
                {
                    return BadRequest(ModelState);
                }

                var orderMap = _mapper.Map<Order>(orderDto);
                if (!await _orderRepository.AddAsync(orderMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }

                var reservation = await _reservationRepository.GetReservationById(orderDto.ReservationId);
                if (reservation == null)
                {
                    BadRequest(ModelState);
                }

                reservation.Ordered = true;
                //reservation.Orders.Add(orderMap);

                if (!await _reservationRepository.UpdateReservation(reservation))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }

                return Ok("Successfully created");
            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }

        [HttpPut("update/{id}")]
        [ProducesResponseType(400)]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> UpdateOrder(int id, [FromBody] OrderDto updateOrderDto)
        {
            if(updateOrderDto == null)
            {
                return BadRequest(ModelState);
            }

            if(id != updateOrderDto.Id)
            {
                return BadRequest(ModelState);
            }

            var o = await _orderRepository.GetByIdAsync(id);
            if(o == null)
            {
                return NotFound();
            }

            if(!ModelState.IsValid)
            {
                return BadRequest();
            }

            var orderMap = _mapper.Map<Order>(updateOrderDto);
            if(!await _orderRepository.UpdateAsync(orderMap))
            {
                ModelState.AddModelError("", "Something went wrong while saving");
                return StatusCode(500, ModelState);
            }

            return NoContent();
        }

        [HttpDelete("delete")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> DeleteOrder(int id)
        {
            try
            {
                var m = await _orderRepository.GetByIdAsync(id);

                if (m == null)
                {
                    ModelState.AddModelError("", "Order nem letezik");
                    return BadRequest(ModelState);
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                if (!await _orderRepository.DeleteAsync(m))
                {
                    ModelState.AddModelError("", "Something went wrong");
                    return BadRequest(ModelState);
                }
                return Ok("Successfully removed");
            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }
    }
}
