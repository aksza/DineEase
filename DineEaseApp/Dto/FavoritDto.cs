using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class FavoritDto
    {
        public int UserId { get; set; }
        public int RestaurantId { get; set; }
    }
}
