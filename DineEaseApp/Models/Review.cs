using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class Review
    {
        public int Id { get; set; }
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        [ForeignKey("User")]
        public int UserId { get; set; }
        public User User { get; set; }
        public string Content { get; set; }
    }
}