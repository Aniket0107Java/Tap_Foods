package com.tap.DAOImpl;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import com.tap.DAO.AddressDAO;
import com.tap.model.Address;

public class AddressDAOImpl implements AddressDAO {
	private SessionFactory sessionFactory;
	
	
	public AddressDAOImpl(SessionFactory sessionFactory) {
		super();
		this.sessionFactory = sessionFactory;
	}

	@Override
	public boolean addNewAddress(Address address) {
		Session session = null;
		Transaction transaction = null;
		
		try {
			session = sessionFactory.openSession();
			transaction = session.beginTransaction();
			
			session.save(address);
			transaction.commit();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			transaction.rollback();
			return false;
		}finally {
			session.close();
		}
				
	}
	
	@Override
	public boolean deleteAddress(int addressId) {
		Session session = null;
		Transaction transaction = null;
		try {
			session = sessionFactory.openSession();
			transaction = session.beginTransaction();
			
			Address a = session.get(Address.class, addressId);
			
			if(a != null) {
				session.delete(a);
				transaction.commit();
				return true;
			}
			else {
				return false;
			}
		} catch (Exception e) {
			// TODO: handle exception
			transaction.rollback();
			session.close();
			return false;
		}
	}
	
}
