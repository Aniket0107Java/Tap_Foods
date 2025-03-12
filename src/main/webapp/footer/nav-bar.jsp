<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.DAO.*"%>
<%@ page import="com.tap.DAOImpl.*"%>
<%@ page import="com.utility.*"%>
<%@ page import="com.tap.model.*"%>
<nav class="navbar">
	<div class="nav-brand">
		<a href="User/user_homepage.jsp" style="text-decoration: none;"><h1
				class="appname">
				Tap <i class="fa-solid fa-hand-point-up"></i> Foods
			</h1></a>
	</div>

	<div class="nav-right">
		<div class="user-info">
			<i class="fas fa-user"></i>
			<%
			session = request.getSession();
			User user = (User) session.getAttribute("user");

			if (user != null) {
			%>
			<span><%=user.getUsername()%></span>
			<!-- Add user menu dropdown -->
			<div class="user-menu">
				<a href="profile.jsp" class="user-menu-item"> <i
					class="fas fa-user-circle"></i> Profile
				</a> <a href="orders.jsp" class="user-menu-item"> <i
					class="fas fa-shopping-bag"></i> Orders
				</a> <a href="../LogoutServlet" class="user-menu-item"> <i
					class="fas fa-sign-out-alt"></i> Logout
				</a>
			</div>
		</div>
		<div class="cart-container">
			<i class="fas fa-shopping-cart"></i> <span class="cart-count">0</span>
			<!-- Add cart dropdown -->
			<div class="cart-dropdown">
				<div class="cart-items">
					<!-- Cart items will be dynamically added here -->
				</div>
				<div class="cart-total">
					<span>Total:</span> <span>$0.00</span>
				</div>
				<a href="checkout.jsp" class="checkout-btn">Checkout</a>
			</div>
		</div>
	
	</div>
	<%
	} else {
	response.sendRedirect("../index.jsp");
	}
	%>
</nav>
