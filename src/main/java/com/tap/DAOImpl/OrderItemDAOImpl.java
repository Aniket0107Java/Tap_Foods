package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import com.tap.DAO.OrderItemDAO;
import com.tap.model.OrderItem;
import com.tap.model.Orders;
import com.tap.utility.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

//	private static final String SAVE_ORDERITEM_QUERY = "INSERT INTO `orderItem` (`orderItemId`, `orderId`, `menuId`, `quantity`, `totalPrice`) VALUES (?,?,?,?,?)";
//	private static final String GET_ORDERITEM_QUERY = "SELECT * FROM `orderItem` WHERE `orderItemId` = ?";
//	private static final String DELETE_ORDERITEM_QUERY = "DELETE FROM `orderItem` WHERE `orderItemId` = ?";
//	private static final String GET_ALL_ORDERITEM_QUERY = "SELECT * FROM `orderItem`";
//	private static final String UPDATE_ORDERITEM_QUERY = "UPDATE `orderItem` SET `quantity` = ? `price` = ? WHERE orderId = ?";
//
//	
//	
//	Connection connection = null;
//	PreparedStatement preparedStatement = null;
//	Statement statement = null;
	
	private SessionFactory sessionFactory;

	public OrderItemDAOImpl(SessionFactory sessionFactory) {
		super();
		this.sessionFactory = sessionFactory;
	}

	@Override
	public void saveOrderItem(OrderItem orderItem) {
		Session session = sessionFactory.openSession();
		
		Transaction transaction = null;
		
		try {
			transaction = session.beginTransaction();
			
			session.save(orderItem);
			
			transaction.commit();
			
		}catch(Exception e){
			transaction.rollback();
			e.printStackTrace();
			
		}
	}

	@Override
	public OrderItem getOrderItem(int orderItemId) {
		OrderItem orderItem = null;
		try {
			connection = DBConnection.getConnection();
			preparedStatement = connection.prepareStatement(GET_ORDERITEM_QUERY);
			preparedStatement.setInt(1, orderItemId);
			preparedStatement.execute();
			ResultSet resultSet = preparedStatement.getResultSet();
			
			if (resultSet.next()) {
//				int orderItemId = resultSet.getInt("orderItemId");
				int orderId = resultSet.getInt("orderId");
				int menuId = resultSet.getInt("menuId");
				int quantity = resultSet.getInt("quantity");
				int totalPrice = resultSet.getInt("totalPrice");

				orderItem = new OrderItem(orderItemId, orderId, menuId, quantity, totalPrice);

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return orderItem;
	}

	@Override
	public List<OrderItem> getAllOrderItem() {
		List<OrderItem> allOrderItem = new ArrayList<>();
		try {
			connection = DBConnection.getConnection();
			statement = connection.createStatement();
			statement.executeQuery(GET_ALL_ORDERITEM_QUERY);
			ResultSet resultSet = statement.getResultSet();
			while (resultSet.next()) {

				int orderItemId = resultSet.getInt("orderItemId");
				int orderId = resultSet.getInt("orderId");
				int menuId = resultSet.getInt("menuId");
				int quantity = resultSet.getInt("quantity");
				int totalPrice = resultSet.getInt("totalPrice");

				OrderItem orderItem = new OrderItem(orderItemId, orderId, menuId, quantity, totalPrice);

				allOrderItem.add(orderItem);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return allOrderItem;
	}

	@Override
	public boolean deleteOrderItem(int orderItemId) {
		int res = 0;
		try {
			connection = DBConnection.getConnection();
			preparedStatement = connection.prepareStatement(DELETE_ORDERITEM_QUERY);
			preparedStatement.setInt(1, orderItemId);
			res = preparedStatement.executeUpdate();
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res==1;
	}

	@Override
	public boolean upadateOrderItem(OrderItem orderItem) {
		int res = 0;
		try {
			connection = DBConnection.getConnection();
			preparedStatement = connection.prepareStatement(UPDATE_ORDERITEM_QUERY);
			preparedStatement.setInt(1, orderItem.getQuantity());
			preparedStatement.setInt(2, orderItem.getTotalPrice());
			preparedStatement.setInt(3, orderItem.getOrderId());
			res = preparedStatement.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res==1;
	}

}
