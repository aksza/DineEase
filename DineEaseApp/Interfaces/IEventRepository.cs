using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IEventRepository
    {
        Task<ICollection<Event>> GetEventsAsync();
        Task<ICollection<Event>> GetEventsByUserFavorits();
        Task<Event?> GetEventById(int id);
        Task<List<Event>?> SearchEvents(string someText);
    }
}
