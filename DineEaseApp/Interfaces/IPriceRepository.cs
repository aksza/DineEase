using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IPriceRepository
    {
        ICollection<Price> GetPrices();
        Price GetPrice(int id);
        ICollection<Restaurant> GetRestaurantByPrice(int priceId);
        bool PriceExists(int id);
    }
}
