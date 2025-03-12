<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.tap.model.*"%>
<%@ page import="com.tap.DAO.*"%>
<%@ page import="com.tap.DAOImpl.*"%>
<%@ page import="com.utility.*"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tap Foods</title>
<link rel="stylesheet" href="../styles/restaurant.css">
<link rel="stylesheet" href="../styles/cart-dropdown.css">
<link rel="stylesheet" href="../styles/user-dropdown.css">
<link rel="stylesheet" href="../styles/user_homepage.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>
	<nav class="navbar">
		<!-- Previous navbar code remains the same -->
		<div class="nav-brand">
			<h1 class="appname">
				Tap <i class="fa-solid fa-hand-point-up"></i> Foods
			</h1>
		</div>
		<%
		session = request.getSession();
		User user = (User) session.getAttribute("user");
		if (user == null) {
			response.sendRedirect("../index.jsp");
		}
		%>

		<div class="nav-right">
			<div>
				<select class="sort-by">
					<option value="0" selected>Sort by</option>
					<option value="1">Name</option>
					<option value="2">Fastest Delivery</option>
					<option value="3">Rating 4 and above</option>
				</select>
			</div>
			<div class="search-wrapper">
				<label for="search"></label> <input type="search"
					placeholder="Search Restaurant" name="" id="search"
					class="search-restaurant" data-search>
			</div>
			<div class="user-info">
				<i class="fas fa-user"></i> <span><%=user.getUsername()%></span>
				<div class="user-menu">
					<a href="profile.jsp" class="user-menu-item"> <i
						class="fas fa-user-circle"></i> Profile
					</a> <a href="../cart.jsp" class="user-menu-item"> <i
						class="fas fa-shopping-cart"></i> Cart Items
					</a> <a href="orders.jsp" class="user-menu-item"> <i
						class="fas fa-shopping-bag"></i> Orders
					</a><a href="../sign_up.jsp" class="user-menu-item"> <i
						class="fa-solid fa-store"></i> Become a Merchant
					</a> <a href="../LogoutServlet" class="user-menu-item"> <i
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
				<!-- Add cart dropdown -->
				<div class="cart-dropdown">
					<div class="cart-items">
						<!-- Cart items will be dynamically added here -->
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
					<form action="../cart.jsp" method="POST">
						<button type="submit" class="checkout-btn">Checkout</button>
					</form>
					<%
					}
					%>
				</div>
			</div>

		</div>
	</nav>



	<div class="restaurant-container" data-restaurant-cards-container>
		<div class="restaurant-grid">
			<%
			RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl(HibernateUtility.getSessionFactory());

			List<Restaurant> restaurants = restaurantDAOImpl.getAllRestaurant();
			if (restaurants != null && !restaurants.isEmpty()) {
				for (Restaurant restaurant : restaurants) {
			%>
			<a href="../menu.jsp?restaurantId=<%=restaurant.getRestaurantId()%>"
				class="restaurant-card <%=restaurant.getIsActive() ? "" : "inactive"%>"
				data-name="<%=restaurant.getName()%>"
				data-cuisine="<%=restaurant.getCusineType()%>"> <img
				src="<%=restaurant.getImagePath()%>" alt="<%=restaurant.getName()%>"
				class="restaurant-image">
				<div class="restaurant-info">
					<div class="restaurant-header">
						<h2 class="restaurant-name"><%=restaurant.getName()%></h2>
						<span class="restaurant-rating"><%=restaurant.getRating()%>
							★</span>
					</div>
					<div class="restaurant-details">
						<p class="cuisine-type"><%=restaurant.getCusineType()%></p>
						<p><%=restaurant.getAddress()%></p>
						<span class="eta">ETA: <%=restaurant.getEta()%></span>
						<div>
							<span
								class="status-badge <%=restaurant.getIsActive() ? "status-active" : "status-inactive"%>">
								<%=restaurant.getIsActive() ? "Active" : "Currently Closed"%>
							</span>
						</div>
					</div>
				</div>
			</a>

			<%
			}
			} else {
			%>
			<p>No restaurants available at the moment.</p>
			<%
			}
			%>
		</div>
	</div>

	<div id="footer"></div>
	<script>
        fetch('../footer/footer.html')
            .then(response => response.text())
            .then(data => {
                document.getElementById('footer').innerHTML = data;
            })
            .catch(error => console.log('Error loading footer:', error));
    </script>
	<script src="../script/searchScript.js"></script>
	<script src="../script/sortScript.js"></script>
</body>

</html>
