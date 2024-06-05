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
