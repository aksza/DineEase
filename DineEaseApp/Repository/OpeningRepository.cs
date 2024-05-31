using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class OpeningRepository : Repository<Opening>, IOpeningRepository
    {
        private DataContext _context;

        public OpeningRepository(DataContext context) : base(context)
        {
            _context = context;
        }

        public async Task<ICollection<Opening>?> GetOpeningsByRestaurantId(int restaurantId)
        {
            var openings = await _context.Openings
                 .Where(x => x.RestaurantId == restaurantId)
                 .ToListAsync();

            await Save();

            if(openings != null)
            {
                return openings;
            }
            return null;
        }
    }
}
