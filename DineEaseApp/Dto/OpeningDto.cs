using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class OpeningDto
    {
        public int Id { get; set; }
        //[ForeignKey("Restaurant")]
        public int? RestaurantId { get; set; }
        //public RestaurantDto Restaurant { get; set; }
        public string OpeningHour { get; set; }
        public string ClosingHour { get; set; }
        public DayOfWeek day { get; set; }
    }
}
