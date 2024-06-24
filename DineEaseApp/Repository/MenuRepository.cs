using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class MenuRepository : Repository<Menu>,IMenuRepository
    {
        private DataContext _context;

        public MenuRepository(DataContext context) : base(context) 
        {
            _context = context;
        }

        public async Task<ICollection<Menu>?> GetMenusByRestaurantId(int restaurantId)
        {
            var menus = await _context.Menus
                .Where(x => x.RestaurantId == restaurantId)
                .ToListAsync();

            await Save();
            if(menus != null)
            {
                return menus;
            }

            return null;
        }

    }
}
