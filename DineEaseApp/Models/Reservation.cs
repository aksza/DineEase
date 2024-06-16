using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class Reservation
    {
        public int Id { get; set; }
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        [ForeignKey("User")]
        public int UserId { get; set; }
        public User User { get; set; }
        public int PartySize { get; set; }
        public DateTime Date { get; set; }
        //public TimeOnly Time { get; set; }
        public string PhoneNum { get; set; }
        public bool Ordered { get; set; }
        //public int? OrderId { get; set; }
        //public Order? Order { get; set; }
        public int TableNumber { get; set; }
        public string? Comment { get; set; }
        public bool? Accepted { get; set; }
        public string? RestaurantResponse { get; set; }
        public ICollection<Order>? Orders { get; set; }
    }
}