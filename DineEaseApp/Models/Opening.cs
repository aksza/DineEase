namespace DineEaseApp.Models
{
    public class Opening
    {
        public int Id { get; set; }
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public TimeOnly OpeningHour { get; set; }
        public TimeOnly ClosingHour { get; set; }
        public DayOfWeek day { get; set; }
    }
}