namespace DineEaseApp.Models
{
    public class CuisinesRestaurant
    {
        public int CuisineId { get; set; }
        public int RestaurantId { get; set; }
        public Cuisine Cuisine { get; set; }
        public Restaurant Restaurant { get; set; }
    }
}