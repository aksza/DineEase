namespace DineEaseApp.Models
{
    public class SeatingsRestaurant
    {
        public int SeatingId { get; set; }
        public int RestaurantId { get; set; }
        public Seating Seating { get; set; }
        public Restaurant Restaurant { get; set; }
    }
}