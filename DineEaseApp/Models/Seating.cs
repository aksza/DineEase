namespace DineEaseApp.Models
{
    public class Seating
    {
        public int Id { get; set; }
        public string SeatingName { get; set; }
        public ICollection<SeatingsRestaurant> SeatingsRestaurants { get; set; }
    }
}