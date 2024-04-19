using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class CategoriesRestaurant
    {
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        [ForeignKey("RCatergory")]
        public int RCategoryId { get; set; }
        public Restaurant Restaurant { get; set; }
        public RCategory RCategory { get; set; }
    }
}