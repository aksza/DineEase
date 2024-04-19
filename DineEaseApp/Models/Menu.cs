using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class Menu
    {
        public int Id { get; set; }
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public string Name { get; set; }
        [ForeignKey("MenuType")]
        public int MenuTypeId { get; set; }
        public MenuType MenuType { get; set; }
        public string Ingredients { get; set; }
        public double Price { get; set; }
        public ICollection<Order>? Orders { get; set; }
    }
}