using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class RestaurantDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public string Address { get; set; }
        public string PhoneNum { get; set; }
        public string Email { get; set; }
        public double? Rating { get; set; }
        public int PriceId { get; set; }
        public PriceDto Price { get; set; }
        public bool ForEvent { get; set; }
        public int OwnerId { get; set; }
        public OwnerDto Owner { get; set; }
        public int MaxTableCap { get; set; }
        public int TaxIdNum { get; set; }
        public byte[]? BusinessLicense { get; set; }
    }
}
