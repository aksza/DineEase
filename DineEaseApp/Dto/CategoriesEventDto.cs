using DineEaseApp.Models;
using System.ComponentModel.DataAnnotations.Schema;

namespace DineEaseApp.Dto
{
    public class CategoriesEventDto
    {
        public int ECategoryId { get; set; }
        public string ECategoryName { get; set; }
    }
}
