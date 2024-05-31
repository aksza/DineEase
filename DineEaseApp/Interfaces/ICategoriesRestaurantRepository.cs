using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface ICategoriesRestaurantRepository : IRepository<CategoriesRestaurant>
    {
        Task<ICollection<CategoriesRestaurant>?> GetCategoriesRestaurantsByRestaurantId(int restaurantId); 
    }
}
