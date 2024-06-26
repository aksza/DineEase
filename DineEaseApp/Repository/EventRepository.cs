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
            var events = await _context.Events
                .Include(e => e.Restaurant)
                .Where(e => e.StartingDate.Date >= DateTime.Today)
                .OrderBy(e => e.StartingDate)
                .ToListAsync();

            return events;
        }

        public async Task<ICollection<Event>> GetEventsByFavoritAsync(int userId)
        {
            var today = DateTime.Today;

            var favoriteRestaurantIds = await _context.Favorits
                .Where(f => f.UserId == userId)
                .Select(f => f.RestaurantId)
                .ToListAsync();

            var events = await _context.Events
                .Include(e => e.Restaurant)
                .Where(e => e.StartingDate.Date >= today && favoriteRestaurantIds.Contains(e.RestaurantId))
                .OrderBy(e => e.StartingDate)
                .ToListAsync();

            var otherEvents = await _context.Events
                .Include(e => e.Restaurant)
                .Where(e => e.StartingDate.Date >= today && !favoriteRestaurantIds.Contains(e.RestaurantId))
                .OrderBy(e => e.StartingDate)
                .ToListAsync();

            var result = events.Concat(otherEvents).ToList();

            return result;
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

        public async Task<ICollection<int>> EventsPerWeekByRestaurantId(int restaurantId)
        {
            DateTime fiveweeks = DateTime.Today.AddDays(-35);

            var events = await _context.Events
                .Where(e => e.RestaurantId == restaurantId && e.StartingDate >= fiveweeks)
                .ToListAsync();

            var eventsPerWeek = new List<int>();

            int count; 
            for ( int i = 0; i < 5; i++ )
            {
                count = 0;
                DateTime start = DateTime.Today.AddDays(-i * 7).Date;
                DateTime end = start.AddDays(7).Date;

                count = events.Count(e => start <= e.StartingDate && e.StartingDate < end);

                eventsPerWeek.Add(count);
            }

            eventsPerWeek.Reverse();

            return eventsPerWeek;
        }
    }
}
