using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IFavoritRepository
    {
        Task<ICollection<Favorit>> GetFavoritsByUserId(int userId);
        Task<Favorit?> GetFavoritByUserRestaurantId(int userId,int restaurantId);
        Task<bool> AddToFavorits(Favorit favorit);
        Task<bool> RemoveFavorits(Favorit favorit);
    }
}
