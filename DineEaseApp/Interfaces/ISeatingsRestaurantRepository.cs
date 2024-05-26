using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface ISeatingsRestaurantRepository : IRepository<SeatingsRestaurant>
    {
        Task<ICollection<SeatingsRestaurant>?> GetSeatingsRestaurantsByRestaurantId(int restaurantId);
    }
}
