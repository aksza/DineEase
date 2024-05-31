using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IOpeningRepository : IRepository<Opening>
    {
        Task<ICollection<Opening>?> GetOpeningsByRestaurantId(int restaurantId);
    }
}
