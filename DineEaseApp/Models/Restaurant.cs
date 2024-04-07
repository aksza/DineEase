namespace DineEaseApp.Models
{
    public class Restaurant
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public string Address { get; set; }
        public string PhoneNum { get; set; }
        public string Email { get; set; }
        public float Rating { get; set; }
        public int PriceId { get; set; }
        public Price Price { get; set; }
        public int Menu_id { get; set; }
        public Menu Menu { get; set; }
        public bool For_event { get; set; }
        public int Owner_id { get; set; }
        public Owner Owner { get; set; }
        public int MaxTableCap { get; set; }
        public int TaxIdNum { get; set; }
        public byte[]? BusinessLicense { get; set; }
        public ICollection<CuisinesRestaurant> CuisinesRestaurants { get; set; }
        public ICollection<Favorit> Favorits { get; set; }
        public ICollection<Meeting> Meetings { get; set; }
        public ICollection<Menu> Menus { get; set; }
        public ICollection<Opening> Openings { get; set; }
        public ICollection<Rating> Ratings { get; set; }
        public ICollection<Reservation> Reservations { get; set; }
        public ICollection<Review> Reviews { get; set; }
        public ICollection<SeatingsRestaurant> SeatingsRestaurants { get; set; }
        public ICollection<CategoriesRestaurant> CategoriesRestaurants { get; set; }
        public ICollection<PhotosRestaurant> PhotosRestaurants { get; set; }
        public ICollection<Event> Events { get; set; }
    }

}