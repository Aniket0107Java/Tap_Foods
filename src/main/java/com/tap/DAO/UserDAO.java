package com.tap.DAO;

import java.util.List;

import com.tap.model.User;

public interface UserDAO {
	public boolean saveUser(User user);
	public User getUser(String email, String password);
	public List<User>getAllUser();
	public boolean deleteUser(int userId);
	public boolean upadateUser(User user);
}
