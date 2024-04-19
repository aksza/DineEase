namespace DineEaseApp.Models
{
    public class Owner
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string PhoneNum { get; set; }
        public ICollection<Restaurant> Restaurants { get; set;}
    }
}