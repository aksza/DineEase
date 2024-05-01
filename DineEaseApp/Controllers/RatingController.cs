using AutoMapper;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RatingController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;
        private readonly IRatingRepository _ratingRepository;

        public RatingController(IMapper mapper, IConfiguration configuration, IRatingRepository ratingRepository)
        {
            _mapper = mapper;
            _configuration = configuration;
            _ratingRepository = ratingRepository;
        }

        [HttpGet("{userId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Rating>))]
        public async Task<IActionResult> GetRatingsByUserId(int userId)
        {
            var ratings = _mapper.Map<List<Rating>>(await _ratingRepository.GetRatingsByUserId(userId));

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(ratings);
        }
    }
}
