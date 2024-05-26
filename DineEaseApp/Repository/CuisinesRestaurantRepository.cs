using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class CuisinesRestaurantRepository : Repository<CuisinesRestaurant>,ICuisinesRestaurantRepository
    {
        private DataContext _context;

        public CuisinesRestaurantRepository(DataContext context) : base(context)
        {
            _context = context;
        }

        public async Task<ICollection<CuisinesRestaurant>?> GetCuisinesRestaurantsByRestaurantId(int restaurantId)
        {
            var cuisines = await _context.CuisinesRestaurants
                .Where(x => x.RestaurantId == restaurantId)
                .ToListAsync();

            await Save();

            if(cuisines != null)
            {
                return cuisines;
            }

            return null;
        }
    }
}
