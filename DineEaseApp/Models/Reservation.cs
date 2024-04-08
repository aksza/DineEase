namespace DineEaseApp.Models
{
    public class Reservation
    {
        public int Id { get; set; }
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }
        public int PartySize { get; set; }
        public DateTime Date { get; set; }
        //public TimeOnly Time { get; set; }
        public string PhoneNum { get; set; }
        public bool Ordered { get; set; }
        public int? OrderId { get; set; }
        public Order? Order { get; set; }
        public string? Comment { get; set; }
        public bool? Accepted { get; set; }
        public string? RestaurantResponse { get; set; }
    }
}