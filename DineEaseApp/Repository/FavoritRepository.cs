using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class FavoritRepository : IFavoritRepository
    {
        private readonly DataContext _context;

        public FavoritRepository(DataContext context)
        {
            _context = context;
        }

        public async Task<bool> AddToFavorits(Favorit favorit)
        {
            _context.Add(favorit);
            return await Save();
        }

        public async Task<Favorit?> GetFavoritByUserRestaurantId(int userId, int restaurantId)
        {
            var favorit = await _context.Favorits
                .Where(f => f.UserId == userId && f.RestaurantId == restaurantId)
                .FirstOrDefaultAsync();

            if (favorit != null)
            {
                return favorit;
            }

            return null;
                
        }

        public async Task<ICollection<Favorit>> GetFavoritsByUserId(int userId)
        {
            return await _context.Favorits.Where(f => f.UserId == userId).ToListAsync();
        }

        public async Task<bool> RemoveFavorits(Favorit favorit)
        {
            _context.Favorits.Remove(favorit);
            return await Save();
        }

        public async Task<bool> Save()
        {
            var saved = await _context.SaveChangesAsync();
            return saved > 0;
        }
    }
}
