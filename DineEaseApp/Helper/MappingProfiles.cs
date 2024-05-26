using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Models;

namespace DineEaseApp.Helper
{
    public class MappingProfiles : Profile
    {
        public MappingProfiles() 
        {
            CreateMap<Restaurant, RestaurantDto>();
            CreateMap<RestaurantDto,Restaurant>();
            CreateMap<Owner,OwnerDto>();
            CreateMap<OwnerDto,Owner>();
            CreateMap<Price,PriceDto>();
            CreateMap<PriceDto,Price>();
            CreateMap<Cuisine,CuisineDto>();
            CreateMap<CuisineDto,Cuisine>();
            CreateMap<CuisineRestaurantDto, CuisinesRestaurant>();
            CreateMap<CuisinesRestaurant, CuisineRestaurantDto>();
            CreateMap<CategoriesEventDto,CategoriesEvent>();
            CreateMap<CategoriesEvent,CategoriesEventDto>();
            CreateMap<ECategory,ECategoryDto>();
            CreateMap<ECategoryDto,ECategory>();
            CreateMap<CategoryEDto, ECategory>();
            CreateMap<ECategory,CategoryEDto>();
            CreateMap<CategoryRDto,RCategory>();
            CreateMap<RCategory,CategoryRDto>();
            CreateMap<CategoriesRestaurantDto, CategoriesRestaurant>();
            CreateMap<CategoriesRestaurant, CategoriesRestaurantDto>();
            CreateMap<Event,EventDto>();
            CreateMap<EventDto,Event>();
            CreateMap<EventType,EventTypeDto>();
            CreateMap<EventTypeDto,EventType>();
            CreateMap<Favorit, FavoritDto>();
            CreateMap<FavoritDto, Favorit>();
            CreateMap<Meeting,MeetingDto>();
            CreateMap<MeetingDto,Meeting>();
            CreateMap<MeetingCreateDto,Meeting>();
            CreateMap<Meeting,MeetingCreateDto>();
            CreateMap<Menu,MenuDto>();
            CreateMap<MenuDto,Menu>();
            CreateMap<MenuCreateDto,Menu>();
            CreateMap<Menu,MenuCreateDto>();
            CreateMap<Opening,OpeningDto>();
            CreateMap<OpeningDto,Opening>();
            CreateMap<MenuType,MenuTypeDto>();
            CreateMap<MenuTypeDto,MenuType>();
            CreateMap<Order,OrderDto>();
            CreateMap<OrderDto,Order>();
            CreateMap<OrderCreateDto, Order>();
            CreateMap<Order, OrderCreateDto>();
            CreateMap<Owner,OwnerDto>();
            CreateMap<OwnerDto,Owner>();
            CreateMap<PhotosRestaurantDto,PhotosRestaurant>();
            CreateMap<PhotosRestaurantUpdateDto,PhotosRestaurant>();
            //CreateMap<Photo,PhotoDto>();
            //CreateMap<PhotoDto,Photo>();
            CreateMap<Rating,RatingDto>();
            CreateMap<RatingDto,Rating>();
            CreateMap<RatingCreateDto,Rating>();
            CreateMap<RatingDto,RatingCreateDto>();
            CreateMap<RCategory,RCategoryDto>();
            CreateMap<RCategoryDto,RCategory>();
            CreateMap<Reservation,ReservationDto>();
            CreateMap<ReservationDto,Reservation>();
            CreateMap<Reservation,ReservationCreateDto>();
            CreateMap<ReservationCreateDto,Reservation>();
            CreateMap<Review,ReviewDto>();
            CreateMap<ReviewDto,Review>();
            CreateMap<ReviewCreateDto,Review>();
            CreateMap<Review,ReviewCreateDto>();
            CreateMap<Seating,SeatingDto>();
            CreateMap<SeatingDto,Seating>();
            CreateMap<User,UserDto>();
            CreateMap<UserDto,User>();
            CreateMap<UserCreateDto, User>();
            CreateMap<UserUpdateDto,User>();
            CreateMap<User,UserUpdateDto>();
            CreateMap<RestaurantCreateDto, Restaurant>();
            CreateMap<RestaurantLoginDto, Restaurant>();
            CreateMap<SeatingsRestaurantDto,SeatingsRestaurant>();
            CreateMap<SeatingsRestaurant,SeatingsRestaurantDto>();
        }
    }
}
