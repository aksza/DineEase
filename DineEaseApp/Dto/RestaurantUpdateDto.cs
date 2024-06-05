namespace DineEaseApp.Dto
{
    public class RestaurantUpdateDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public string Address { get; set; }
        public string PhoneNum { get; set; }
        public string Email { get; set; }
        public int PriceId { get; set; }
        public bool ForEvent { get; set; }
        public int OwnerId { get; set; }
        public int MaxTableCap { get; set; }
    }
}
