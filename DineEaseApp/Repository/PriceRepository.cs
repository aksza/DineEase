using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;

namespace DineEaseApp.Repository
{
    public class PriceRepository :  Repository<Price>, IPriceRepository
    {
        private readonly DataContext _context;

        public PriceRepository(DataContext context) : base(context)
        {
            _context = context;
        }
        public Price GetPrice(int id)
        {
            return _context.Prices.Where(p => p.Id == id).FirstOrDefault();
        }

        public ICollection<Price> GetPrices()
        {
            return _context.Prices.OrderBy(x => x.Id).ToList();
        }

        public ICollection<Restaurant> GetRestaurantByPrice(int priceId)
        {
            return _context.Restaurants.Where(r => r.PriceId == priceId).ToList();
        }

        public bool PriceExists(int id)
        {
            return _context.Prices.Any(x => x.Id == id);
        }
    }
}
