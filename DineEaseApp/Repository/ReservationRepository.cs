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
    }
}
