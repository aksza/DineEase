namespace DineEaseApp.Models
{
    public class User
    {
        public int Id { get; set; }
        public byte[] PasswordSalt { get; set; }
        public byte[] PasswordHash { get; set; }
        public string Email { get; set; }
        public string PhoneNum { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public ICollection<Favorit>? Favorits { get; set; }
        public ICollection<Meeting>? Meetings { get; set; }
        public ICollection<Rating>? Ratings { get; set; }
        public ICollection<Reservation>? Reservations { get; set; }
        public ICollection<Review>? Reviews { get; set; }

       
    }
}