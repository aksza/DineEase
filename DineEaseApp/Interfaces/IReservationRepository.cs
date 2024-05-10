using DineEaseApp.Dto;
using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IReservationRepository
    {
        Task<ICollection<Reservation>> GetReservationsByUserId(int userId);
        Task<bool> PostReservation(Reservation reservation);
    }
}
