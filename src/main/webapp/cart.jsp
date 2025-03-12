<%@page import="com.utility.HibernateUtility"%>
<%@page import="com.tap.DAOImpl.MenuDAOImpl"%>
<%@page import="com.tap.DAOImpl.*"%>
<%@page import="com.tap.model.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodExpress - Your Cart</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="styles/cart-style.css">
    <link rel="stylesheet" href="styles/user-dropdown.css">
    <link rel="stylesheet" href="styles/menu.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">
            <h1 class="appname">
                Tap <i class="fa-solid fa-hand-point-up"></i> Foods
            </h1>
        </div>
        <%
        session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        %>

        <div class="nav-right">
            <div class="user-info">
                <i class="fas fa-user"></i> <span><%=user.getUsername()%></span>
                <div class="user-menu">
                    <a href="User/profile.jsp" class="user-menu-item">
                        <i class="fas fa-user-circle"></i> Profile
                    </a>
                    <a href="#" class="user-menu-item"> <i
						class="fas fa-shopping-cart"></i> Cart Items
					</a>
                    <a href="User/orders.jsp" class="user-menu-item">
                        <i class="fas fa-shopping-bag"></i> Orders
                    </a>
                    <a href="LogoutServlet" class="user-menu-item">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <%
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null || cart.getItems().isEmpty()) {
    %>
    <div class="empty-cart-message">
        <i class="fas fa-shopping-cart" id="cart-logo"></i>
        <h2>Your cart is empty</h2>
        <p>Looks like you haven't added any items to your cart yet.</p>
		<button onclick="window.location.href='User/user_homepage.jsp'"
			class="cart-continue-btn">
			<i class="fas fa-utensils"></i> Browse Restaurants
		</button>
	</div>
	<%
	} else {
	%>
    <div class="cart-page-wrapper">
        <div class="cart-main-container">
            <header class="cart-page-header">
                <h1 class="cart-page-title">
                    Shopping Cart <span class="cart-item-count">(<span id="itemCount"><%=cart.getItems().size()%></span> items)</span>
                </h1>
            </header>

            <div class="cart-main-content">
                <div class="cart-items-list">
                    <%
                    for (Map.Entry<Integer, CartItem> en : cart.getItems().entrySet()) {
                        MenuDAOImpl menuDAOImpl = new MenuDAOImpl(HibernateUtility.getSessionFactory());
                        Menu currentMenu = menuDAOImpl.getMenu(en.getKey());
                    %>
                    <div class="cart-list-item" data-menu-id="<%=en.getKey()%>">
                        <div class="cart-item-img-wrapper">
                            <img src="<%=currentMenu.getImagePath()%>" alt="<%=en.getValue().getName()%>" class="cart-item-img">
                            <div class="cart-item-tag "><%=en.getKey()%2==0?"Popular":"BestSeller" %></div>
                        </div>
                        <div class="cart-item-info">
                            <div class="cart-item-header">
                                <h3><%=en.getValue().getName()%></h3>
                                <div class="cart-item-meta">
                                    <span class="cart-item-rating">
                                        <i class="fas fa-star"></i> <%=currentMenu.getRatings()%>
                                    </span>
                                    <span class="cart-item-availability available">
                                        <i class="fas fa-check-circle"></i> Available
                                    </span>
                                </div>
                            </div>
                            <p class="cart-item-desc"><%=currentMenu.getDescription()%></p>
                            <div class="cart-item-actions">
                                <div class="cart-controls" 
                                     data-menu-id="<%=en.getKey()%>" 
                                     data-restaurant-id="<%=cart.getRestaurantId()%>" 
                                     data-price="<%=en.getValue().getPrice()%>">
                                    <div class="quantity-controls">
                                        <button class="quantity-btn minus">-</button>
                                        <span class="quantity"><%=en.getValue().getQuantity()%></span>
                                        <button class="quantity-btn plus">+</button>
                                    </div>
                                </div>
                                <div class="cart-price-controls">
                                    <span class="cart-item-price">₹<%=en.getValue().getItemTotalPrice()%></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                    }
                    %>
                </div>

                <div class="cart-order-summary">
                    <div class="cart-summary-header">
                        <h2>Order Summary</h2>
                        <span class="cart-delivery-time">
                            <i class="fas fa-clock"></i> Estimated delivery: 30-45 min
                        </span>
                    </div>

                    <div class="cart-summary-content">
                        <div class="cart-summary-row">
                            <span>Subtotal</span>
                            <span id="subtotal">₹<%=cart.getTotalPrice()%></span>
                        </div>
                        <div class="cart-summary-row">
                            <span>Delivery Fee</span>
                            <span>₹40</span>
                        </div>
                        <div class="cart-summary-row">
                            <span>Tax</span>
                            <span>₹18</span>
                        </div>
                        <div class="cart-summary-row cart-total">
                            <span>Total</span>
                            <span id="total">₹<%=cart.getTotalPrice() + 40 + 18%></span>
                        </div>
                    </div>

                    <div class="cart-promo-section">
                        <input type="text" placeholder="Enter promo code" class="cart-promo-input">
                        <button class="cart-promo-btn">Apply</button>
                    </div>

                    <form  action="checkout.jsp" method="POST">
                        <button type="submit"  class="cart-checkout-btn">
                            <i class="fas fa-lock"></i> Secure Checkout
                        </button>
                    </form>
                    
                    <button onclick="window.location.href='menu.jsp?restaurantId=<%=cart.getRestaurantId()%>'" class="cart-continue-btn">
                        <i class="fas fa-arrow-left"></i> Add More Items
                    </button>

                    <div class="cart-payment-methods">
                        <span class="cart-payment-label">We Accept:</span>
                        <div class="cart-payment-icons">
                            <i class="fab fa-cc-visa"></i>
                            <i class="fab fa-cc-mastercard"></i>
                            <i class="fab fa-cc-amex"></i>
                            <i class="fab fa-cc-paypal"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
    }
    %>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Function to update cart UI
        function updateCartUI(cartData) {
            // Update item count
            document.getElementById('itemCount').textContent = cartData.itemCount;

            // Update prices
            document.getElementById('subtotal').textContent = `₹${cartData.totalPrice}`;
            document.getElementById('total').textContent = `₹${cartData.totalPrice + 40 + 18}`;

            // Update quantities and prices for each item
            cartData.items.forEach(item => {
                const itemContainer = document.querySelector(`.cart-list-item[data-menu-id="${item.menuId}"]`);
                if (itemContainer) {
                    const quantitySpan = itemContainer.querySelector('.quantity');
                    const priceSpan = itemContainer.querySelector('.cart-item-price');
                    
                    if (quantitySpan) quantitySpan.textContent = item.quantity;
                    if (priceSpan) priceSpan.textContent = `₹${item.price * item.quantity}`;
                }
            });

            // Remove items with quantity 0
            const itemsToRemove = cartData.items.filter(item => item.quantity === 0);
            itemsToRemove.forEach(item => {
                const itemElement = document.querySelector(`.cart-list-item[data-menu-id="${item.menuId}"]`);
                if (itemElement) {
                    itemElement.remove();
                }
            });

            // If cart is empty, redirect to restaurants page
            if (cartData.itemCount === 0) {
                window.location.href = 'cart.jsp';
            }
        }

        // Function to make AJAX request
        async function updateCart(menuId, restaurantId, price, action) {
            try {
                const response = await fetch('cart', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `menuId=${menuId}&restaurantId=${restaurantId}&price=${price}&action=${action}&quantity=1`
                });

                if (!response.ok) throw new Error('Network response was not ok');
                
                const cartData = await response.json();
                updateCartUI(cartData);
            } catch (error) {
                console.error('Error:', error);
            }
        }

        // Event delegation for cart controls
        document.querySelector('.cart-main-content').addEventListener('click', function(e) {
            const cartControl = e.target.closest('.cart-controls');
            if (!cartControl) return;

            const menuId = cartControl.dataset.menuId;
            const restaurantId = cartControl.dataset.restaurantId;
            const price = cartControl.dataset.price;

            if (e.target.classList.contains('minus') || e.target.classList.contains('plus')) {
                const action = e.target.classList.contains('minus') ? 'remove' : 'add';
                updateCart(menuId, restaurantId, price, action);
            }
        });
    });
    </script>
</body>
</html>