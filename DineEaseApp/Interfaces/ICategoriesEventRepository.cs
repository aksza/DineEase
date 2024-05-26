using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface ICategoriesEventRepository : IRepository<CategoriesEvent>
    {
        Task<ICollection<CategoriesEvent>?> GetCategoriesEventsByEventId(int eventId);
    }
}
