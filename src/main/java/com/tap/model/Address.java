package com.tap.model;

import javax.persistence.*;

@Entity
@Table(name = "address")
public class Address {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int addressId;

	private String address;
	private String name;
	private String phone;

	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user; // Each address is linked to one user

	public Address() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Address(String address, User user, String name, String phone) {
		super();
		this.address = address;
		this.user = user;
		this.name = name;
		this.phone = phone;
	}

	public int getAddressId() {
		return addressId;
	}

	public void setAddressId(int addressId) {
		this.addressId = addressId;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	
	

}
