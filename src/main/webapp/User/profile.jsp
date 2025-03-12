<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.DAO.*"%>
<%@ page import="com.tap.DAOImpl.*"%>
<%@ page import="com.utility.*"%>
<%@ page import="com.tap.model.*, java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>User Profile - Tap Foods</title>
<link rel="stylesheet" href="../styles/menu.css">
<link rel="stylesheet" href="../styles/profile.css">
<link rel="stylesheet" href="../styles/user-dropdown.css">
<link rel="stylesheet" href="../styles/cart-dropdown.css">
<link rel="stylesheet" href="../styles/restaurant.css">
<link rel="stylesheet" href="../styles/user_homepage.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<!-- Navbar section remains the same -->
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

	<div class="profile-container">
		<div class="profile-header">
			<img
				src="https://images.unsplash.com/photo-1633332755192-727a05c4013d"
				alt="Profile" class="profile-avatar">
			<div>
				<%
				if (user != null) {
				%>
				<h1 class="profile-name"><%=user.getUsername()%></h1>
				<p class="profile-email"><%=user.getEmail()%></p>
			</div>
		</div>

		<div class="profile-section">
			<div class="section-title">
				<h2>Personal Information</h2>
				<button class="edit-btn" onclick="togglePersonalEdit()">
					<i class="fas fa-edit"></i> Edit
				</button>
			</div>

			<div class="profile-info" id="personal-info">
				<div class="profile-field">
					<div class="field-label">Full Name</div>
					<div class="field-value"><%=user.getName()%></div>
				</div>
				<div class="profile-field">
					<div class="field-label">Email</div>
					<div class="field-value"><%=user.getEmail()%></div>
				</div>
				<div class="profile-field">
					<div class="field-label">Phone</div>
					<div class="field-value"><%=user.getPhone()%></div>
				</div>
			</div>

			<form class="profile-form" action="../UpdateUserDetails"
				method="post" id="personal-form" style="display: none;">
				<div class="form-group">
					<label class="form-label">Full Name</label> <input type="text"
						class="form-input" name="name" value="<%=user.getName()%>">
				</div>
				<div class="form-group">
					<label class="form-label">Email</label> <input type="email"
						class="form-input" name="email" value="<%=user.getEmail()%>">
				</div>
				<div class="form-group">
					<label class="form-label">Phone</label> <input type="tel"
						class="form-input" name="phone" value="<%=user.getPhone()%>">
				</div>
				<div class="form-actions">
					<button type="button" class="cancel-btn"
						onclick="togglePersonalEdit()">Cancel</button>
					<button type="submit" class="edit-btn">Save Changes</button>
				</div>
			</form>
		</div>

		<div class="profile-section">
			<div class="section-title">
				<h2>Saved Addresses</h2>
			</div>

			<div class="address-list">
				<%
				List<Address> addresses = user.getAddresses();
				for (Address address : addresses) {
				%>
				<div class="address-item">
					<div class="address-content">
						<div class="address-header">
							<div class="field-label">Contact Details</div>
							<div class="field-value"><%=address.getName()%>
								<%=address.getPhone()%></div>
						</div>
						<div class="address-details">
							<div class="field-label">Address</div>
							<div class="field-value"><%=address.getAddress()%></div>
						</div>
					</div>
					<div class="address-actions">
						<button class="edit-btn" style="background-color: red;"
							onclick="window.location.href='../deleteAddress?addressId=<%=address.getAddressId()%>'">
							<i class="fas fa-trash"></i> Delete
						</button>

						<button class="edit-btn"
							onclick="toggleAddressEdit(<%=address.getAddressId()%>)">
							<i class="fas fa-edit"></i> Edit
						</button>
					</div>
				</div>

				<form class="address-form"
					id="address-form-<%=address.getAddressId()%>">
					<div class="form-group">
						<label class="form-label">Full Name</label> <input type="text"
							class="form-input" name="name" value="<%=address.getName()%>">
					</div>
					<div class="form-group">
						<label class="form-label">Phone Number</label> <input type="tel"
							class="form-input" name="phone" value="<%=address.getPhone()%>">
					</div>
					<div class="form-group">
						<label class="form-label">Address</label>
						<textarea class="address-textarea" name="address"><%=address.getAddress()%></textarea>
					</div>
					<div class="form-actions">
						<button type="button" class="cancel-btn"
							onclick="toggleAddressEdit(<%=address.getAddressId()%>)">
							Cancel</button>
						<button type="submit" class="edit-btn">Save Changes</button>
					</div>
				</form>
				<%
				}
				%>
			</div>
		</div>
	</div>
	<%
	} else {
	response.sendRedirect("../index.jsp");
	}
	%>

	<script>
        function togglePersonalEdit() {
            const infoEl = document.getElementById('personal-info');
            const formEl = document.getElementById('personal-form');
            
            if (infoEl.style.display !== 'none') {
                infoEl.style.display = 'none';
                formEl.style.display = 'block';
            } else {
                infoEl.style.display = 'block';
                formEl.style.display = 'none';
            }
        }

        let currentlyEditingAddress = null;

        function toggleAddressEdit(addressId) {
            const addressForm = document.getElementById(`address-form-${addressId}`);
            
            // If there's already an address being edited, close it first
            if (currentlyEditingAddress && currentlyEditingAddress !== addressForm) {
                currentlyEditingAddress.style.display = 'none';
            }
            
            // Toggle the clicked address form
            if (addressForm.style.display === 'none' || addressForm.style.display === '') {
                addressForm.style.display = 'block';
                currentlyEditingAddress = addressForm;
            } else {
                addressForm.style.display = 'none';
                currentlyEditingAddress = null;
            }
        }
    </script>

	<div id="footer"></div>
	<script>
        fetch('../footer/footer.html')
            .then(response => response.text())
            .then(data => {
                document.getElementById('footer').innerHTML = data;
            })
            .catch(error => console.log('Error loading footer:', error));
    </script>
</body>
</html>