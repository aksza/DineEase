using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class RatingDto
    {
        public int Id { get; set; }
        public int RestaurantId { get; set; }
        public string? RestaurantName { get; set; }
        public int UserId { get; set; }
        public int RatingNumber { get; set; }
    }
}
