namespace DineEaseApp.Models
{
    public class ECategory
    {
        public int Id { get; set; }
        public string ECategoryName { get; set; }
        public ICollection<CategoriesEvent> CategoriesEvents { get; set; }
    }
}