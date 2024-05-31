namespace DineEaseApp.Dto
{
    public class MenuCreateDto
    {
        //public int Id { get; set; }
        public int RestaurantId { get; set; }
        public string Name { get; set; }
        public int MenuTypeId { get; set; }
        public string Ingredients { get; set; }
        public double Price { get; set; }
    }
}
