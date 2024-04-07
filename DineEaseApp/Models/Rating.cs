namespace DineEaseApp.Models
{
    public class Rating
    {
        public int Id { get; set; }
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }
        public int RatingNumber { get; set; }
    }
}