using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IMenuRepository
    {
        Task<ICollection<Menu>> GetMenusByRestaurantId(int restaurantId);
        Task<Menu?> GetMenuById(int id);
        Task<bool> AddMenu(Menu menu);
        Task<bool> RemoveMenu(Menu menu);
        Task<bool> UpdateMenu(Menu menu);
        Task<bool> Save();
    }
}
