﻿using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class SeatingsRestaurantRepository : Repository<SeatingsRestaurant>,ISeatingsRestaurantRepository
    {
        private DataContext _context;

        public SeatingsRestaurantRepository(DataContext context) : base(context) 
        {
            _context = context;
        }

        public async Task<ICollection<SeatingsRestaurant>?> GetSeatingsRestaurantsByRestaurantId(int restaurantId)
        {
            var seatings = await _context.SeatingsRestaurants
                .Where(x => x.RestaurantId == restaurantId)
                .ToListAsync();

            await Save();

            if(seatings != null)
            {
                return seatings;
            }

            return null;
        }
    }
}
