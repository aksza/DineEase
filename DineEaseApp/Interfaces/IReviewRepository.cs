using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IReviewRepository
    {
        Task<ICollection<Review>> GetReviewsByUserId(int userId);
    }
}
