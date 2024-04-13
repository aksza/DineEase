using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IRestaurantRepository
    {
        ICollection<Restaurant> GetRestaurants();
    }
}
