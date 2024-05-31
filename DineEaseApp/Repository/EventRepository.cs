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

        public Task<List<Event>?> SearchEvents(string someText)
        {
            var result = _context.Events
                .Where(r => EF.Functions.Like(r.EventName, $"%{someText}%") ||
                            EF.Functions.Like(r.Description, $"%{someText}%"))
                .ToListAsync();

            return result;
        }
    }
}
