using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class Event
    {
        public int Id { get; set; }
        public string EventName { get; set; }
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public string? Description { get; set; }
        public DateTime StartingDate { get; set; }
        public DateTime EndingDate { get; set;}
        public ICollection<CategoriesEvent> CategoriesEvents { get; set; }
    }
}