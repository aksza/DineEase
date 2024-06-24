using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IOrderRepository : IRepository<Order>
    {
        Task<ICollection<Order>?> GetOrdersByReservationId(int reservationID);
    }
}
