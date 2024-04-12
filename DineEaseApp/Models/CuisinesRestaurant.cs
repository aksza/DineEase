using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class CuisinesRestaurant
    {
        [ForeignKey("Cuisine")]
        public int CuisineId { get; set; }
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public Cuisine Cuisine { get; set; }
        public Restaurant Restaurant { get; set; }
    }
}