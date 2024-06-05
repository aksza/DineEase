namespace DineEaseApp.Dto
{
    public class EventCreateDto
    {
        public string EventName { get; set; }
        public int RestaurantId { get; set; }
        public string? Description { get; set; }
        public DateTime StartingDate { get; set; }
        public DateTime EndingDate { get; set; }
    }
}
