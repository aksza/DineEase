using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using DineEaseApp.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PhotosRestaurantController : Controller
    {
        private IFileService _fileService;
        private IPhotosRestaurantRepository _photosRestaurantRepository;
        private ILogger<PhotosRestaurantController> _logger;

        public PhotosRestaurantController(IFileService fileService, IPhotosRestaurantRepository photosRestaurantRepository, ILogger<PhotosRestaurantController> logger)
        {
            _fileService= fileService;
            _logger= logger;
            _photosRestaurantRepository = photosRestaurantRepository;
        }

        [HttpPost("addPhoto")]
        [ProducesResponseType(200,Type = typeof(PhotosRestaurant))]
        public async Task<IActionResult> CreatePhotosRestaurant([FromForm] PhotosRestaurantDto photoToAdd)
        {
            try
            {
                if(photoToAdd.ImageFile?.Length > 1 * 1024 * 1024)
                {
                    return BadRequest("File size should not exceed 1 MB");
                }
                List<string> allowedFileExtentions = new List<string> { ".jpg", ".jpeg", ".png" };
                string createdImageName = await _fileService.SaveFileAsync(photoToAdd.ImageFile!, allowedFileExtentions);

                var photosRestaurant = new PhotosRestaurant
                {
                    RestaurantId = photoToAdd.RestaurantId,
                    Image = createdImageName
                };

                var createdPhoto = await _photosRestaurantRepository.AddPhotosRestaurantAsync(photosRestaurant);
                //return CreatedAtAction(nameof(CreatePhotosRestaurant), createdPhoto);
                return Ok(createdPhoto);

            }
            catch(Exception ex)
            {
                _logger.LogError(ex.Message);
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("getPhoto/{restaurantId}")]
        public async Task<IActionResult> GetPhotosByRestaurantId(int restaurantId)
        {
            var photo = await _photosRestaurantRepository.GetPhotosByRestaurantId(restaurantId);

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            return Ok(photo);
        }

        [HttpPut("update/{id}")]
        [ProducesResponseType(200, Type = typeof(PhotosRestaurant))]
        public async Task<IActionResult> UpdatePhotosRestaurant(int id, [FromForm] PhotosRestaurantUpdateDto photoToUpdate)
        {
            try
            {
                if(id != photoToUpdate.Id)
                {
                    return StatusCode(StatusCodes.Status400BadRequest, $"id in url and form body does not match.");
                }

                var existingPhoto = await _photosRestaurantRepository.FindPhotoByIdAsync(id);
                if(existingPhoto == null)
                {
                    return StatusCode(StatusCodes.Status404NotFound, $"Product with id: {id} does not found");
                }

                string oldImage = existingPhoto.Image;

                if(photoToUpdate.ImageFile != null)
                {
                    if(photoToUpdate.ImageFile?.Length > 1 * 1024 * 1024)
                    {
                        return StatusCode(StatusCodes.Status400BadRequest, "File size should not exceed 1 MB");
                    }
                    List<string> allowedFileExtensions = new List<string> { ".jpg", ".jpeg", ".png" } ;
                    string createdImageName = await _fileService.SaveFileAsync(photoToUpdate.ImageFile, allowedFileExtensions);
                    photoToUpdate.ImageName = createdImageName;
                }

                existingPhoto.Id = photoToUpdate.Id;
                existingPhoto.RestaurantId = photoToUpdate.RestaurantId;
                existingPhoto.Image = photoToUpdate.ImageName;

                var updatedPhoto = await _photosRestaurantRepository.UpdatePhotosRestaurantAsync(existingPhoto);

                if(photoToUpdate.ImageFile != null)
                {
                    _fileService.DeleteFile(oldImage);
                }
                return Ok(updatedPhoto);
            }
            catch(Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpDelete("delete/{id}")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> DeletePhoto(int id)
        {
            try
            {
                var existingPhoto = await _photosRestaurantRepository.FindPhotoByIdAsync(id);
                if(existingPhoto == null) {
                    return BadRequest("Photo with this id not found");
                }

                await _photosRestaurantRepository.DeletePhotosRestaurantAsync(existingPhoto);

                _fileService.DeleteFile(existingPhoto.Image!);
                return Ok();
            }
            catch(Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("get/{id}")]
        [ProducesResponseType(200, Type = typeof(PhotosRestaurant))]
        public async Task<IActionResult> GetPhoto(int id)
        {
            var photo = await _photosRestaurantRepository.FindPhotoByIdAsync(id);
            if(photo == null)
            {
                return BadRequest("Photo with this id not found");
            }
            return Ok(photo);
        }

        [HttpGet]
        [ProducesResponseType(200, Type = typeof(PhotosRestaurant))]
        public async Task<IActionResult> GetPhotos()
        {
            var photos = await _photosRestaurantRepository.GetPhotosRestaurantsAsync();
            return Ok(photos);
        }
    }
}
