namespace DineEaseApp.Models
{
    public class Meeting
    {
        public int Id { get; set; }
        public int EventId { get; set; }
        public Event Event { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public DateOnly EventDate { get; set; }
        public int GuestSize { get; set; }
        public DateOnly MeetingDate { get; set; }
        public TimeOnly MeetingTime { get; set; }
        public string PhoneNum { get; set; }
        public string Comment { get; set; }
    }
}