using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IFavoritRepository
    {
        Task<ICollection<Favorit>> GetFavoritsByUserId(int userId);
    }
}
