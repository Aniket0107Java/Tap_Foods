package com.tap.model;

import javax.persistence.Id;
import javax.persistence.*;
import javax.persistence.OneToMany;

@Entity
@Table(name = "cart_item")
public class CartItem {

    @Id
    private int itemId; // Primary key
    
    private int menuId;
    private String name;
    private int price;
    private int quantity;

//    @ManyToOne
    @Transient
    private Cart cart; // Cart reference for relationships

    public CartItem() {}

    public CartItem(int menuId, String name, int price, int quantity) {
        this.menuId = menuId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }

    public int getItemTotalPrice() {
    	return this.quantity*this.price;
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "itemId=" + itemId +
                ", menuId=" + menuId +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                '}';
    }
}
