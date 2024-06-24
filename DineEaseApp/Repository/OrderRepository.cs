using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class OrderRepository : Repository<Order>,IOrderRepository
    {
        private DataContext _context;

        public OrderRepository(DataContext context) : base(context)
        {
            _context = context;
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

    }
}
