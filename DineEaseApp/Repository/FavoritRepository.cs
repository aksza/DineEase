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

        public async Task<ICollection<Favorit>> GetFavoritsByUserId(int userId)
        {
            return await _context.Favorits.Where(f => f.UserId == userId).ToListAsync();
        }
    }
}
