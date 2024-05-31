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
    }
}
