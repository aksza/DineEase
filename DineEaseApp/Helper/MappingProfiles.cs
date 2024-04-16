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
        }
    }
}
