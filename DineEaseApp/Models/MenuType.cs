namespace DineEaseApp.Models
{
    public class MenuType
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public ICollection<Menu>? Menus { get; set; }
    }
}