using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class CuisineRestaurantDto
    {
        public int CuisineId { get; set; }
        public string CuisineName { get; set; }
        //public int RestaurantId { get; set; }
    }
}
