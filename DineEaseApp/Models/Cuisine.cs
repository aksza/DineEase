namespace DineEaseApp.Models
{
    public class Cuisine
    {
        public int Id { get; set; }
        public string CuisineName { get; set; }
        public ICollection<CuisinesRestaurant> CuisinesRestaurants { get; set; }
    }
}