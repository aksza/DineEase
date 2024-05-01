using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class RatingRepository : IRatingRepository
    {
        private readonly DataContext _context;
        public RatingRepository(DataContext context)
        {
            _context = context;
        }
        public async Task<ICollection<Rating>> GetRatingsByUserId(int id)
        {
            return await _context.Ratings.Where(r => r.UserId == id).ToListAsync();
        }
    }
}
