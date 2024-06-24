using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace DineEaseApp.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]
    public class OwnerController : Controller
    {
        private readonly IOwnerRepository _ownerRepository;
        private readonly IMapper _mapper;

        public OwnerController(IOwnerRepository ownerRepository, IMapper mapper)
        {
            _ownerRepository = ownerRepository;
            _mapper = mapper;
        }

        [HttpGet, Authorize]
        [ProducesResponseType(200,Type = typeof(IEnumerable<Owner>))]
        public IActionResult GetOwners()
        {
            var owners = _mapper.Map<List<OwnerDto>>(_ownerRepository.GetOwners());
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(owners);
        }

        [HttpGet("{id}"),Authorize]
        [ProducesResponseType(200,Type = typeof(Owner))]
        [ProducesResponseType(400)]
        public IActionResult GetOwner(int id)
        {
            if(!_ownerRepository.OwnerExists(id))
            {
                return NotFound();
            }
            var owner = _mapper.Map<OwnerDto>(_ownerRepository.GetOwner(id));
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(owner);
        }

    }
}
