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

        //public string GetRestaurantAddress(int id)
        //{
        //    throw new NotImplementedException();

        //}

        //public byte[] GetRestaurantBusinessLicense(int id)
        //{
        //    throw new NotImplementedException();
        //}

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

        public Task<ICollection<Restaurant>> GetRestaurantForEvent()
        {
            throw new NotImplementedException();
        }

        //public string GetRestaurantDescription(int id)
        //{
        //    throw new NotImplementedException();
        //}

        //public string GetRestaurantEmail(int id)
        //{
        //    throw new NotImplementedException();
        //}

        //public ICollection<Restaurant> GetRestaurantForEvent()
        //{
        //    throw new NotImplementedException();
        //}

        //public int GetRestaurantMaxTableCap(int id)
        //{
        //    throw new NotImplementedException();
        //}

        //public string GetRestaurantName(int id)
        //{
        //    throw new NotImplementedException();
        //}

        //public Owner GetRestaurantOwner(int id)
        //{
        //    throw new NotImplementedException();
        //}

        //public string GetRestaurantPhoneNum(int id)
        //{
        //    throw new NotImplementedException();
        //}

        //public Price GetRestaurantPrice(int id)
        //{
        //    throw new NotImplementedException();
        //}

        public double GetRestaurantRating(int id)
        {
            var rating = _context.Ratings.Where(r => r.Id == id);

            if(rating.Count() <= 0)
            {
                return 0;
            }
            return ((double)rating.Sum(r => r.RatingNumber) / rating.Count());

        }

        public async Task<ICollection<Restaurant>> GetRestaurants()
        {
            return await _context.Restaurants.ToListAsync();
        }

        public async Task<Restaurant> GetRestaurantByEmail(string email)
        {
            return await _context.Restaurants.Where(r => r.Email == email).FirstOrDefaultAsync();
        }

        //public int GetRestaurantTaxNum(int id)
        //{
        //    throw new NotImplementedException();
        //}

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
    }
}
