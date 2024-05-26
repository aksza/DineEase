using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class SeatingsRestaurantDto
    {
        public int SeatingId { get; set; }
        public string SeatingName { get; set; }
        //public int RestaurantId { get; set; }
    }
}
