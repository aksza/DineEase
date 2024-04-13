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

        public ICollection<Restaurant> GetRestaurants()
        {
            return _context.Restaurants.OrderBy(x => x.Id).ToList();
        }
    }
}
