<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.DAO.*"%>
<%@ page import="com.tap.DAOImpl.*"%>
<%@ page import="com.utility.*"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Food Delivery - Restaurants</title>
<link rel="stylesheet" href="styles/restaurant.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>
	<header class="page-header">
		<div class="appname">
			<!-- <i class="fas fa-utensils"></i> -->
			<!-- <span>FoodExpress</span> -->
			<h1 class="appname">
				Tap <i class="fa-solid fa-hand-point-up"></i> Foods
			</h1>
		</div>
		<nav>
			<a href="sign_up.jsp">Sign Up</a> <a href="sign_in.jsp">Sign In</a>
		</nav>
	</header>

	<div class="restaurant-container">
		<div class="restaurant-grid">
			<%
			RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl(HibernateUtility.getSessionFactory());

			List<Restaurant> restaurants = restaurantDAOImpl.getAllRestaurant();
			if (restaurants != null && !restaurants.isEmpty()) {
				for (Restaurant restaurant : restaurants) {
			%>
			<div
				class="restaurant-card <%=restaurant.getIsActive() ? "" : "inactive"%>">
				<img src="<%=restaurant.getImagePath()%>"
					alt="<%=restaurant.getName()%>" class="restaurant-image">
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
			</div>
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
        fetch('footer/footer.html')
            .then(response => response.text())
            .then(data => {
                document.getElementById('footer').innerHTML = data;
            })
            .catch(error => console.log('Error loading footer:', error));
    </script>
</body>

</html>
