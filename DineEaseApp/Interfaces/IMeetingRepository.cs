using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IMeetingRepository
    {
        Task<ICollection<Meeting>> GetMeetingsByUserId(int id);
        Task<ICollection<Meeting>?> GetMeetingByRestaurantId(int id);
        Task<ICollection<int>> AverageDailyMeetingsByRestaurantId(int restaurantId);
        Task<ICollection<int>> AverageMeetingsPerHoursByRestaurantId(int restaurantId);
        Task<ICollection<int>> AverageMeetingsLastMonthByRestaurantId(int restaurantId);
        Task<bool> PostMeeting(Meeting meeting);
        Task<bool> UpdateMeeting(Meeting meeting);
    }
}
