using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IMeetingRepository
    {
        Task<ICollection<Meeting>> GetMeetingsByUserId(int id);
        Task<ICollection<Meeting>?> GetMeetingByRestaurantId(int id);
        Task<bool> PostMeeting(Meeting meeting);
    }
}
