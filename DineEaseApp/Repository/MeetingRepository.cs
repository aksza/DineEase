using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class MeetingRepository : IMeetingRepository
    {
        private readonly DataContext _context;

        public MeetingRepository(DataContext context)
        {
            _context = context;
        }

        public async Task<ICollection<int>> AverageDailyMeetingsByRestaurantId(int restaurantId)
        {
            var meetings = await _context.Meetings
                .Where(m => m.RestaurantId == restaurantId)
                .ToListAsync();

            var meetingsByDaysOfWeek = meetings.GroupBy(m => m.MeetingDate.DayOfWeek)
                .Select(g => new { DayOfWeek = (int)g.Key, Count = g.Count() })
                .OrderBy(g => g.DayOfWeek)
                .ToList();

            var avgDailyMeetings = new List<int>(new int[7]);

            foreach (var meeting in meetingsByDaysOfWeek)
            {
                avgDailyMeetings[meeting.DayOfWeek] = meeting.Count;
            }

            return avgDailyMeetings;
        }

        public async Task<ICollection<int>> AverageMeetingsLastMonthByRestaurantId(int restaurantId)
        {
            var lastMonth = DateTime.Today.AddMonths(-1); 

            var meetings = await _context.Meetings
                .Where(m => m.RestaurantId == restaurantId && m.MeetingDate >= lastMonth)
                .ToListAsync();

            var meetingsCount = new List<int>(new int[30]); 

            foreach (var meeting in meetings)
            {
                int daysAgo = (meeting.MeetingDate.Date - lastMonth).Days;
                if (daysAgo >= 0 && daysAgo < 30)
                {
                    meetingsCount[daysAgo]++;
                }
            }

            return meetingsCount;
        }

        public async Task<ICollection<int>> AverageMeetingsPerHoursByRestaurantId(int restaurantId)
        {
            var meetings = await _context.Meetings
                .Where(m => m.RestaurantId == restaurantId)
                .ToListAsync();

            var meetingsCount = new List<int>(new int[24]);

            foreach (var meeting in meetings)
            {
                int hour = meeting.MeetingDate.Hour;
                meetingsCount[hour]++;
            }

            return meetingsCount;
        }

        public async Task<ICollection<Meeting>?> GetMeetingByRestaurantId(int id)
        {
            return await _context.Meetings
                .Where(m => m.RestaurantId == id)
                .ToListAsync();
        }

        public async Task<ICollection<Meeting>> GetMeetingsByUserId(int id)
        {
            return await _context.Meetings.Where(m => m.UserId == id).ToListAsync();
        }

        public async Task<bool> PostMeeting(Meeting meeting)
        {
            _context.Add(meeting);
            return await Save();
        }

        public async Task<bool> Save()
        {
            var saved = await _context.SaveChangesAsync();
            return saved > 0;
        }

        public async Task<bool> UpdateMeeting(Meeting meeting)
        {
            _context.Update(meeting);

            return await Save();
        }
    }
}
