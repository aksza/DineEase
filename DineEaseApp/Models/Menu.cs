namespace DineEaseApp.Models
{
    public class Menu
    {
        public int Id { get; set; }
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public string Name { get; set; }
        public int MenuTypeId { get; set; }
        public MenuType MenuType { get; set; }
        public string Ingredients { get; set; }
        public ICollection<Order> Orders { get; set; }
        public ICollection<Restaurant> Restaurants { get; set;}
    }
}