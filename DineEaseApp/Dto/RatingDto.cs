using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class RatingDto
    {
        public int Id { get; set; }
        //[ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public RestaurantDto Restaurant { get; set; }
        //[ForeignKey("User")]
        public int UserId { get; set; }
        public UserDto User { get; set; }
        public int RatingNumber { get; set; }
    }
}
