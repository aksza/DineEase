using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IRestaurantRepository
    {
        ICollection<Restaurant> GetRestaurants();
        Restaurant GetRestaurantById(int id);
        ICollection<Restaurant> GetRestaurantForEvent();
        ICollection<Restaurant> GetRestaurantByName(string name);
        double GetRestaurantRating(int id);
        bool RestaurantExists(int id);
    }
}
