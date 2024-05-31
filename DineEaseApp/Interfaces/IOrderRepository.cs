using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IOrderRepository : IRepository<Order>
    {
        Task<ICollection<Order>?> GetOrdersByReservationId(int reservationID);
        //Task<Order?> GetOrderById(int id);
        //Task<bool> AddOrder(Order order);
        //Task<bool> DeleteOrder(Order order);
        //Task<bool> Save();
    }
}
