namespace DineEaseApp.Dto
{
    public class PhotosRestaurantDto
    {
        public int RestaurantId { get; set; }
        public IFormFile? ImageFile { get; set; }
    }
    public class PhotosRestaurantUpdateDto
    {
        public int Id { get; set; }

        public int RestaurantId { get; set; }
        public string? ImageName { get; set; }
        public IFormFile? ImageFile { get; set; }
    }
}
