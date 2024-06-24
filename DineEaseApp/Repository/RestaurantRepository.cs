using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class RestaurantRepository : IRestaurantRepository
    {
        private readonly DataContext _context;
        public RestaurantRepository(DataContext context) 
        { 
            _context = context;
        }

        public async Task<bool> CreateRestaurant(Restaurant restaurant)
        {
            _context.Add(restaurant);
            return await Save();
        }

        public async Task<bool> DeleteRestaurant(Restaurant restaurant)
        {
            _context.Remove(restaurant);
            return await Save();
        }

        public async Task<ICollection<Restaurant>> GetRestaurantsWithMostReservation()
        {
            var oneWeekAgo = DateTime.Now.AddDays(-7);

            var result = await _context.Reservations
            .Where(r => r.Date >= oneWeekAgo)
            .GroupBy(r => r.RestaurantId)
            .OrderByDescending(g => g.Count())
            .Take(3)
            .Select(g => g.Key)
            .ToListAsync();

            var res = await _context.Restaurants
                .Where(r => result.Contains(r.Id))
                .ToListAsync();

            return res;
        }

        public async Task<ICollection<Restaurant>> LastFiveReservationByUserId(int userId)
        {
            var result = await _context.Reservations
                .Where(r => r.UserId == userId)
                .OrderByDescending(r => r.Date)
                .Select(r => r.RestaurantId)
                .Distinct()
                .Take(3)
                .ToListAsync();

            var res = await _context.Restaurants
                .Where(r => result.Contains(r.Id))
                .ToListAsync();

            return res;
        }

        public async Task<Restaurant?> GetRestaurantWithDetailsAsync(int restaurantId)
        {
            return await _context.Restaurants
                .Include(r => r.CuisinesRestaurants)
                .Include(r => r.Openings)
                .Include(r => r.SeatingsRestaurants)
                .Include(r => r.CategoriesRestaurants)
                .FirstOrDefaultAsync(r => r.Id == restaurantId);
        }

        public async Task<Restaurant?> GetRestaurantById(int id)
        {
            var restaurant =  await _context.Restaurants
                .Where(r => r.Id == id)
                .Select(r => new { Restaurant = r })
                .FirstOrDefaultAsync();
            
            if(restaurant != null) 
            {
                return restaurant.Restaurant;
            }
            return null;
        }

        public async Task<ICollection<Restaurant>> GetRestaurantByName(string name)
        {
            return await _context.Restaurants.Where(r => r.Name == name).ToListAsync();
        }

        public async Task<double?> GetRestaurantRating(int id)
        {
            var rating = await _context.Ratings.Where(r => r.Id == id).ToListAsync();

            if(rating.Count() <= 0)
            {
                return null;
            }
            return (double)((double)rating.Sum(r => r.RatingNumber) / (double)rating.Count());

        }

        public async Task<ICollection<Restaurant>> GetRestaurants()
        {
            return await _context.Restaurants.ToListAsync();
        }

        public async Task<Restaurant> GetRestaurantByEmail(string email)
        {
            return await _context.Restaurants.Where(r => r.Email == email).FirstOrDefaultAsync();
        }

        public bool RestaurantExists(int id)
        {
            return _context.Restaurants.Any(r => r.Id == id);
        }

        public async Task<bool> Save()
        {
            var saved = await _context.SaveChangesAsync();
            return saved > 0;
        }

        public async Task<bool> UpdateRestaurant(Restaurant restaurant)
        {
            _context.Update(restaurant);
            return await Save();
        }

        public async Task<bool> UpdateRestaurantRating(Restaurant restaurant)
        {
            double ratingAverage = await _context.Ratings
                .Where(x => x.RestaurantId == restaurant.Id)
                .AverageAsync(x => x.RatingNumber);

            string formattedRating = (ratingAverage).ToString("0.0");

            double roundedRating = double.Parse(formattedRating);

            restaurant.Rating = roundedRating;
            _context.Update(restaurant);
            return await Save();
        }

        public Task<List<Restaurant>?> SearchRestaurants(string someText)
        {
            var result = _context.Restaurants
                .Where(r => EF.Functions.Like(r.Name, $"%{someText}%") ||
                            EF.Functions.Like(r.Description, $"%{someText}%") ||
                            EF.Functions.Like(r.Address, $"%{someText}%"))
                .ToListAsync();

            return result;
        }

        public async Task<ICollection<Restaurant>> FiveMostRated()
        {
            var result = await _context.Restaurants
                .OrderByDescending(r => r.Rating)
                .Take(3)
                .ToListAsync();

            return result;
        }
    }
}
