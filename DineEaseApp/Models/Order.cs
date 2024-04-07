﻿namespace DineEaseApp.Models
{
    public class Order
    {
        public int Id { get; set; }
        public int MenuId { get; set; }
        public Menu Menu { get; set; }
        public string Comment { get; set; }
        public ICollection<Reservation> Reservations { get; set; }
        
    }
}