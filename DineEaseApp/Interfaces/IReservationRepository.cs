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
        Task<ICollection<int>> AverageDailyReservationsByRestaurantId(int restaurantId);
        Task<ICollection<int>> AverageReservationsPerHoursByRestaurantId(int restaurantId);
        Task<ICollection<int>> AverageReservationsLastMonthByRestaurantId(int restaurantId);
        Task<ICollection<int>> OrdersPerReservationsByRestaurantId(int restaurantId); //visszaadja az ossz reservationt es hogy hanyan rendeltek kajat
        Task<bool> Save();
    }
}
