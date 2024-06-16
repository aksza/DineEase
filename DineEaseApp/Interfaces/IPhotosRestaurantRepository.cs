using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IPhotosRestaurantRepository
    {
        Task<PhotosRestaurant> AddPhotosRestaurantAsync(PhotosRestaurant photo);
        Task<PhotosRestaurant> UpdatePhotosRestaurantAsync(PhotosRestaurant photo);
        Task<IEnumerable<PhotosRestaurant>> GetPhotosRestaurantsAsync();
        Task<PhotosRestaurant> FindPhotoByIdAsync(int id);
        Task<ICollection<PhotosRestaurant>?> GetPhotosByRestaurantId(int restaurantId);
        Task DeletePhotosRestaurantAsync(PhotosRestaurant photosRestaurant);
    }
}
