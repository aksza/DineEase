namespace DineEaseApp.Dto
{
    public class RatingCreateDto
    {
        public int RestaurantId { get; set; }
        public int UserId { get; set; }
        public int RatingNumber { get; set; }
    }
}
