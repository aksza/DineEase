using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class CategoriesEventRepository : Repository<CategoriesEvent>,ICategoriesEventRepository
    {
        private DataContext _context;

        public CategoriesEventRepository(DataContext context) : base(context)
        {
            _context = context;
        }

        public async Task<ICollection<CategoriesEvent>?> GetCategoriesEventsByEventId(int eventId)
        {
            var categories = await _context.CategoriesEvents
                .Where(x => x.EventId == eventId)
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
