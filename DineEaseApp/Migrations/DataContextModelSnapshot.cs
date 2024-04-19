﻿// <auto-generated />
using System;
using DineEaseApp.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace DineEaseApp.Migrations
{
    [DbContext(typeof(DataContext))]
    partial class DataContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "6.0.11")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder, 1L, 1);

            modelBuilder.Entity("DineEaseApp.Models.CategoriesEvent", b =>
                {
                    b.Property<int>("ECategoryId")
                        .HasColumnType("int");

                    b.Property<int>("EventId")
                        .HasColumnType("int");

                    b.HasKey("ECategoryId", "EventId");

                    b.HasIndex("EventId");

                    b.ToTable("CategoriesEvents");
                });

            modelBuilder.Entity("DineEaseApp.Models.CategoriesRestaurant", b =>
                {
                    b.Property<int>("RCategoryId")
                        .HasColumnType("int");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.HasKey("RCategoryId", "RestaurantId");

                    b.HasIndex("RestaurantId");

                    b.ToTable("CategoriesRestaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.Cuisine", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("CuisineName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("Cuisines");
                });

            modelBuilder.Entity("DineEaseApp.Models.CuisinesRestaurant", b =>
                {
                    b.Property<int>("CuisineId")
                        .HasColumnType("int");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.HasKey("CuisineId", "RestaurantId");

                    b.HasIndex("RestaurantId");

                    b.ToTable("CuisinesRestaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.ECategory", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("ECategoryName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("ECategories");
                });

            modelBuilder.Entity("DineEaseApp.Models.Event", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Description")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("EndingDate")
                        .HasColumnType("datetime2");

                    b.Property<string>("EventName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.Property<DateTime>("StartingDate")
                        .HasColumnType("datetime2");

                    b.HasKey("Id");

                    b.HasIndex("RestaurantId");

                    b.ToTable("Events");
                });

            modelBuilder.Entity("DineEaseApp.Models.EventType", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("EventName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("EventTypes");
                });

            modelBuilder.Entity("DineEaseApp.Models.Favorit", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("RestaurantId");

                    b.HasIndex("UserId");

                    b.ToTable("Favorits");
                });

            modelBuilder.Entity("DineEaseApp.Models.Meeting", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Comment")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("EventDate")
                        .HasColumnType("datetime2");

                    b.Property<int>("EventId")
                        .HasColumnType("int");

                    b.Property<int>("GuestSize")
                        .HasColumnType("int");

                    b.Property<DateTime>("MeetingDate")
                        .HasColumnType("datetime2");

                    b.Property<string>("PhoneNum")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("EventId");

                    b.HasIndex("RestaurantId");

                    b.HasIndex("UserId");

                    b.ToTable("Meetings");
                });

            modelBuilder.Entity("DineEaseApp.Models.Menu", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Ingredients")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("MenuTypeId")
                        .HasColumnType("int");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<double>("Price")
                        .HasColumnType("float");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("MenuTypeId");

                    b.HasIndex("RestaurantId");

                    b.ToTable("Menus");
                });

            modelBuilder.Entity("DineEaseApp.Models.MenuType", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("MenuTypes");
                });

            modelBuilder.Entity("DineEaseApp.Models.Opening", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("ClosingHour")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("OpeningHour")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.Property<int>("day")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("RestaurantId");

                    b.ToTable("Openings");
                });

            modelBuilder.Entity("DineEaseApp.Models.Order", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Comment")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("MenuId")
                        .HasColumnType("int");

                    b.Property<int>("ReservationId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("MenuId");

                    b.HasIndex("ReservationId");

                    b.ToTable("Orders");
                });

            modelBuilder.Entity("DineEaseApp.Models.Owner", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PhoneNum")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("Owners");
                });

            modelBuilder.Entity("DineEaseApp.Models.Photo", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<byte[]>("Photograph")
                        .IsRequired()
                        .HasColumnType("varbinary(max)");

                    b.HasKey("Id");

                    b.ToTable("Photos");
                });

            modelBuilder.Entity("DineEaseApp.Models.PhotosRestaurant", b =>
                {
                    b.Property<int>("PhotoId")
                        .HasColumnType("int");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.HasKey("PhotoId", "RestaurantId");

                    b.HasIndex("RestaurantId");

                    b.ToTable("PhotosRestaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.Price", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("PriceName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("Prices");
                });

            modelBuilder.Entity("DineEaseApp.Models.Rating", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<int>("RatingNumber")
                        .HasColumnType("int");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("RestaurantId");

                    b.HasIndex("UserId");

                    b.ToTable("Ratings");
                });

            modelBuilder.Entity("DineEaseApp.Models.RCategory", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("RCategoryName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("RCategories");
                });

            modelBuilder.Entity("DineEaseApp.Models.Reservation", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<bool?>("Accepted")
                        .HasColumnType("bit");

                    b.Property<string>("Comment")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("Date")
                        .HasColumnType("datetime2");

                    b.Property<bool>("Ordered")
                        .HasColumnType("bit");

                    b.Property<int>("PartySize")
                        .HasColumnType("int");

                    b.Property<string>("PhoneNum")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.Property<string>("RestaurantResponse")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("RestaurantId");

                    b.HasIndex("UserId");

                    b.ToTable("Reservations");
                });

            modelBuilder.Entity("DineEaseApp.Models.Restaurant", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Address")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("BusinessLicense")
                        .HasColumnType("varbinary(max)");

                    b.Property<string>("Description")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("ForEvent")
                        .HasColumnType("bit");

                    b.Property<int>("MaxTableCap")
                        .HasColumnType("int");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("OwnerId")
                        .HasColumnType("int");

                    b.Property<byte[]>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("varbinary(max)");

                    b.Property<byte[]>("PasswordSalt")
                        .IsRequired()
                        .HasColumnType("varbinary(max)");

                    b.Property<string>("PhoneNum")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("PriceId")
                        .HasColumnType("int");

                    b.Property<double>("Rating")
                        .HasColumnType("float");

                    b.Property<int>("TaxIdNum")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("OwnerId");

                    b.HasIndex("PriceId");

                    b.ToTable("Restaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.Review", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Content")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("RestaurantId");

                    b.HasIndex("UserId");

                    b.ToTable("Reviews");
                });

            modelBuilder.Entity("DineEaseApp.Models.Seating", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("SeatingName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("Seatings");
                });

            modelBuilder.Entity("DineEaseApp.Models.SeatingsRestaurant", b =>
                {
                    b.Property<int>("SeatingId")
                        .HasColumnType("int");

                    b.Property<int>("RestaurantId")
                        .HasColumnType("int");

                    b.HasKey("SeatingId", "RestaurantId");

                    b.HasIndex("RestaurantId");

                    b.ToTable("SeatingsRestaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.User", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<bool>("Admin")
                        .HasColumnType("bit");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("varbinary(max)");

                    b.Property<byte[]>("PasswordSalt")
                        .IsRequired()
                        .HasColumnType("varbinary(max)");

                    b.Property<string>("PhoneNum")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("DineEaseApp.Models.CategoriesEvent", b =>
                {
                    b.HasOne("DineEaseApp.Models.ECategory", "ECategory")
                        .WithMany("CategoriesEvents")
                        .HasForeignKey("ECategoryId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.Event", "Event")
                        .WithMany("CategoriesEvents")
                        .HasForeignKey("EventId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("ECategory");

                    b.Navigation("Event");
                });

            modelBuilder.Entity("DineEaseApp.Models.CategoriesRestaurant", b =>
                {
                    b.HasOne("DineEaseApp.Models.RCategory", "RCategory")
                        .WithMany("CategoriesRestaurants")
                        .HasForeignKey("RCategoryId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("CategoriesRestaurants")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("RCategory");

                    b.Navigation("Restaurant");
                });

            modelBuilder.Entity("DineEaseApp.Models.CuisinesRestaurant", b =>
                {
                    b.HasOne("DineEaseApp.Models.Cuisine", "Cuisine")
                        .WithMany("CuisinesRestaurants")
                        .HasForeignKey("CuisineId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("CuisinesRestaurants")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Cuisine");

                    b.Navigation("Restaurant");
                });

            modelBuilder.Entity("DineEaseApp.Models.Event", b =>
                {
                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("Events")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Restaurant");
                });

            modelBuilder.Entity("DineEaseApp.Models.Favorit", b =>
                {
                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("Favorits")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.User", "User")
                        .WithMany("Favorits")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Restaurant");

                    b.Navigation("User");
                });

            modelBuilder.Entity("DineEaseApp.Models.Meeting", b =>
                {
                    b.HasOne("DineEaseApp.Models.EventType", "Event")
                        .WithMany("Meetings")
                        .HasForeignKey("EventId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("Meetings")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.User", "User")
                        .WithMany("Meetings")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Event");

                    b.Navigation("Restaurant");

                    b.Navigation("User");
                });

            modelBuilder.Entity("DineEaseApp.Models.Menu", b =>
                {
                    b.HasOne("DineEaseApp.Models.MenuType", "MenuType")
                        .WithMany("Menus")
                        .HasForeignKey("MenuTypeId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("Menus")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("MenuType");

                    b.Navigation("Restaurant");
                });

            modelBuilder.Entity("DineEaseApp.Models.Opening", b =>
                {
                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("Openings")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Restaurant");
                });

            modelBuilder.Entity("DineEaseApp.Models.Order", b =>
                {
                    b.HasOne("DineEaseApp.Models.Menu", "Menu")
                        .WithMany("Orders")
                        .HasForeignKey("MenuId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.Reservation", "Reservation")
                        .WithMany("Orders")
                        .HasForeignKey("ReservationId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Menu");

                    b.Navigation("Reservation");
                });

            modelBuilder.Entity("DineEaseApp.Models.PhotosRestaurant", b =>
                {
                    b.HasOne("DineEaseApp.Models.Photo", "Photo")
                        .WithMany("PhotosRestaurants")
                        .HasForeignKey("PhotoId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("PhotosRestaurants")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Photo");

                    b.Navigation("Restaurant");
                });

            modelBuilder.Entity("DineEaseApp.Models.Rating", b =>
                {
                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("Ratings")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.User", "User")
                        .WithMany("Ratings")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Restaurant");

                    b.Navigation("User");
                });

            modelBuilder.Entity("DineEaseApp.Models.Reservation", b =>
                {
                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("Reservations")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.User", "User")
                        .WithMany("Reservations")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Restaurant");

                    b.Navigation("User");
                });

            modelBuilder.Entity("DineEaseApp.Models.Restaurant", b =>
                {
                    b.HasOne("DineEaseApp.Models.Owner", "Owner")
                        .WithMany("Restaurants")
                        .HasForeignKey("OwnerId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.Price", "Price")
                        .WithMany("Restaurants")
                        .HasForeignKey("PriceId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Owner");

                    b.Navigation("Price");
                });

            modelBuilder.Entity("DineEaseApp.Models.Review", b =>
                {
                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("Reviews")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.User", "User")
                        .WithMany("Reviews")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Restaurant");

                    b.Navigation("User");
                });

            modelBuilder.Entity("DineEaseApp.Models.SeatingsRestaurant", b =>
                {
                    b.HasOne("DineEaseApp.Models.Restaurant", "Restaurant")
                        .WithMany("SeatingsRestaurants")
                        .HasForeignKey("RestaurantId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DineEaseApp.Models.Seating", "Seating")
                        .WithMany("SeatingsRestaurants")
                        .HasForeignKey("SeatingId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Restaurant");

                    b.Navigation("Seating");
                });

            modelBuilder.Entity("DineEaseApp.Models.Cuisine", b =>
                {
                    b.Navigation("CuisinesRestaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.ECategory", b =>
                {
                    b.Navigation("CategoriesEvents");
                });

            modelBuilder.Entity("DineEaseApp.Models.Event", b =>
                {
                    b.Navigation("CategoriesEvents");
                });

            modelBuilder.Entity("DineEaseApp.Models.EventType", b =>
                {
                    b.Navigation("Meetings");
                });

            modelBuilder.Entity("DineEaseApp.Models.Menu", b =>
                {
                    b.Navigation("Orders");
                });

            modelBuilder.Entity("DineEaseApp.Models.MenuType", b =>
                {
                    b.Navigation("Menus");
                });

            modelBuilder.Entity("DineEaseApp.Models.Owner", b =>
                {
                    b.Navigation("Restaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.Photo", b =>
                {
                    b.Navigation("PhotosRestaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.Price", b =>
                {
                    b.Navigation("Restaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.RCategory", b =>
                {
                    b.Navigation("CategoriesRestaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.Reservation", b =>
                {
                    b.Navigation("Orders");
                });

            modelBuilder.Entity("DineEaseApp.Models.Restaurant", b =>
                {
                    b.Navigation("CategoriesRestaurants");

                    b.Navigation("CuisinesRestaurants");

                    b.Navigation("Events");

                    b.Navigation("Favorits");

                    b.Navigation("Meetings");

                    b.Navigation("Menus");

                    b.Navigation("Openings");

                    b.Navigation("PhotosRestaurants");

                    b.Navigation("Ratings");

                    b.Navigation("Reservations");

                    b.Navigation("Reviews");

                    b.Navigation("SeatingsRestaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.Seating", b =>
                {
                    b.Navigation("SeatingsRestaurants");
                });

            modelBuilder.Entity("DineEaseApp.Models.User", b =>
                {
                    b.Navigation("Favorits");

                    b.Navigation("Meetings");

                    b.Navigation("Ratings");

                    b.Navigation("Reservations");

                    b.Navigation("Reviews");
                });
#pragma warning restore 612, 618
        }
    }
}
