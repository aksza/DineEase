using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IEventRepository : IRepository<Event>
    {
        Task<ICollection<Event>> GetEventsAsync();
        Task<ICollection<Event>?> GetFutureEventsByRestaurantId(int restaurantId);
        Task<ICollection<Event>?> GetOldEventsByRestaurantId(int restaurantId);
        Task<ICollection<Event>> GetEventsByUserFavorits();
        Task<Event?> GetEventById(int id);
        Task<List<Event>?> SearchEvents(string someText);
    }
}
