<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.tap.model.*, java.util.*, com.tap.DAOImpl.*, com.utility.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Restaurant Details - Tap Foods</title>
<link rel="stylesheet" href="../styles/restaurant_details.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<div class="container">
		<!-- Restaurant Details Section -->
		<div class="restaurant-details">
			<div class="restaurant-header">
				<h2>Restaurant Details</h2>
				<button class="edit-btn" onclick="toggleRestaurantEdit()">
					<i class="fas fa-edit"></i> Edit Restaurant
				</button>
			</div>

			<%
			int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
			RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl(HibernateUtility.getSessionFactory());
			Restaurant restaurant = restaurantDAOImpl.getRestaurant(restaurantId);

			session.setAttribute("restaurant", restaurant);
			%>

			<!-- Restaurant Info Display -->
			<div class="restaurant-info" id="restaurant-info-display">
				<div class="restaurant-image">
					<img src="<%=restaurant.getImagePath()%>" alt="Restaurant Image">
				</div>
				<div class="info-content">
					<h3><%=restaurant.getName()%></h3>
					<p>
						<strong>Status:</strong>
						<%=restaurant.getIsActive() ? "Active" : "Inactive"%></p>
					<p>
						<strong>Address:</strong>
						<%=restaurant.getAddress()%></p>
					<p>
						<strong>Phone:</strong>
						<%=restaurant.getPhone()%></p>
					<p>
						<strong>Cuisine Type:</strong>
						<%=restaurant.getCusineType()%></p>
				</div>
			</div>

			<!-- Restaurant Edit Form -->
			<form class="restaurant-edit-form" id="restaurant-edit-form"
				action="../UpdateRestaurantDetails" method="post"
				style="display: none;">
				<div class="form-group">
					<label for="restaurant-name">Restaurant Name</label> <input
						type="text" id="restaurant-name" name="restaurant_name"
						value="<%=restaurant.getName()%>" required>
				</div>
				<div class="form-group">
					<label for="restaurant-status">Status</label> <select
						id="restaurant-status" name="is_active">
						<option value="true"
							<%=restaurant.getIsActive() ? "selected" : ""%>>Active</option>
						<option value="false"
							<%=!restaurant.getIsActive() ? "selected" : ""%>>Inactive</option>
					</select>
				</div>
				<div class="form-group">
					<label for="restaurant-address">Address</label> <input type="text"
						id="restaurant-address" name="restaurant_address"
						value="<%=restaurant.getAddress()%>" required>
				</div>
				<div class="form-group">
					<label for="restaurant-phone">Phone Number</label> <input
						type="tel" id="restaurant-phone" name="restaurant_phone"
						value="<%=restaurant.getPhone()%>" required>
				</div>
				<div class="form-group">
					<label for="cuisine-type">Cuisine Type</label> <input type="text"
						id="cuisine-type" name="cuisine_type"
						value="<%=restaurant.getCusineType()%>" required>
				</div>
				<div class="form-group">
					<label for="restaurant-image">Image URL</label> <input type="url"
						id="restaurant-image" name="image_url"
						value="<%=restaurant.getImagePath()%>" required>
				</div>
				<div class="form-actions">
					<button type="submit" class="save-btn">Save Changes</button>
					<button type="button" class="cancel-btn"
						onclick="toggleRestaurantEdit()">Cancel</button>
				</div>
			</form>
		</div>

		<!-- Menu Items Section -->
		<div class="menu-items">
			<h2>Menu Items</h2>
			<div class="menu-grid">
				<%
				MenuDAOImpl menuDAOImpl = new MenuDAOImpl(HibernateUtility.getSessionFactory());
				for (Menu item : menuDAOImpl.getAllMenu(restaurant.getRestaurantId())) {
					session.setAttribute("currentMenu", item);
				%>
				<div class="menu-item-card">
					<div class="menu-item-display">
						<img src="<%=item.getImagePath()%>" alt="<%=item.getItemName()%>">
						<div class="item-details">
							<h3><%=item.getItemName()%></h3>
							<p class="description"><%=item.getDescription()%></p>
							<p class="price">
								$<%=item.getPrice()%></p>
							<p
								class="status <%=item.getIsAvailable() ? "available" : "unavailable"%>">
								<%=item.getIsAvailable() ? "Available" : "Unavailable"%>
							</p>
						</div>
						<button class="edit-item-btn"
							onclick="toggleMenuItemEdit(<%=item.getMenuId()%>)">
							<i class="fas fa-edit"></i>
						</button>
					</div>

					<!-- Menu Item Edit Form -->
					<form class="menu-item-edit"
						id="menu-item-edit-<%=item.getMenuId()%>" style="display: none;"
						method="post" action="../UpdateMenuDetails?menuId=<%=item.getMenuId()%>">
						<div class="form-group">
							<label for="item-name-<%=item.getMenuId()%>">Item Name</label> <input
								type="text" id="item-name-<%=item.getMenuId()%>"
								name="item_name" value="<%=item.getItemName()%>" required>
						</div>
						<div class="form-group">
							<label for="item-description-<%=item.getMenuId()%>">Description</label>
							<textarea id="item-description-<%=item.getMenuId()%>"
								name="menu_description" required><%=item.getDescription()%></textarea>
						</div>
						<div class="form-group">
							<label for="item-price-<%=item.getMenuId()%>">Price ($)</label> <input
								type="number" id="item-price-<%=item.getMenuId()%>" name="price"
								step="0.01" value="<%=item.getPrice()%>" required>
						</div>
						<div class="form-group">
							<label for="item-status-<%=item.getMenuId()%>">Status</label> <select
								id="item-status-<%=item.getMenuId()%>" name="is_available">
								<option value="true"
									<%=item.getIsAvailable() ? "selected" : ""%>>Available</option>
								<option value="false"
									<%=!item.getIsAvailable() ? "selected" : ""%>>Unavailable</option>
							</select>
						</div>
						<div class="form-group"">
							<label for="item-image-<%=item.getMenuId()%>">Image URL</label> <input
								type="url" id="item-image-<%=item.getMenuId()%>"
								name="image_path" value="<%=item.getImagePath()%>" required>
						</div>
						<div class="form-actions">
							<button type="submit" class="save-btn">Save Changes</button>
							<button type="button" class="cancel-btn"
								onclick="toggleMenuItemEdit(<%=item.getMenuId()%>)">Cancel</button>
						</div>
					</form>
				</div>
				<%
				}
				%>
			</div>
		</div>

		<!-- Add Menu Item Button -->
		<div class="add-menu-container">
			<button class="add-menu-btn" onclick="toggleAddMenuForm()">
				<i class="fas fa-plus"></i> Add New Menu Item
			</button>
		</div>

		<!-- Add Menu Item Form -->
		<div class="add-menu-form" id="add-menu-form" style="display: none;">
			<div class="form-header">
				<h3>Add New Menu Item</h3>
				<button class="close-btn" onclick="toggleAddMenuForm()">×</button>
			</div>
			<form action="../AddMenuItem" method="post">
				<div class="form-group">
					<label for="new-item-name">Item Name</label> <input type="text"
						id="new-item-name" name="item_name" required>
				</div>
				<div class="form-group">
					<label for="new-item-description">Description</label>
					<textarea id="new-item-description" name="menu_description"
						required></textarea>
				</div>
				<div class="form-group">
					<label for="new-item-price">Price ($)</label> <input type="number"
						id="new-item-price" name="price" step="0.01" required>
				</div>
				<div class="form-group">
					<label for="new-item-status">Status</label> <select
						id="new-item-status" name="is_available">
						<option value="true">Available</option>
						<option value="false">Unavailable</option>
					</select>
				</div>
				<div class="form-group">
					<label for="new-item-image">Image URL</label> <input type="url"
						id="new-item-image" name="image_path" required>
				</div>
				<div class="form-actions">
					<button type="submit" class="save-btn">Add Item</button>
					<button type="button" class="cancel-btn"
						onclick="toggleAddMenuForm()">Cancel</button>
				</div>
			</form>
		</div>
	</div>

	<script>
    let currentOpenForm = null; // Track currently open menu edit form

    function toggleRestaurantEdit() {
        const displayEl = document.getElementById('restaurant-info-display');
        const formEl = document.getElementById('restaurant-edit-form');
        
        if (displayEl.style.display !== 'none') {
            displayEl.style.display = 'none';
            formEl.style.display = 'block';
        } else {
            displayEl.style.display = 'flex';
            formEl.style.display = 'none';
        }
    }

    function toggleMenuItemEdit(itemId) {
        const formEl = document.getElementById(`menu-item-edit-${itemId}`);
        const displayEl = formEl.previousElementSibling;
        
        // Close any currently open form before opening a new one
        if (currentOpenForm && currentOpenForm !== formEl) {
            currentOpenForm.style.display = 'none';
            currentOpenForm.previousElementSibling.style.display = 'block';
        }
        
        if (formEl.style.display === 'none' || formEl.style.display === '') {
            displayEl.style.display = 'none';
            formEl.style.display = 'block';
            currentOpenForm = formEl;
        } else {
            displayEl.style.display = 'block';
            formEl.style.display = 'none';
            currentOpenForm = null;
        }
    }

    function toggleAddMenuForm() {
        const form = document.getElementById('add-menu-form');
        form.style.display = form.style.display === 'none' ? 'block' : 'none';
    }
</script>
	
</body>
</html>