using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class UserRepository : IUserRepository
    {
        private DataContext _context;

        public UserRepository(DataContext context)
        {
            _context = context;
        }

        public async Task<bool> CreateUser(User user)
        {
            _context.Add(user);
            return await Save();
        }

        public async Task<bool> DeleteUser(User user)
        {
            _context.Remove(user);
            return await Save();
        }

        public async Task<User> GetUserByEmail(string email)
        {
            return await _context.Users.Where(u => u.Email == email).FirstOrDefaultAsync();
        }

        public async Task<User?> GetUserById(int id)
        {
            var user = await _context.Users
                .Where(u => u.Id == id)
                .FirstOrDefaultAsync();

            await Save();
            if(user != null)
            {
                return user;
            }

            return null;
        }

        public async Task<ICollection<User>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }

        public async Task<bool> Save()
        {
            var saved = await _context.SaveChangesAsync();
            return saved > 0;
        }

        public async Task<bool> UpdateUser(User user)
        {
            _context.Update(user);
            return await Save();
        }
    }
}
