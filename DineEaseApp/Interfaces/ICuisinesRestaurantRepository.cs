using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface ICuisinesRestaurantRepository : IRepository<CuisinesRestaurant>
    {
        Task<ICollection<CuisinesRestaurant>?> GetCuisinesRestaurantsByRestaurantId(int restaurantId);
    }
}
