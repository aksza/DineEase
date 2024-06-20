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

        [HttpGet("getimage")]
        public async Task<IActionResult> ImageGet(string imageName)
        {
            try
            {
                string filePath = Path.Combine("E:\\egyetem\\allamvizsga\\DineEase\\dine_ease\\assets\\test_images", imageName);

                if (System.IO.File.Exists(filePath))
                {
                    var image = await System.IO.File.ReadAllBytesAsync(filePath);
                    string contentType = GetContentType(filePath);
                    return File(image, contentType);
                }
                else
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        private string GetContentType(string path)
        {
            var types = GetMimeTypes();
            var ext = Path.GetExtension(path).ToLowerInvariant();
            return types[ext];
        }

        private Dictionary<string, string> GetMimeTypes()
        {
            return new Dictionary<string, string>
            {
                {".jpg", "image/jpeg"},
                {".jpeg", "image/jpeg"},
                {".png", "image/png"},
            };
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

                List<string> allowedFileExtensions = new List<string> { ".jpg", ".jpeg", ".png" };
                string createdImageName = await _fileService.SaveFileAsync(photoToAdd.ImageFile, allowedFileExtensions);

                var photosRestaurant = new PhotosRestaurant
                {
                    RestaurantId = photoToAdd.RestaurantId,
                    Image = createdImageName
                };

                var createdPhoto = await _photosRestaurantRepository.AddPhotosRestaurantAsync(photosRestaurant);

                var photoResponse = new
                {
                    id = createdPhoto.Id,
                    restaurantId = createdPhoto.RestaurantId,
                    image = $"{this.Request.Scheme}://{this.Request.Host}{this.Request.PathBase}" +  Url.Action("ImageGet", new { imageName = createdPhoto.Image })
                };

                return Ok(photoResponse);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("getPhoto/{restaurantId}")]
        public async Task<IActionResult> GetPhotosByRestaurantId(int restaurantId)
        {
            var photos = await _photosRestaurantRepository.GetPhotosByRestaurantId(restaurantId);

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if(photos == null)
            {
                return BadRequest(ModelState);
            }
            var photoResponses = photos.Select(photo => new
            {
                id = photo.Id,
                restaurantId = photo.RestaurantId,
                image = $"{this.Request.Scheme}://{this.Request.Host}{this.Request.PathBase}" + Url.Action("ImageGet", new { imageName = photo.Image })
            }).ToList();

            return Ok(photoResponses);
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
