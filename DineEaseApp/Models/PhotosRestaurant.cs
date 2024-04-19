using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class PhotosRestaurant
    {
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        [ForeignKey("Photo")]
        public int PhotoId { get; set; }
        public Restaurant Restaurant { get; set; }
        public Photo Photo { get; set; }
    }
}