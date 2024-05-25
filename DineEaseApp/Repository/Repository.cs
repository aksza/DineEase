using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Repository
{
    public class Repository<T> : IRepository<T> where T : class
    {
        private DataContext _context;
        protected readonly DbSet<T> _dbSet;

        public Repository(DataContext context)
        {
            _dbSet = context.Set<T>();
            _context = context;
        }

        public async Task<bool> AddAsync(T entity)
        {
            _context.Add(entity);
            return await Save();
        }

        public async Task<bool> DeleteAsync(T entity)
        {
            _context.Remove(entity);
            return await Save();
        }

        public async Task<ICollection<T>> GetAllAsync()
        {
            return await _dbSet.ToListAsync();
        }

        public async Task<T?> GetByIdAsync(int id)
        {
            return await _dbSet.FindAsync(id);
        }

        public async Task<bool> Save()
        {
            var saved = await _context.SaveChangesAsync();
            return saved > 0;
        }

        public async Task<bool> UpdateAsync(T entity)
        {
            _context.Update(entity);
            return await Save();
        }
    }
}
