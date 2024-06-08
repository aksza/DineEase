using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class PhotosRestaurantRepository : IPhotosRestaurantRepository
    {
        private readonly DataContext _context;

        public PhotosRestaurantRepository(DataContext context)
        {
            _context = context;
        }

        public async Task<PhotosRestaurant> AddPhotosRestaurantAsync(PhotosRestaurant photo)
        {
            _context.PhotosRestaurants.Add(photo);
            await _context.SaveChangesAsync();
            return photo;
        }

        public async Task DeletePhotosRestaurantAsync(PhotosRestaurant photosRestaurant)
        {
            _context.PhotosRestaurants.Remove(photosRestaurant);
            await _context.SaveChangesAsync();
        }

        public async Task<PhotosRestaurant> FindPhotoByIdAsync(int id)
        {
            var photo = await _context.PhotosRestaurants.FindAsync(id);
            return photo;
        }

        public async Task<ICollection<PhotosRestaurant>?> GetPhotosByRestaurantId(int restaurantId)
        {
            var photo = await _context.PhotosRestaurants
                .Where(x => x.RestaurantId == restaurantId)
                .ToListAsync();

            return photo;
        }

        public async Task<IEnumerable<PhotosRestaurant>> GetPhotosRestaurantsAsync()
        {
            return await _context.PhotosRestaurants.ToListAsync();
        }

        public async Task<PhotosRestaurant> UpdatePhotosRestaurantAsync(PhotosRestaurant photo)
        {
            _context.PhotosRestaurants.Update(photo);
            await _context.SaveChangesAsync();
            return photo;
        }
    }
}
