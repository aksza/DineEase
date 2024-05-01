using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IRatingRepository
    {
        Task<ICollection<Rating>> GetRatingsByUserId(int id);
    }
}
