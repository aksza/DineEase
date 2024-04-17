using DineEaseApp.Data;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;

namespace DineEaseApp.Repository
{
    public class OwnerRepository : IOwnerRepository
    {
        private readonly DataContext _context;

        public OwnerRepository(DataContext context)
        {
            _context = context;
        }

        public Owner GetOwner(int id)
        {
            return _context.Owners.Where(o => o.Id == id).FirstOrDefault();
        }

        public ICollection<Owner> GetOwners()
        {
            return _context.Owners.OrderBy(x => x.Id).ToList();
        }

        public bool OwnerExists(int id)
        {
            return _context.Owners.Any(x => x.Id == id);
        }
    }
}
