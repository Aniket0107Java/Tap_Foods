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
<title>Tap Foods</title>
<link rel="stylesheet" href="styles/menu.css">
<link rel="stylesheet" href="styles/user-dropdown.css">
<link rel="stylesheet" href="styles/cart-dropdown.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
.not-active-message {
	display: flex;
	flex-direction: column;
	text-align: center;
}

.modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.5);
	z-index: 1000;
	align-items: center;
	justify-content: center;
}

.modal {
	background: white;
	padding: 2rem;
	border-radius: 12px;
	max-width: 400px;
	width: 90%;
	text-align: center;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.modal h2 {
	color: #e53e3e;
	margin-bottom: 1rem;
	font-size: 1.5rem;
}

.modal p {
	color: #4a5568;
	margin-bottom: 1.5rem;
	line-height: 1.5;
}

.modal-buttons {
	display: flex;
	gap: 1rem;
	justify-content: center;
}

.modal-button {
	padding: 0.5rem 1.5rem;
	border-radius: 6px;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.2s;
}

.modal-button.primary {
	background-color: #e53e3e;
	color: white;
	border: none;
}

.modal-button.primary:hover {
	background-color: #c53030;
}

.modal-button.secondary {
	background-color: #fff;
	color: #4a5568;
	border: 1px solid #e2e8f0;
}

.modal-button.secondary:hover {
	background-color: #f7fafc;
}

.warning-icon {
	color: #e53e3e;
	font-size: 3rem;
	margin-bottom: 1rem;
}
</style>
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
					<a href="User/profile.jsp" class="user-menu-item"> <i
						class="fas fa-user-circle"></i> Profile
					</a> <a href="cart.jsp" class="user-menu-item"> <i
						class="fas fa-shopping-cart"></i> Cart Items
					</a> <a href="orders.jsp" class="user-menu-item"> <i
						class="fas fa-shopping-bag"></i> Orders
					</a> <a href="LogoutServlet" class="user-menu-item"> <i
						class="fas fa-sign-out-alt"></i> Logout
					</a>
				</div>
			</div>
			<%
			Cart cart = (Cart) session.getAttribute("cart");
			if (cart == null) {
				cart = new Cart();
				session.setAttribute("cart", cart);
			}
			%>
			<div class="cart-container">
				<i class="fas fa-shopping-cart"></i> <span class="cart-count"><%=cart.getItems().size()%></span>
				<div class="cart-dropdown">
					<div class="cart-items">
						<%
						Map<Integer, CartItem> allCartItem = cart.getItems();
						if (allCartItem.isEmpty()) {
						%>
						<div>Cart Empty Good food is always cooking! Go ahead, order
							some yummy items from the menu.</div>
						<%
						} else {
						MenuDAOImpl menuDAOImpl = new MenuDAOImpl(HibernateUtility.getSessionFactory());
						for (Map.Entry<Integer, CartItem> en : allCartItem.entrySet()) {
							int id = en.getKey();
							Menu m = menuDAOImpl.getMenu(id);
						%>
						<div class="cart-item">
							<img alt="" src="<%=m.getImagePath()%>">
							<div class="cart-item-details">
								<div class="cart-item-name"><%=m.getItemName()%></div>
								<div class="cart-item-price">
									₹<%=m.getPrice()%></div>
							</div>
							<div class="item-quantity">
								x<%=en.getValue().getQuantity()%></div>
						</div>
						<%
						}
						}
						%>
					</div>
					<%
					if (!allCartItem.isEmpty()) {
					%>
					<div class="cart-total">
						<span>Total:</span> <span>₹<%=cart.getTotalPrice()%></span>
					</div>
					<form action="cart.jsp" method="POST">
						<button type="submit" class="checkout-btn">Checkout</button>
					</form>
					<%
					}
					%>
				</div>
			</div>
		</div>
	</nav>

	<%
	int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
	RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl(HibernateUtility.getSessionFactory());
	Restaurant restaurant = restaurantDAOImpl.getRestaurant(restaurantId);
	%>

	<div class="restaurant-header">
		<h1><%=restaurant.getName()%></h1>
		<p class="restaurant-description">Discover our delicious selection
			of dishes made with fresh ingredients</p>
	</div>

	<div class="menu-container">
		<%
		if (!restaurant.getIsActive()) {
		%>
		<h3 class="not-active-message">
			Sorry for inconvenience but,
			<%=restaurant.getName()%>
			is not accepting order right now!
		</h3>
		<%
		} else {
		MenuDAOImpl menuDAOImpl = new MenuDAOImpl(HibernateUtility.getSessionFactory());
		List<Menu> allMenu = menuDAOImpl.getAllMenu(restaurantId);

		for (Menu menu : allMenu) {
		%>
		<div class="menu-item" data-menu-id="<%=menu.getMenuId()%>">
			<div class="menu-image">
				<img src="<%=menu.getImagePath()%>" alt="<%=menu.getItemName()%>">
				<span
					class="availability-badge <%=menu.getIsAvailable() ? "available" : "not-available"%>">
					<%=menu.getIsAvailable() ? "Available" : "Not Available"%>
				</span>
			</div>
			<div class="menu-content">
				<h2><%=menu.getItemName()%></h2>
				<p class="description"><%=menu.getDescription()%></p>
				<div class="menu-details">
					<span class="price">₹<%=menu.getPrice()%></span>
					<div class="rating">
						<span class="stars">★★★★☆</span> <span class="rating-number"><%=menu.getRatings()%></span>
					</div>
				</div>
				<%
				if (cart == null) {
					cart = new Cart();
					session.setAttribute("cart", cart);
				}

				Map<Integer, CartItem> allCartItems = cart.getItems();
				CartItem existingItem = allCartItems.get(menu.getMenuId());
				%>

				<div class="cart-controls" data-menu-id="<%=menu.getMenuId()%>"
					data-restaurant-id="<%=restaurantId%>"
					data-price="<%=menu.getPrice()%>">
					<%
					if (existingItem == null) {
					%>
					<button class="add-to-cart"
						<%=menu.getIsAvailable() ? "" : "disabled"%>>Add to Cart</button>
					<%
					} else {
					%>
					<div class="cart-actions">
						<div class="quantity-controls">
							<button class="quantity-btn minus">-</button>
							<span class="quantity"><%=existingItem.getQuantity()%></span>
							<button class="quantity-btn plus">+</button>
						</div>
					</div>
					<%
					}
					%>
				</div>
			</div>
		</div>
		<%
		}
		}
		%>
	</div>

	<div class="modal-overlay">
		<div class="modal">
			<i class="fas fa-exclamation-triangle warning-icon"></i>
			<h2>Different Restaurant</h2>
			<p>Your cart contains items from a different restaurant. Would
				you like to clear your cart and add items from this restaurant
				instead?</p>
			<div class="modal-buttons">
				<button class="modal-button secondary" onclick="closeModal()">Cancel</button>
				<button class="modal-button primary"
					onclick="confirmRestaurantChange()">Clear Cart & Add</button>
			</div>
		</div>
	</div>

	<div id="footer"></div>

	<script>
    document.addEventListener('DOMContentLoaded', function() {
        let pendingCartAction = null;
        const modalOverlay = document.querySelector('.modal-overlay');

        function showModal() {
            modalOverlay.style.display = 'flex';
        }

        function closeModal() {
            modalOverlay.style.display = 'none';
            pendingCartAction = null;
        }

        function confirmRestaurantChange() {
            if (pendingCartAction) {
                const { menuId, restaurantId, price, action } = pendingCartAction;
                updateCart(menuId, restaurantId, price, action);
                closeModal();
            }
        }

        // Function to update cart UI
        function updateCartUI(cartData) {
            // Update cart count
            document.querySelector('.cart-count').textContent = cartData.itemCount;

            // Update cart dropdown
            const cartItems = document.querySelector('.cart-items');
            const cartDropdown = document.querySelector('.cart-dropdown');
            
            if (cartData.itemCount === 0) {
                // Clear cart items and remove total/checkout
                cartItems.innerHTML = '<div>Cart Empty Good food is always cooking! Go ahead, order some yummy items from the menu.</div>';
                // Remove existing total and checkout if they exist
                const existingTotal = cartDropdown.querySelector('.cart-total');
                const existingCheckout = cartDropdown.querySelector('form');
                if (existingTotal) existingTotal.remove();
                if (existingCheckout) existingCheckout.remove();
            } else {
                // Update cart items
                let itemsHtml = '';
                cartData.items.forEach(item => {
                    itemsHtml += `
                        <div class="cart-item">
                            <img alt="" src="${item.imagePath}">
                            <div class="cart-item-details">
                                <div class="cart-item-name">${item.name}</div>
                                <div class="cart-item-price">₹${item.price}</div>
                            </div>
                            <div class="item-quantity">x${item.quantity}</div>
                        </div>
                    `;
                });
                cartItems.innerHTML = itemsHtml;

                // Update or add total
                let cartTotal = cartDropdown.querySelector('.cart-total');
                if (!cartTotal) {
                    cartTotal = document.createElement('div');
                    cartTotal.className = 'cart-total';
                    cartDropdown.appendChild(cartTotal);
                }
                cartTotal.innerHTML = `<span>Total:</span> <span>₹${cartData.totalPrice}</span>`;

                // Update or add checkout form
                let checkoutForm = cartDropdown.querySelector('form');
                if (!checkoutForm) {
                    checkoutForm = document.createElement('form');
                    checkoutForm.action = 'checkout';
                    checkoutForm.method = 'POST';
                    checkoutForm.innerHTML = '<button type="submit" class="checkout-btn">Checkout</button>';
                    cartDropdown.appendChild(checkoutForm);
                }
            }

            // Update menu item controls
            cartData.items.forEach(item => {
                const menuItem = document.querySelector(`.cart-controls[data-menu-id="${item.menuId}"]`);
                if (menuItem) {
                    menuItem.innerHTML = `
                        <div class="cart-actions">
                            <div class="quantity-controls">
                                <button class="quantity-btn minus">-</button>
                                <span class="quantity">${item.quantity}</span>
                                <button class="quantity-btn plus">+</button>
                            </div>
                        </div>
                    `;
                }
            });

            // Reset "Add to Cart" buttons for items not in cart
            document.querySelectorAll('.cart-controls').forEach(control => {
                const menuId = control.dataset.menuId;
                const itemInCart = cartData.items.some(item => item.menuId === parseInt(menuId));
                if (!itemInCart) {
                    const isAvailable = !control.closest('.menu-item').querySelector('.availability-badge').classList.contains('not-available');
                    control.innerHTML = `<button class="add-to-cart" ${isAvailable ? '' : 'disabled'}>Add to Cart</button>`;
                }
            });
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
        document.querySelector('.menu-container').addEventListener('click', async function(e) {
            const cartControl = e.target.closest('.cart-controls');
            if (!cartControl) return;

            const menuId = cartControl.dataset.menuId;
            const restaurantId = cartControl.dataset.restaurantId;
            const price = cartControl.dataset.price;

            if (e.target.classList.contains('add-to-cart') || 
                e.target.classList.contains('minus') || 
                e.target.classList.contains('plus')) {
                
                const action = e.target.classList.contains('minus') ? 'remove' : 'add';
                
                // Only check for restaurant change when adding a new item
                if (e.target.classList.contains('add-to-cart')) {
                    // Check if cart is empty or from same restaurant
                    const response = await fetch('cart', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `menuId=${menuId}&restaurantId=${restaurantId}&price=${price}&action=check&quantity=1`
                    });
                    
                    const cartData = await response.json();
                    
                    if (cartData.itemCount === 0 || cartData.restaurantId === parseInt(restaurantId)) {
                        updateCart(menuId, restaurantId, price, action);
                    } else {
                        pendingCartAction = { menuId, restaurantId, price, action };
                        showModal();
                    }
                } else {
                    // For plus/minus buttons, directly update the cart
                    updateCart(menuId, restaurantId, price, action);
                }
            }
        });

        // Make modal functions globally available
        window.closeModal = closeModal;
        window.confirmRestaurantChange = confirmRestaurantChange;
    });

    // Load footer
    fetch('footer/footer.html')
        .then(response => response.text())
        .then(data => {
            document.getElementById('footer').innerHTML = data;
        })
        .catch(error => console.log('Error loading footer:', error));
    </script>
</body>
</html>