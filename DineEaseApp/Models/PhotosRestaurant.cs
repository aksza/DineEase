namespace DineEaseApp.Models
{
    public class PhotosRestaurant
    {
        public int RestaurantId { get; set; }
        public int PhotoId { get; set; }
        public Restaurant Restaurant { get; set; }
        public Photo Photo { get; set; }
    }
}