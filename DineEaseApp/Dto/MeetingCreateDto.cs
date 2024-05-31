namespace DineEaseApp.Dto
{
    public class MeetingCreateDto
    {
        public int UserId { get; set; }
        public int RestaurantId { get; set; }
        public int EventId { get; set; }
        public DateTime EventDate { get; set; }
        public int GuestSize { get; set; }
        public DateTime MeetingDate { get; set; }
        public string PhoneNum { get; set; }
        public string? Comment { get; set; }
    }
}
