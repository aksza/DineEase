using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IReservationRepository
    {
        Task<ICollection<Reservation>> GetReservationsByUserId(int userId);
    }
}
