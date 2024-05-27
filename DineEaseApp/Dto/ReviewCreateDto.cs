namespace DineEaseApp.Dto
{
    public class ReviewCreateDto
    {
        public int? Id { get; set; }
        public int RestaurantId { get; set; }
        public int UserId { get; set; }
        public string Content { get; set; }
    }
}
