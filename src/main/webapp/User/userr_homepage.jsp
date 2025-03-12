<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.DAO.*"%>
<%@ page import="com.tap.DAOImpl.*"%>
<%@ page import="com.utility.*"%>
<%@ page import="com.tap.model.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodExpress Delivery</title>

<link rel="stylesheet" href="../styles/user-dropdown.css">
<link rel="stylesheet" href="../styles/cart-dropdown.css">
<link rel="stylesheet" href="../styles/restaurant.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

</head>
<body>


	<!-- Include your navbar here -->
	<div id="nav-bar"></div>
	<script>
        fetch('../footer/nav-bar.jsp')
            .then(response => response.text())
            .then(data => {
                document.getElementById('nav-bar').innerHTML = data;
            })
            .catch(error => console.log('Error loading footer:', error));
    </script>




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
	<script>
        document.addEventListener('DOMContentLoaded', function () {
            const cartCount = document.querySelector('.cart-count');
            let totalItems = 0;

            document.querySelectorAll('.menu-item').forEach(item => {
                const addButton = item.querySelector('.add-to-cart');
                const quantityControls = item.querySelector('.quantity-controls');
                const quantityDisplay = item.querySelector('.quantity');
                const plusBtn = item.querySelector('.plus');
                const minusBtn = item.querySelector('.minus');
                let quantity = 0;

                if (addButton.disabled) return;

                addButton.addEventListener('click', () => {
                    quantity = 1;
                    totalItems++;
                    cartCount.textContent = totalItems;
                    quantityDisplay.textContent = quantity;
                    addButton.classList.add('hidden');
                    quantityControls.classList.remove('hidden');
                });

                plusBtn.addEventListener('click', () => {
                    quantity++;
                    totalItems++;
                    cartCount.textContent = totalItems;
                    quantityDisplay.textContent = quantity;
                });

                minusBtn.addEventListener('click', () => {
                    if (quantity > 0) {
                        quantity--;
                        totalItems--;
                        cartCount.textContent = totalItems;
                        quantityDisplay.textContent = quantity;
                        if (quantity === 0) {
                            addButton.classList.remove('hidden');
                            quantityControls.classList.add('hidden');
                        }
                    }
                });
            });
        });
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
	<script src="../script/cart.js"></script>
</body>

</html>