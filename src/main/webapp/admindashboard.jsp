<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.utility.HibernateUtility"%>
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
<title>Food Delivery Admin Dashboard</title>
<link rel="stylesheet" href="styles/admindashboard.css">
<link rel="stylesheet" href="styles/user-dropdown.css">
<link rel="stylesheet" href="styles/cart-dropdown.css">
<link rel="stylesheet" href="styles/profile.css">
<link rel="stylesheet" href="styles/menu.css">
<link rel="stylesheet" href="styles/orders.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<nav class="navbar">
		<div class="nav-brand">
			<a href="restaurant.jsp" style="text-decoration: none;"><h1
					class="appname">
					Tap <i class="fa-solid fa-hand-point-up"></i> Foods
				</h1></a>
		</div>
		<%
		User user = (User) session.getAttribute("user");
		if (user == null) {
			response.sendRedirect("Admin/admin_sign_in.jsp");
			return;
		}
		session.setAttribute("user", user);
		%>
		<div class="nav-right">
			<div class="user-info">
				<i class="fas fa-user"></i> <span><%=user.getName()%></span>
				<!-- Add user menu dropdown -->
				<div class="user-menu">
					<a href="profile.jsp" class="user-menu-item"> <i
						class="fas fa-user-circle"></i> Profile
					</a> <a href="orders.jsp" class="user-menu-item"><i
						class="fa-solid fa-utensils"></i> Total Restaurants </a> <a href="#"
						class="user-menu-item"> <i class="fa-solid fa-user"></i>
						Active Users
					</a> <a href="#" class="user-menu-item"><i
						class="fas fa-shopping-bag"></i> Total Orders </a> <a href="#"
						class="user-menu-item"> <i class="fa-solid fa-money-bill"></i>
						Revenue
					</a> <a href="Logout" class="user-menu-item"> <i
						class="fas fa-sign-out-alt"></i> Logout
					</a>
				</div>
			</div>
		</div>
	</nav>
	<div class="main-content">
		<!-- Dashboard Content -->
		<div class="dashboard">
			<div class="dashboard-header">
				<h2>Dashboard Overview</h2>

			</div>
			<%
			RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl(HibernateUtility.getSessionFactory());

			List<Restaurant> restaurants = restaurantDAOImpl.getAllRestaurantByUserId(user.getUserId());
			if (restaurants != null && !restaurants.isEmpty()) {
				OrderDAOImpl orderDAOImpl = new OrderDAOImpl(HibernateUtility.getSessionFactory());
				
				List<Orders> orders = orderDAOImpl.getAllOrdersByAdminId(user.getUserId());
				
				Collections.sort(orders, (o1, o2) -> -Integer.compare(o1.getOrderId(), o2.getOrderId()));
			%>
			<!-- Stats Grid -->
			<div class="stats-grid">
				<div class="stat-card">
					<h3>Total Restaurants</h3>
					<p class="stat-number"><%=restaurants.size()%></p>
					<p class="stat-trend positive">+12.5%</p>
				</div>
				<div class="stat-card">
					<h3>Total Orders</h3>
					<p class="stat-number"><%=orders.size()%></p>
					<p class="stat-trend positive">+8.2%</p>
				</div>
				<div class="stat-card">
					<h3>Revenue</h3>
					<%
					int revenue = 0;
					for (Orders order : orders) {
						revenue += order.getTotalAmount();
					}
					%>
					<p class="stat-number">
						₹<%=revenue%></p>
					<p class="stat-trend positive">+10.8%</p>
				</div>
			</div>

			<!-- Recent Orders -->
			<div class="card">
				<div class="card-header">
					<h3>Recent Orders</h3>
					<button class="view-all">View All</button>
				</div>
				<form action="updateStatus" method="post">
					<table class="orders-table">
						<thead>
							<tr>
								<th>Order ID</th>
								<th>Customer</th>
								<th>Restaurant</th>
								<th>Amount</th>
								<th>Status</th>
								<th>Action</th>
								<th>Update Status</th>
							</tr>
						</thead>
						<%
						for (Orders order : orders) {
						%>
						<form action="updateStatus" method="POST">
							<input type="hidden" name="orderId"
								value="<%=order.getOrderId()%>">
							<tbody>
								<tr>
									<td>#1234<%=order.getOrderId()%></td>
									<td><%=order.getDeliveryName()%></td>
									<td><%=order.getRestaurant().getName()%></td>
									<td>₹<%=order.getTotalAmount()%></td>
									<td><span
										class="status <%=order.getStatus().toLowerCase()%>">
											<%=order.getStatus()%></span></td>
									<td><select class="status-select" name="orderStatus">
											<option value="Pending"
												<%="pending".equalsIgnoreCase(order.getStatus()) ? "selected" : ""%>>Pending</option>
											<option value="Processing"
												<%="processing".equalsIgnoreCase(order.getStatus()) ? "selected" : ""%>>Processing</option>
											<option value="Delivered"
												<%="delivered".equalsIgnoreCase(order.getStatus()) ? "selected" : ""%>>Delivered</option>
											<option value="Cancelled"
												<%="cancelled".equalsIgnoreCase(order.getStatus()) ? "selected" : ""%>>Cancelled</option>
									</select></td>
									<td>
										<button type="submit" class="add-restaurant-btn">Update</button>
									</td>
								</tr>
							</tbody>
						</form>
						<%
						}
						%>

					</table>
				</form>
			</div>

			<!-- Top Restaurants -->
			<div class="card">
				<div class="card-header">
					<h3>All Restaurants</h3>
					<!-- <button class="view-all">View All</button> -->
				</div>

				<div class="restaurant-grid">
					<%
					for (Restaurant restaurant : restaurants) {

						/* session.setAttribute("restaurant", restaurant); */
					%>
					<a
						href="Admin/restaurant_details.jsp?restaurantId=<%=restaurant.getRestaurantId()%>"
						style="cursor: pointer; text-decoration: none;"
						class="restaurant-card"> <img
						src="https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80"
						alt="Restaurant">
						<div class="restaurant-info">
							<h4><%=restaurant.getName()%></h4>
							<p>156 orders</p>
							<p class="revenue">₹<%=revenue %></p>
						</div>
					</a>
					<%
					}
					}
					%>
				</div>
			</div>
			<button class="add-restaurant-btn" onclick="toggleRestaurantForm()">
				+ Add New Restaurant</button>
			<!-- Add New Restaurant (Hidden by default) -->
			<div class="card restaurant-form-container" style="display: none;">
				<div class="card-header">
					<h3>Add New Restaurant</h3>
					<button class="close-btn" onclick="toggleRestaurantForm()">×</button>
				</div>
				<form class="add-restaurant-form" action="admin/addRestaurant"
					method="post" enctype="multipart/form-data">
					<div class="form-group">
						<label for="restaurant-name">Restaurant Name</label> <input
							type="text" id="restaurant-name" required name="restaurant_name">
					</div>
					<div class="form-group">
						<label for="restaurant-address">Address</label> <input type="text"
							id="restaurant-address" required name="restaurant_address">
					</div>
					<div class="form-row">
						<div class="form-group">
							<label for="restaurant-phone">Phone Number</label> <input
								type="tel" id="restaurant-phone" required
								name="restaurant_phone">
						</div>
						<div class="form-group">
							<label for="restaurant-email">Cusine Type</label> <input
								type="text" id="restaurant-email" required name="cusinetype">
						</div>
					</div>
					<div class="form-group">
						<label for="restaurant-image">Restaurant Image URL</
							label> <input type="text" id="imageUrl" required name="imageUrl"
							oninput="previewImage()">
							<h5>Or</h5> <label for="fileInput">Upload Image:</label> <input
							type="file" id="fileInput" name="file" accept="image/*"
							oninput="previewImage()"> <br> <br> Image
							Preview <img id="preview" src="" alt="Image Preview"
							width="200px" height="auto"
							style="display: block; border: 1px solid #ddd; margin-top: 10px;">

							<br>
					</div>

					<div class="menu-items-section">
						<div class="menu-items-header">
							<h3>Menu Items</h3>
							<div class="menu-count-input">
								<label for="menu-count">Number of Items:</label> <input
									type="number" id="menu-count" name="menu-count" min="1"
									max="10" value="1" onchange="updateMenuItems()">
							</div>
						</div>
						<div id="menu-items-container" class="menu-items-container">
							<!-- Menu items will be dynamically added here -->
						</div>
					</div>

					<button type="submit" class="submit-btn">Add Restaurant</button>
				</form>
			</div>
		</div>
	</div>
	<script>
		function toggleRestaurantForm() {
			const form = document.querySelector('.restaurant-form-container');
			form.style.display = form.style.display === 'none' ? 'block'
					: 'none';
		}
	</script>
	<div id="footer"></div>
	<script>
        fetch('footer/footer.html')
            .then(response => response.text())
            .then(data => {
                document.getElementById('footer').innerHTML = data;
            })
            .catch(error => console.log('Error loading footer:', error));
    </script>
	<script>
		function updateMenuItems() {
		    const container = document.getElementById('menu-items-container');
		    const count = parseInt(document.getElementById('menu-count').value) || 1;
		    
		    container.innerHTML = '';
		    
		    for (let i = 1; i <= count; i++) {
		        container.innerHTML += `
		            <div class="menu-item">
		                <h4>Menu Item #${i}</h4>
		                <div class="form-group">
		                    <label for="item-name-${i}">Item Name</label>
		                    <input type="text" id="item-name-${i}" name="item-name-${i}" required>
		                </div>
		                <div class="form-group">
		                    <label for="item-description-${i}">Description</label>
		                    <textarea id="item-description-${i}" name="item-description-${i}" required></textarea>
		                </div>
		                <div class="form-group">
		                    <label for="item-price-${i}">Price ($)</label>
		                    <input type="number" id="item-price-${i}" name="item-price-${i}" step="0.01" required>
		                </div>
		                <div class="form-group">
		                    <label for="item-rating-${i}">Rating (1-5)</label>
		                    <input type="number" id="item-rating-${i}" name="item-rating-${i}" min="1" max="5" step="0.1" class="rating-input" required>
		                </div>
		                <div class="form-group">
		                    <label for="item-image-${i}">Image URL</label>
		                    <input type="url" id="item-image-${i}" name="item-image-${i}" required>
		                </div>
		            </div>
		        `;
		    }
		}

		// Initialize with one menu item
		document.addEventListener('DOMContentLoaded', function() {
		    updateMenuItems();
		});
		 function previewImage() {
	            let urlInput = document.getElementById("imageUrl").value;
	            let fileInput = document.getElementById("fileInput");
	            let preview = document.getElementById("preview");

	            if (urlInput.trim() !== "") {
	                preview.src = urlInput;
	            } else if (fileInput.files.length > 0) {
	                let file = fileInput.files[0];
	                let reader = new FileReader();

	                reader.onload = function (e) {
	                    preview.src = e.target.result;
	                };
	                reader.readAsDataURL(file);
	            }
	        }
</script>
</body>
</html>