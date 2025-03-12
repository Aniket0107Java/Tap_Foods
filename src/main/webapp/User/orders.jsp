<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.tap.model.*"%>
<%@ page import="com.tap.DAO.*"%>
<%@ page import="com.tap.DAOImpl.*"%>
<%@ page import="com.utility.*, java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order History - Tap Foods</title>
<link rel="stylesheet" href="../styles/menu.css">
<link rel="stylesheet" href="../styles/orders.css">
<link rel="stylesheet" href="../styles/user-dropdown.css">
<link rel="stylesheet" href="../styles/cart-dropdown.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<!-- Include your navbar here -->
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
	<div class="orders-container">
		<div class="orders-header">
			<h1 class="orders-title">Order History</h1>
			<p class="orders-subtitle">View all your past orders and their
				details</p>
		</div>

		<%
		OrderDAOImpl orderDAOImpl = new OrderDAOImpl(HibernateUtility.getSessionFactory());

		List<Orders> orders = orderDAOImpl.getAllOrders();

		Collections.sort(orders, (o1, o2) -> -Integer.compare(o1.getOrderId(), o2.getOrderId()));

		for (Orders order : orders) {
		%>

		<div class="order-card">
			<div class="order-header">
				<span class="order-id">#ORD12345<%=order.getOrderId()%></span> <span
					class="order-date"><%=order.getOrderDate()%></span>
			</div>
			<h2 class="order-restaurant"><%=order.getRestaurant().getName()%></h2>
			<div class="order-items">
				<%
				List<OrderItem> oi = order.getOrderItems();
				for (OrderItem orderItem : oi) {
				%>
				<div class="order-item">
					<img src="<%=orderItem.getMenu().getImagePath()%>"
						alt="Classic Burger">
					<div class="item-details">
						<div class="item-name"><%=orderItem.getMenu().getItemName()%></div>
						<div class="item-price">
							₹<%=orderItem.getQuantity() * orderItem.getMenu().getPrice()%></div>
					</div>
					<div class="item-quantity">
						x<%=orderItem.getQuantity()%></div>
				</div>
				<%
				}
				%>
			</div>
			<div class="order-footer">
				<div class="order-total">
					Total: ₹<%=order.getTotalAmount()%></div>
				<span
					class="order-status status-<%=order.getStatus().toLowerCase()%>"><%=order.getStatus()%></span>
			</div>
		</div>
		<%
		}
		%>
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
	<script src="script/cart.js"></script>
</body>
</html>