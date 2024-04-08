namespace DineEaseApp.Models
{
    public class CategoriesEvent
    {
        public int ECategoryId { get; set; }
        public int EventId { get; set; }
        public ECategory ECategory { get; set; } 
        public Event Event { get; set; }
    }
}