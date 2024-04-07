namespace DineEaseApp.Models
{
    public class EventType
    {
        public int Id { get; set; }
        public string EventName { get; set; }
        public ICollection<Meeting> Meetings { get; set; }
    }
}