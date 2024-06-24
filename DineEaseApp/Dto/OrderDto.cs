using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class OrderDto
    {
        public int Id { get; set; }
        public int MenuId { get; set; }
        public string MenuName { get; set; }
        public string? Comment { get; set; }
        public int ReservationId { get; set; }
    }
}
