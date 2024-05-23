using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class ReviewRepository : IReviewRepository
    {
        private readonly DataContext _context;
        public ReviewRepository(DataContext context)
        {
            _context = context;
        }

        public async Task<bool> CreateReview(Review review)
        {
            _context.Add(review);
            return await Save();
        }

        public async Task<bool> DeleteReview(Review review)
        {
            _context.Remove(review);
            return await Save();
        }

        public async Task<Review?> GetReviewById(int id)
        {
            var review = await _context.Reviews
                .Where(review => review.Id == id)
                .FirstOrDefaultAsync();

            await Save();
            if(review != null)
            {
                return review;
            }

            return null;
        }

        public async Task<ICollection<Review>> GetReviewsByRestaurantId(int restaurantId)
        {
            return await _context.Reviews.Where(r => r.RestaurantId == restaurantId).ToListAsync();
        }

        public async Task<ICollection<Review>> GetReviewsByUserId(int userId)
        {
            return await _context.Reviews.Where(r => r.UserId == userId).ToListAsync();
        }

        public async Task<bool> Save()
        {
            var saved = await _context.SaveChangesAsync();
            return saved > 0;
        }

        public async Task<bool> UpdateReview(Review review)
        {
            _context.Update(review);
            return await Save();
        }
    }
}
