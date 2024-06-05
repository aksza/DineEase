using DineEaseApp.Dto;
using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IReservationRepository
    {
        Task<ICollection<Reservation>> GetReservationsByUserId(int userId);
        Task<Reservation?> GetReservationById(int id);
        Task<ICollection<Reservation>?> GetReservationsByRestaurantId(int id);
        Task<bool> UpdateReservation(Reservation reservation);
        Task<bool> PostReservation(Reservation reservation);
        Task<bool> Save();
    }
}
