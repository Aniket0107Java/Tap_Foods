package com.tap.DAO;

import java.util.List;

import com.tap.model.Orders;

public interface OrderDAO {

	public void saveOrder(Orders orders);
	public Orders getOrder(int orderId);
	public List<Orders>getAllOrders();
	public List<Orders>getAllOrdersByAdminId(int adminId);
	public boolean deleteOrder(int orderId);
	public void upadateOrder(Orders order);
	
}