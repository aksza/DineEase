namespace DineEaseApp.Dto
{
    public class ReviewCreateDto
    {
        public int RestaurantId { get; set; }
        public int UserId { get; set; }
        public string Content { get; set; }
    }
}
