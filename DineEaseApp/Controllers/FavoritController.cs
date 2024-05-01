using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FavoritController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;

        private readonly IFavoritRepository _favoritRepository;

        public FavoritController(IMapper mapper, IConfiguration configuration, IFavoritRepository favoritRepository)
        {
            _mapper = mapper;
            _configuration = configuration;
            _favoritRepository = favoritRepository;
        }

        [HttpGet("{userId})")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Favorit>))]
        public async Task<IActionResult> GetFavoritsByUserId(int userId)
        {
            var favorits = _mapper.Map<List<FavoritDto>>(await _favoritRepository.GetFavoritsByUserId(userId));

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(favorits);
        }
    }
}
