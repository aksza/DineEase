﻿using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class EventRepository : Repository<Event>, IEventRepository
    {
        private DataContext _context;

        public EventRepository(DataContext context) : base (context) 
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

        public async Task<ICollection<Event>?> GetFutureEventsByRestaurantId(int restaurantId)
        {
            var e = await _context.Events
                .Where(e => e.RestaurantId == restaurantId && e.StartingDate > DateTime.Now)
                .ToListAsync();

            if(e != null)
            {
                return e;
            }

            return null;
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

        public async Task<ICollection<Event>?> GetOldEventsByRestaurantId(int restaurantId) 
        {
            var e = await _context.Events
                .Where(e => e.RestaurantId == restaurantId && e.StartingDate <= DateTime.Now)
                .ToListAsync();

            if (e != null)
            {
                return e;
            }

            return null;
        }
    }
}
