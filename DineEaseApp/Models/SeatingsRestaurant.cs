using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class SeatingsRestaurant
    {
        [ForeignKey("Seating")]
        public int SeatingId { get; set; }
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public Seating Seating { get; set; }
        public Restaurant Restaurant { get; set; }
    }
}