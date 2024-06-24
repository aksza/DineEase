using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class MenuDto
    {
        public int Id { get; set; }
        public int RestaurantId { get; set; }
        public string Name { get; set; }
        public int MenuTypeId { get; set; }
        public string MenuTypeName { get; set; }
        public string Ingredients { get; set; }
        public double Price { get; set; }
    }
}
