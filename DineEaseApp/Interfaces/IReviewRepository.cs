using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IReviewRepository
    {
        Task<ICollection<Review>> GetReviewsByUserId(int userId);
        Task<ICollection<Review>> GetReviewsByRestaurantId(int restaurantId);
        Task<Review?> GetReviewById(int id);
        Task<bool> CreateReview(Review review);
        Task<bool> UpdateReview(Review review);
        Task<bool> DeleteReview(Review review);
        Task<bool> Save();
    }
}
