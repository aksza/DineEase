using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class EventDto
    {
        public int Id { get; set; }
        public string EventName { get; set; }
        public int RestaurantId { get; set; }
        public RestaurantDto Restaurant { get; set; }
        public string? Description { get; set; }
        public DateTime StartingDate { get; set; }
        public DateTime EndingDate { get; set; }
    }
}
