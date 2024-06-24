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
    public class MenuController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IMenuRepository _menuRepository;
        private readonly IRepository<MenuType> _menuTypeRepository;


        public MenuController(IMapper mapper, IMenuRepository menuRepository, IRepository<MenuType> menuTypeRepository)
        {
            _mapper = mapper;
            _menuRepository = menuRepository;
            _menuTypeRepository = menuTypeRepository;
        }
        [HttpGet("menuTypes"),Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetMenuTypes()
        {
            var menutypes = _mapper.Map<List<MenuTypeDto>>(await _menuTypeRepository.GetAllAsync());

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(menutypes);
        }
      

        [HttpGet("{restaurantId}"), Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetMenusByRestaurantId(int restaurantId)
        {
            var menus = _mapper.Map<List<MenuDto>>(await _menuRepository.GetMenusByRestaurantId(restaurantId));

            if(menus == null)
            {
                return NotFound();
            }

            foreach(var menu in menus)
            {
                var menutype = await _menuTypeRepository.GetByIdAsync(menu.MenuTypeId);
                if(menutype == null)
                {
                    return BadRequest($"Menu type with ID {menu.MenuTypeId} not found");
                }
                menu.MenuTypeName = menutype.Name;
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(menus);
        }

        [HttpPost("addMenu"), Authorize]
        public async Task<IActionResult> AddMenu(MenuCreateDto menuDto)
        {
            try
            {
                if(menuDto == null)
                {
                    return BadRequest(ModelState);
                }

                var menuMap = _mapper.Map<Menu>(menuDto);
                if(!await _menuRepository.AddAsync(menuMap))
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

        [HttpPut("update/{id}"), Authorize]
        [ProducesResponseType(400)]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> UpdateMenu(int id, [FromBody]MenuDto updatedMenuDto)
        {
            if(updatedMenuDto == null)
            {
                return BadRequest(ModelState);
            }

            if(id != updatedMenuDto.Id)
            {
                return BadRequest(ModelState);
            }

            var m = await _menuRepository.GetByIdAsync(id);
            if(m == null)
            {
                return NotFound();
            }

            if (!ModelState.IsValid)
            {
                return BadRequest();
            }

            var menuMap = _mapper.Map<Menu>(updatedMenuDto);
            if(!await _menuRepository.UpdateAsync(menuMap))
            {
                ModelState.AddModelError("", "Something went wrong while saving");
                return StatusCode(500, ModelState);
            }

            return NoContent();
        }

        [HttpDelete("delete/{id}"),Authorize]
        [ProducesResponseType(200)]
        public async Task<IActionResult> DeleteMenu(int id)
        {
            try
            {
                var m = await _menuRepository.GetByIdAsync(id);

                if(m == null)
                {
                    ModelState.AddModelError("", "Menu nem letezik");
                    return BadRequest(ModelState);
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                if(!await _menuRepository.DeleteAsync(m))
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
