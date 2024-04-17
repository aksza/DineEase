using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class MenuDto
    {
        public int Id { get; set; }
        //[ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public RestaurantDto Restaurant { get; set; }
        public string Name { get; set; }
        //[ForeignKey("MenuType")]
        public int MenuTypeId { get; set; }
        public MenuTypeDto MenuType { get; set; }
        public string Ingredients { get; set; }
        public double Price { get; set; }
    }
}
