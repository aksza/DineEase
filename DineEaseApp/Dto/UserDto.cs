using DineEaseApp.Models;

namespace DineEaseApp.Dto
{
    public class UserDto
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string PhoneNum { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public bool Admin { get; set; }
        //public ICollection<FavoritDto>? Favorits { get; set; }
        //public ICollection<MeetingDto>? Meetings { get; set; }
        //public ICollection<RatingDto>? Ratings { get; set; }
        //public ICollection<ReservationDto>? Reservations { get; set; }
        //public ICollection<ReviewDto>? Reviews { get; set; }
    }
}
