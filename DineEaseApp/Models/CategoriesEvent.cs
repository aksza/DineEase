using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class CategoriesEvent
    {
        [ForeignKey("ECategory")]
        public int ECategoryId { get; set; }
        [ForeignKey("Event")]
        public int EventId { get; set; }
        public ECategory ECategory { get; set; } 
        public Event Event { get; set; }
    }
}