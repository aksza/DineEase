using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class Order
    {
        public int Id { get; set; }
        [ForeignKey("Menu")]
        public int MenuId { get; set; }
        public Menu Menu { get; set; }
        public string? Comment { get; set; }
        [ForeignKey("Reservation")]
        public int ReservationId { get; set; }
        public Reservation Reservation { get; set; }
        
    }
}