using DineEaseApp.Models;
using Microsoft.EntityFrameworkCore;

namespace DineEaseApp.Data
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options) 
        { 

        }

        public DbSet<CategoriesEvent> CategoriesEvents { get; set; }
        public DbSet<CategoriesRestaurant> CategoriesRestaurants { get; set; }
        public DbSet<Cuisine> Cuisines { get; set;}
        public DbSet<CuisinesRestaurant> CuisinesRestaurants { get; set; }
        public DbSet<ECategory> ECategories { get; set; }
        public DbSet<Event> Events { get; set; }
        public DbSet<EventType> EventTypes { get; set; }
        public DbSet<Favorit> Favorits { get; set; }
        public DbSet<Meeting> Meetings { get; set; }
        public DbSet<Menu> Menus { get; set; }
        public DbSet<MenuType> MenuTypes { get; set; }
        public DbSet<Opening> Openings { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<Owner> Owners { get; set; }
        public DbSet<PhotosRestaurant> PhotosRestaurants { get; set; }
        public DbSet<Price> Prices { get; set; }
        public DbSet<Rating> Ratings { get; set; }
        public DbSet<RCategory> RCategories { get; set; }
        public DbSet<Reservation> Reservations { get; set; }
        public DbSet<Restaurant> Restaurants { get; set; }
        public DbSet<Review> Reviews { get; set; }
        public DbSet<Seating> Seatings { get; set; }
        public DbSet<SeatingsRestaurant> SeatingsRestaurants { get; set; }
        public DbSet<User> Users { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<CategoriesEvent>()
                .HasKey(ce => new { ce.ECategoryId, ce.EventId});
            modelBuilder.Entity<CategoriesEvent>()
                .HasOne(c => c.ECategory)
                .WithMany(ce => ce.CategoriesEvents)
                .HasForeignKey(c => c.ECategoryId);
            modelBuilder.Entity<CategoriesEvent>()
                .HasOne(e => e.Event)
                .WithMany(ce => ce.CategoriesEvents)
                .HasForeignKey(e => e.EventId);

            modelBuilder.Entity<CategoriesRestaurant>()
                .HasKey(cr => new { cr.RCategoryId, cr.RestaurantId });
            modelBuilder.Entity<CategoriesRestaurant>()
                .HasOne(c => c.RCategory)
                .WithMany(cr => cr.CategoriesRestaurants)
                .HasForeignKey(c => c.RCategoryId);
            modelBuilder.Entity<CategoriesRestaurant>()
                .HasOne(r => r.Restaurant)
                .WithMany(cr => cr.CategoriesRestaurants)
                .HasForeignKey(r => r.RestaurantId);

            modelBuilder.Entity<CuisinesRestaurant>()
                 .HasKey(cr => new { cr.CuisineId, cr.RestaurantId });
            modelBuilder.Entity<CuisinesRestaurant>()
                .HasOne(c => c.Cuisine)
                .WithMany(cr => cr.CuisinesRestaurants)
                .HasForeignKey(c => c.CuisineId);
            modelBuilder.Entity<CuisinesRestaurant>()
                .HasOne(r => r.Restaurant)
                .WithMany(cr => cr.CuisinesRestaurants)
                .HasForeignKey(r => r.RestaurantId);

            modelBuilder.Entity<SeatingsRestaurant>()
                .HasKey(sr => new { sr.SeatingId, sr.RestaurantId });
            modelBuilder.Entity<SeatingsRestaurant>()
                .HasOne(s => s.Seating)
                .WithMany(sr => sr.SeatingsRestaurants)
                .HasForeignKey(s => s.SeatingId);
            modelBuilder.Entity<SeatingsRestaurant>()
                .HasOne(r => r.Restaurant)
                .WithMany(sr => sr.SeatingsRestaurants)
                .HasForeignKey(r => r.RestaurantId);

            modelBuilder.Entity<PhotosRestaurant>()
                .HasKey(pr => new { pr.Id });
            //modelBuilder.Entity<PhotosRestaurant>()
            //    .HasOne(p => p.Photo)
            //    .WithMany(pr => pr.PhotosRestaurants)
            //    .HasForeignKey(p => p.PhotoId);
            modelBuilder.Entity<PhotosRestaurant>()
                .HasOne(r => r.Restaurant)
                .WithMany(pr => pr.PhotosRestaurants)
                .HasForeignKey(r => r.RestaurantId);

        }
    }
}
