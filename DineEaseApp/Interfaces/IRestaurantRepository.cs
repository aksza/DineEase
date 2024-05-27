using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IRestaurantRepository
    {
        Task<ICollection<Restaurant>> GetRestaurants();
        Task<Restaurant?> GetRestaurantWithDetailsAsync(int restaurantId);
        Task<Restaurant?> GetRestaurantById(int id);
        Task<Restaurant> GetRestaurantByEmail(string email);
        Task<bool> CreateRestaurant(Restaurant restaurant);
        Task<bool> UpdateRestaurant(Restaurant restaurant);
        Task<bool> DeleteRestaurant(Restaurant restaurant);
        Task<bool> Save();
        Task<ICollection<Restaurant>> GetRestaurantByName(string name);
        Task<bool> UpdateRestaurantRating(Restaurant restaurant);
        double GetRestaurantRating(int id);
        bool RestaurantExists(int id);
    }
}
