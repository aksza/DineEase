using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class Meeting
    {
        public int Id { get; set; }
        [ForeignKey("Event")]
        public int EventId { get; set; }
        public EventType Event { get; set; }
        [ForeignKey("User")]
        public int UserId { get; set; }
        public User User { get; set; }
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public DateTime EventDate { get; set; }
        public int GuestSize { get; set; }
        public DateTime MeetingDate { get; set; }
        public string PhoneNum { get; set; }
        public string? Comment { get; set; }
        public bool? Accepted { get; set; }
        public string? RestaurantResponse { get; set; }
    }
}