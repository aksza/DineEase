﻿using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Models
{
    public class Opening
    {
        public int Id { get; set; }
        [ForeignKey("Restaurant")]
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
        public string OpeningHour { get; set; }
        public string ClosingHour { get; set; }
        public DayOfWeek day { get; set; }
    }
}