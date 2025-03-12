package com.tap.DAOImpl;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import com.tap.DAO.CartDAO;
import com.tap.model.CartItem;

public class CartDAOImpl implements CartDAO {

	private SessionFactory sessionFactory;

	public CartDAOImpl(SessionFactory sessionFactory) {
        super();
        this.sessionFactory = sessionFactory;
    }

	@Override
	public void saveCart(CartItem cartItem) {
		Session session = null;
		Transaction transaction = null;
		try {
			session = sessionFactory.openSession();
			transaction = session.beginTransaction();
			
			session.saveOrUpdate(cartItem);
			transaction.commit();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
	}

	@Override
	public void deleteCart(int itemId) {
		// TODO Auto-generated method stub

	}
}
