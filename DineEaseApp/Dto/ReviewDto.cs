using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class ReviewDto
    {
        public int Id { get; set; }
        public int RestaurantId { get; set; }
        public string RestaurantName { get; set; }
        public int UserId { get; set; }
        public string? UserName { get; set; }
        public string Content { get; set; }
    }
}
