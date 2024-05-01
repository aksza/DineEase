﻿using AutoMapper;
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
            CreateMap<ECategory,ECategoryDto>();
            CreateMap<ECategoryDto,ECategory>();
            CreateMap<Event,EventDto>();
            CreateMap<EventDto,Event>();
            CreateMap<EventType,EventTypeDto>();
            CreateMap<EventTypeDto,EventType>();
            CreateMap<Favorit, FavoritDto>();
            CreateMap<FavoritDto, Favorit>();
            CreateMap<Meeting,MeetingDto>();
            CreateMap<MeetingDto,Meeting>();
            CreateMap<Menu,MenuDto>();
            CreateMap<MenuDto,Menu>();
            CreateMap<Opening,OpeningDto>();
            CreateMap<OpeningDto,Opening>();
            CreateMap<MenuType,MenuTypeDto>();
            CreateMap<MenuTypeDto,MenuType>();
            CreateMap<Order,OrderDto>();
            CreateMap<OrderDto,Order>();
            CreateMap<Owner,OwnerDto>();
            CreateMap<OwnerDto,Owner>();
            CreateMap<PhotosRestaurantDto,PhotosRestaurant>();
            CreateMap<PhotosRestaurantUpdateDto,PhotosRestaurant>();
            //CreateMap<Photo,PhotoDto>();
            //CreateMap<PhotoDto,Photo>();
            CreateMap<Rating,RatingDto>();
            CreateMap<RatingDto,Rating>();
            CreateMap<RCategory,RCategoryDto>();
            CreateMap<RCategoryDto,RCategory>();
            CreateMap<Reservation,ReservationDto>();
            CreateMap<ReservationDto,Reservation>();
            CreateMap<Review,ReviewDto>();
            CreateMap<ReviewDto,Review>();
            CreateMap<Seating,SeatingDto>();
            CreateMap<SeatingDto,Seating>();
            CreateMap<User,UserDto>();
            CreateMap<UserDto,User>();
            CreateMap<UserCreateDto, User>();
            CreateMap<RestaurantCreateDto, Restaurant>();
            CreateMap<RestaurantLoginDto, Restaurant>();
        }
    }
}
