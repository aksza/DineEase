using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IRatingRepository : IRepository<Rating>
    {
        Task<ICollection<Rating>> GetRatingsByUserId(int id);
        Task<Rating?> GetRatingByUserRestId(int userId,int restaurantId);
    }
}
