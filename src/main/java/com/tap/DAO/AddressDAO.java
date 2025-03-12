package com.tap.DAO;

import com.tap.model.Address;

public interface AddressDAO {

	public boolean addNewAddress(Address address);
	public boolean deleteAddress(int addressId);
	
}
