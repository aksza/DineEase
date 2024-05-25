using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class OrderRepository : IOrderRepository
    {
        private DataContext _context;

        public OrderRepository(DataContext context)
        {
            _context = context;
        }

        public async Task<bool> AddOrder(Order order)
        {
            _context.Add(order);
            return await Save();
        }

        public async Task<bool> DeleteOrder(Order order)
        {
            _context.Remove(order);
            return await Save();
        }

        public async Task<Order?> GetOrderById(int id)
        {
            var order = await _context.Orders
                .Where(u => u.Id == id)
                .FirstOrDefaultAsync();

            await Save();
            if (order != null)
            {
                return order;
            }

            return null;
        }

        public async Task<ICollection<Order>?> GetOrdersByReservationId(int reservationID)
        {
            var order = await _context.Orders
                .Where(u => u.ReservationId == reservationID)
                .ToListAsync();

            await Save();
            if (order != null)
            {
                return order;
            }

            return null;
        }

        public async Task<bool> Save()
        {
            var saved = await _context.SaveChangesAsync();
            return saved > 0;
        }
    }
}
