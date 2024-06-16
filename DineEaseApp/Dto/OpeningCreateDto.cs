using DineEaseApp.Models;

namespace DineEaseApp.Dto
{
    public class OpeningCreateDto
    {
        public int RestaurantId { get; set; }
        public string OpeningHour { get; set; }
        public string ClosingHour { get; set; }
        public DayOfWeek day { get; set; }
    }
}
