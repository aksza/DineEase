﻿using DineEaseApp.Models;

namespace DineEaseApp.Interfaces
{
    public interface IRestaurantRepository
    {
        Task<ICollection<Restaurant>> GetRestaurants();
        Task<Restaurant?> GetRestaurantById(int id);
        Task<Restaurant> GetRestaurantByEmail(string email);
        Task<bool> CreateRestaurant(Restaurant restaurant);
        Task<bool> UpdateRestaurant(Restaurant restaurant);
        Task<bool> DeleteRestaurant(Restaurant restaurant);
        Task<bool> Save();
        Task<ICollection<Restaurant>> GetRestaurantForEvent();
        Task<ICollection<Restaurant>> GetRestaurantByName(string name);
        double GetRestaurantRating(int id);
        bool RestaurantExists(int id);
    }
}
