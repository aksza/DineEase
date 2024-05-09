using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class EventRepository : IEventRepository
    {
        private DataContext _context;

        public EventRepository(DataContext context)
        {
            _context = context;
        }

        public async Task<ICollection<Event>> GetEventsAsync()
        {
            return await _context.Events.ToListAsync();
        }

        public Task<ICollection<Event>> GetEventsByUserFavorits()
        {
            throw new NotImplementedException();
        }
    }
}
