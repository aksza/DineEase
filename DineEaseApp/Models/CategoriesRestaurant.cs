namespace DineEaseApp.Models
{
    public class CategoriesRestaurant
    {
        public int RestaurantId { get; set; }
        public int RCategoryId { get; set; }
        public Restaurant Restaurant { get; set; }
        public RCategory RCategory { get; set; }
    }
}