using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;

namespace DineEaseApp.Repository
{
    public class RestaurantRepository : IRestaurantRepository
    {
        private readonly DataContext _context;
        public RestaurantRepository(DataContext context) 
        { 
            _context = context;
        }

        public string GetRestaurantAddress(int id)
        {
            throw new NotImplementedException();

        }

        public byte[] GetRestaurantBusinessLicense(int id)
        {
            throw new NotImplementedException();
        }

        public Restaurant GetRestaurantById(int id)
        {
            return _context.Restaurants.Where(r => r.Id == id).FirstOrDefault();
        }

        public ICollection<Restaurant> GetRestaurantByName(string name)
        {
            return _context.Restaurants.Where(r => r.Name == name).ToList();
        }

        public string GetRestaurantDescription(int id)
        {
            throw new NotImplementedException();
        }

        public string GetRestaurantEmail(int id)
        {
            throw new NotImplementedException();
        }

        public ICollection<Restaurant> GetRestaurantForEvent()
        {
            throw new NotImplementedException();
        }

        public int GetRestaurantMaxTableCap(int id)
        {
            throw new NotImplementedException();
        }

        public string GetRestaurantName(int id)
        {
            throw new NotImplementedException();
        }

        public Owner GetRestaurantOwner(int id)
        {
            throw new NotImplementedException();
        }

        public string GetRestaurantPhoneNum(int id)
        {
            throw new NotImplementedException();
        }

        public Price GetRestaurantPrice(int id)
        {
            throw new NotImplementedException();
        }

        public double GetRestaurantRating(int id)
        {
            var rating = _context.Ratings.Where(r => r.Id == id);

            if(rating.Count() <= 0)
            {
                return 0;
            }
            return ((double)rating.Sum(r => r.RatingNumber) / rating.Count());

        }

        public ICollection<Restaurant> GetRestaurants()
        {
            return _context.Restaurants.OrderBy(x => x.Id).ToList();
        }

        public int GetRestaurantTaxNum(int id)
        {
            throw new NotImplementedException();
        }

        public bool RestaurantExists(int id)
        {
            return _context.Restaurants.Any(r => r.Id == id);
        }
    }
}
