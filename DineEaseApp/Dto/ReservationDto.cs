﻿using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class ReservationDto
    {
        public int Id { get; set; }
        public int RestaurantId { get; set; }
        public string? RestaurantName { get; set; }
        public int UserId { get; set; }
        public string Name { get; set; }
        public int PartySize { get; set; }
        public DateTime Date { get; set; }
        public string PhoneNum { get; set; }
        public bool Ordered { get; set; }
        public int TableNumber { get; set; }
        public string? Comment { get; set; }
        public bool? Accepted { get; set; }
        public string? RestaurantResponse { get; set; }
    }
}
