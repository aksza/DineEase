namespace DineEaseApp.Dto
{
    public class RestaurantCreateDto
    {
        public string Name { get; set; }
        public string? Description { get; set; }
        public string Address { get; set; }
        public string PhoneNum { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public int PriceId { get; set; }
        public bool ForEvent { get; set; }
        public OwnerDto Owner { get; set; }
        public int MaxTableCap { get; set; }
        public int TaxIdNum { get; set; }
    }
}
