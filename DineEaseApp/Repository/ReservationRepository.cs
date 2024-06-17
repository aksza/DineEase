using DineEaseApp.Data;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class ReservationRepository : IReservationRepository
    {
        private readonly DataContext _context;
        public ReservationRepository(DataContext context)
        {
            _context = context;
        }

        public async Task<ICollection<int>> AverageDailyReservationsByRestaurantId(int restaurantId)
        {
            var reservations = await _context.Reservations
                .Where(r => r.RestaurantId == restaurantId)
                .ToListAsync();

            var resByDays = reservations.GroupBy(r => r.Date.DayOfWeek)
                .Select(g => new { DayOfWeek = g.Key, Count = g.Count() })
                .OrderBy(g => g.DayOfWeek)
                .ToList();

            var avgDailyRes = new List<int>(new int[7]);

            foreach (var res in resByDays)
            {
                avgDailyRes[(int)res.DayOfWeek] = res.Count;
            }

            return avgDailyRes;

        }

        public async Task<ICollection<int>> AverageReservationsLastMonthByRestaurantId(int restaurantId)
        {
            var lastMonth = DateTime.Today.AddDays(-30); // utobbi 30 nap

            var reservations = await _context.Reservations
                .Where(r => r.RestaurantId == restaurantId && r.Date >= lastMonth)
                .ToListAsync();

            var resCount = new List<int>(new int[30]);

            foreach(var res in reservations){
                int thirtyDaysAgo = (res.Date.Date - lastMonth).Days;
                if(thirtyDaysAgo >= 0 && thirtyDaysAgo < 30) 
                {
                    resCount[thirtyDaysAgo]++;
                }
            }

            return resCount;

        }

        public async Task<ICollection<int>> AverageReservationsPerHoursByRestaurantId(int restaurantId)
        {
            var reservations = await _context.Reservations
                .Where(r => r.RestaurantId == restaurantId)
                .ToListAsync();

            var resCount = new List<int>(new int[24]);

            foreach(var res in reservations)
            {
                int hour = res.Date.Hour;
                resCount[hour]++;
            }

            return resCount;
        }

        public async Task<Reservation?> GetReservationById(int id)
        {
            var reservation = await _context.Reservations
                .Where(r => r.Id == id)
                .FirstOrDefaultAsync();

            if(reservation != null)
            {
                return reservation;
            }

            return null;
        }

        public async Task<ICollection<Reservation>?> GetReservationsByRestaurantId(int id)
        {
            var reservations = await _context.Reservations
                .Where(r => r.RestaurantId == id)
                .ToListAsync();

            if(reservations != null)
            {
                return reservations;
            }
            return null;
        }

        public async Task<ICollection<Reservation>> GetReservationsByUserId(int userId)
        {
            return await _context.Reservations.Where(r => r.UserId == userId).ToListAsync();
        }

        public async Task<ICollection<int>> OrdersPerReservationsByRestaurantId(int restaurantId)
        {
            var reservations = await _context.Reservations
                 .Where(r => r.RestaurantId == restaurantId)
                 .ToListAsync();

            int total = reservations.Count;

            int ordered = reservations.Count(r => r.Ordered == true);

            return new List<int> { total, ordered };
        }

        public async Task<bool> PostReservation(Reservation reservation)
        {
            _context.Add(reservation);
            return await Save();
        }

        public async Task<bool> Save()
        {
            var saved = await _context.SaveChangesAsync();
            return saved > 0;
        }

        public async Task<bool> UpdateReservation(Reservation reservation)
        {
            _context.Update(reservation);
            return await Save();
        }
    }
}
