using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class OrderDto
    {
        public int Id { get; set; }
        //[ForeignKey("Menu")]
        public int MenuId { get; set; }
        //public MenuDto Menu { get; set; }
        public string MenuName { get; set; }
        public string? Comment { get; set; }
        //[ForeignKey("Reservation")]
        public int ReservationId { get; set; }
        //public ReservationDto Reservation { get; set; }
    }
}
