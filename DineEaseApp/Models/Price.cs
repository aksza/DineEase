namespace DineEaseApp.Models
{
    public class Price
    {
        public int Id { get; set; }
        public string PriceName { get; set; }
        public ICollection<Restaurant> Restaurants { get; set; }
    }
}