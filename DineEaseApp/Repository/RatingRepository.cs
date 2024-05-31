using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class RatingRepository : Repository<Rating>, IRatingRepository
    {
        private readonly DataContext _context;
        public RatingRepository(DataContext context) : base (context)
        {
            _context = context;
        }

        public async Task<Rating?> GetRatingByUserRestId(int userId, int restaurantId)
        {
            return await _context.Ratings.Where(x => x.UserId == userId && x.RestaurantId == restaurantId).FirstOrDefaultAsync();
        }

        public async Task<ICollection<Rating>> GetRatingsByUserId(int id)
        {
            return await _context.Ratings.Where(r => r.UserId == id).ToListAsync();
        }
    }
}
