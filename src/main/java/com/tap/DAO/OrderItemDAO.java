package com.tap.DAO;

import java.util.List;

import com.tap.model.OrderItem;

public interface OrderItemDAO {

	public void saveOrderItem(OrderItem orderItem);
	public OrderItem getOrderItem(int orderItemId);
	public List<OrderItem>getAllOrderItem();
	public boolean deleteOrderItem(int orderItemId);
	public boolean upadateOrderItem(OrderItem orderItem);
	
}
