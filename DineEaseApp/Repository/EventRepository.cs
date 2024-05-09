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

        public async Task<Event?> GetEventById(int id)
        {
            var eventt = await _context.Events
                .Where(e => e.Id == id)
                .FirstOrDefaultAsync();

            if(eventt != null)
            {
                return eventt;
            }

            return null;
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
