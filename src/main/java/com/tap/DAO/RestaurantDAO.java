package com.tap.DAO;

import java.util.List;

import com.tap.model.Restaurant;

public interface RestaurantDAO {

	public void addRestaurantWithMenu(Restaurant restaurant);
	public Restaurant getRestaurant(int restaurantId);
	public List<Restaurant>getAllRestaurant();
	public boolean deleteRestaurant(int restaurantId);
	public boolean upadateRestaurant(Restaurant restaurant);
	public List<Restaurant>getAllRestaurantByUserId(int adminUserId);
	
}
