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

        //public async Task<bool> AddMenu(Menu menu)
        //{
        //    _context.Add(menu);
        //    return await Save();
        //}

        //public async Task<Menu?> GetMenuById(int id)
        //{
        //    var menu = await _context.Menus
        //        .Where(x => x.Id == id)
        //        .FirstOrDefaultAsync();

        //    await Save();

        //    if(menu != null)
        //    {
        //        return menu;
        //    }
        //    return null;

        //}

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

        //public async Task<bool> RemoveMenu(Menu menu)
        //{
        //    _context.Remove(menu);
        //    return await Save();
        //}

        //public async Task<bool> Save()
        //{
        //    var saved = await _context.SaveChangesAsync();
        //    return saved > 0;
        //}

        //public async Task<bool> UpdateMenu(Menu menu)
        //{
        //    _context.Update(menu);
        //    return await Save();
        //}
    }
}
