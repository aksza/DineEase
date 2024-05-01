using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;
        private readonly IReviewRepository _reviewRepository;

        public ReviewController(IMapper mapper, IConfiguration configuration, IReviewRepository reviewRepository)
        {
            _mapper = mapper;
            _configuration = configuration;
            _reviewRepository = reviewRepository;
        }

        [HttpGet("{userId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Review>))]
        public async Task<IActionResult> GetReviewByUserId(int userId)
        {
            var reviews = _mapper.Map<List<ReviewDto>>(await _reviewRepository.GetReviewsByUserId(userId));

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(reviews);
        }
    }
}
