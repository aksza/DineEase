using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class MeetingDto
    {
        public int Id { get; set; }
        //[ForeignKey("Event")]
        public int EventId { get; set; }
        //public EventTypeDto Event { get; set; }
        public string EventName { get; set; }
        //[ForeignKey("User")]
        public int UserId { get; set; }
        //public UserDto User { get; set; }
        //[ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public string RestaurantName { get; set; }
        //public RestaurantDto Restaurant { get; set; }
        public DateTime EventDate { get; set; }
        public int GuestSize { get; set; }
        public DateTime MeetingDate { get; set; }
        public string PhoneNum { get; set; }
        public string? Comment { get; set; }
        public bool? Accepted { get; set; }
        public string? RestaurantResponse { get; set; }
    }
}
