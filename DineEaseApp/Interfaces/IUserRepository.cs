using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IUserRepository
    {
        Task<ICollection<User>> GetUsers();
        Task<User?> GetUserById(int id);
        Task<User> GetUserByEmail(string email);
        Task<bool> CreateUser(User user);
        Task<bool> UpdateUser(User user);
        Task<bool> DeleteUser(User user);
        Task<bool> Save();
    }
}
