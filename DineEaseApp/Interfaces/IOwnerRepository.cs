using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IOwnerRepository
    {
        ICollection<Owner> GetOwners();
        Owner GetOwner(int id);
        bool OwnerExists(int id);
    }
}
