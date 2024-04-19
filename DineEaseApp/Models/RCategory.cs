namespace DineEaseApp.Models
{
    public class RCategory
    {
        public int Id { get; set; }
        public string RCategoryName { get; set; }
        public ICollection<CategoriesRestaurant> CategoriesRestaurants { get; set;}
    }
}