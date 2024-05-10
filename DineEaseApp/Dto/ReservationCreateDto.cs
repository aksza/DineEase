namespace DineEaseApp.Dto
{
    public class ReservationCreateDto
    {
        public int RestaurantId { get; set; }
        public int UserId { get; set; }
        public int PartySize { get; set; }
        public DateTime Date { get; set; }
        public string PhoneNum { get; set; }
        public bool Ordered { get; set; }
        public string? Comment { get; set; }
    }
}
