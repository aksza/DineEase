using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class CategoriesRestaurantRepository : Repository<CategoriesRestaurant>,ICategoriesRestaurantRepository
    {
        private DataContext _context;

        public CategoriesRestaurantRepository(DataContext context) : base(context)
        {
            _context = context;
        }

        public async Task<ICollection<CategoriesRestaurant>?> GetCategoriesRestaurantsByRestaurantId(int restaurantId)
        {
            var categories = await _context.CategoriesRestaurants
                .Where(x => x.RestaurantId == restaurantId)
                .ToListAsync();

            await Save();

            if(categories != null)
            {
                return categories;
            }

            return null;
        }
    }
}
