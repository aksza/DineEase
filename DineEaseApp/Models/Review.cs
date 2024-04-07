namespace DineEaseApp.Models
{
    public class Review
    {
        public int Id { get; set; }
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }
        public string Content { get; set; }
    }
}