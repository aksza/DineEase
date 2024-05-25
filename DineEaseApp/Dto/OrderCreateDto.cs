namespace DineEaseApp.Dto
{
    public class OrderCreateDto
    {
        public int MenuId { get; set; }
        public string? Comment { get; set; }
        public int ReservationId { get; set; }
    }
}
