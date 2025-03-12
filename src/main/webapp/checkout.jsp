<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.*"%>
<%@ page import="com.tap.DAO.*"%>
<%@ page import="com.tap.DAOImpl.*"%>
<%@ page import="com.utility.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - FoodExpress</title>
    <link rel="stylesheet" href="styles/menu.css">
    <link rel="stylesheet" href="styles/checkout.css">
    <link rel="stylesheet" href="styles/user-dropdown.css">
    <link rel="stylesheet" href="styles/cart-dropdown.css">
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
                    <a href="orders.jsp" class="user-menu-item">
                        <i class="fas fa-shopping-bag"></i> Orders
                    </a>
                    <a href="LogoutServlet" class="user-menu-item">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Add New Address Form -->
    <div class="modal" id="addressModal">
        <div class="modal-content">
            <button type="button" class="modal-close" onclick="toggleNewAddressForm()">×</button>
            <h2>Add New Address</h2>
            <form action="updateAddressServlet" method="post" id="new-address-form">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Street Address</label>
                    <input type="text" name="address" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Phone Number</label>
                    <input type="tel" name="phone" class="form-input" required>
                </div>
                <div class="form-actions">
                    <button type="button" class="cancel-btn" onclick="toggleNewAddressForm()">Cancel</button>
                    <button type="submit" class="save-btn">Save Address</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Main Checkout Form -->
    <form action="orderServlet" method="post" id="checkoutForm">
        <div class="checkout-container">
            <div class="checkout-header">
                <h1 class="checkout-title">Checkout</h1>
                <p class="checkout-subtitle">Complete your order</p>
            </div>

            <div class="checkout-section">
                <h2 class="section-title">Delivery Address</h2>
                <div class="saved-addresses">
                    <%
                    List<Address> addresses = user.getAddresses();
                    for (Address address : addresses) {
                    %>
                    <div class="address-card">
                        <input type="radio" name="selectedAddress" id="address-<%=address.getAddressId()%>" 
                               value="<%=address.getAddressId()%>" required
                               data-name="<%=address.getName()%>"
                               data-phone="<%=address.getPhone()%>"
                               data-address="<%=address.getAddress()%>"
                               onclick="updateSelectedAddress(this)">
                        <label for="address-<%=address.getAddressId()%>">
                            <h3><%=address.getName()%></h3>
                            <p><%=address.getAddress()%></p>
                            <p><%=address.getPhone()%></p>
                        </label>
                    </div>
                    <%
                    }
                    %>
                    <button type="button" class="add-address-btn" onclick="toggleNewAddressForm()">
                        <i class="fas fa-plus"></i> Add New Address
                    </button>
                </div>

                <!-- Hidden fields to store selected address details -->
                <input type="hidden" name="deliveryName" id="deliveryName">
                <input type="hidden" name="deliveryPhone" id="deliveryPhone">
                <input type="hidden" name="deliveryAddress" id="deliveryAddress">
            </div>

            <div class="checkout-section">
                <h2 class="section-title">Payment Method</h2>
                <div class="payment-methods">
                    <div class="payment-method">
                        <input type="radio" name="paymentMode" id="card-payment" value="card" checked>
                        <label for="card-payment">
                            <i class="fas fa-credit-card payment-icon"></i>
                            <span>Credit/Debit Card</span>
                        </label>
                    </div>

                    <div class="payment-method">
                        <input type="radio" name="paymentMode" id="upi-payment" value="upi">
                        <label for="upi-payment">
                            <i class="fas fa-mobile-alt payment-icon"></i>
                            <span>UPI Payment</span>
                        </label>
                    </div>

                    <div class="payment-method">
                        <input type="radio" name="paymentMode" id="cash-payment" value="cod">
                        <label for="cash-payment">
                            <i class="fas fa-money-bill payment-icon"></i>
                            <span>Cash on Delivery</span>
                        </label>
                    </div>
                </div>
            </div>

            <%
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                response.sendRedirect("User/user_homepage.jsp");
                return;
            }
            %>

            <div class="checkout-section">
                <h2 class="section-title">Order Summary</h2>
                <div class="order-summary">
                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span>₹<%=cart.getTotalPrice()%></span>
                    </div>
                    <div class="summary-row">
                        <span>Delivery Fee</span>
                        <span>₹40</span>
                    </div>
                    <div class="summary-row">
                        <span>Tax</span>
                        <span>₹18</span>
                    </div>
                    <div class="summary-row">
                        <span>Restaurant or Coupon Discount</span>
                        <span>-₹50</span>
                    </div>
                    <div class="summary-row total">
                        <span>Total</span>
                        <span>₹<%=(cart.getTotalPrice() + 40 + 18) - 50%></span>
                    </div>
                </div>
                <button type="submit" class="place-order">Place Order</button>
            </div>
        </div>
    </form>

    <script>
        function toggleNewAddressForm() {
            const modal = document.getElementById('addressModal');
            modal.classList.toggle('active');
            document.body.style.overflow = modal.classList.contains('active') ? 'hidden' : 'auto';
        }

        function updateSelectedAddress(radio) {
            // Update hidden fields with selected address details
            document.getElementById('deliveryName').value = radio.dataset.name;
            document.getElementById('deliveryPhone').value = radio.dataset.phone;
            document.getElementById('deliveryAddress').value = radio.dataset.address;
        }

        // Close modal when clicking outside
        document.getElementById('addressModal').addEventListener('click', function(e) {
            if (e.target === this) {
                toggleNewAddressForm();
            }
        });

        // Close modal with escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && document.getElementById('addressModal').classList.contains('active')) {
                toggleNewAddressForm();
            }
        });

        // Select the first address by default
        window.onload = function() {
            const firstAddress = document.querySelector('input[name="selectedAddress"]');
            if (firstAddress) {
                firstAddress.checked = true;
                updateSelectedAddress(firstAddress);
            }
        };
    </script>

    <style>
    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        justify-content: center;
        align-items: center;
    }

    .modal.active {
        display: flex;
    }

    .modal-content {
        background: white;
        padding: 2rem;
        border-radius: 12px;
        width: 90%;
        max-width: 500px;
        position: relative;
    }

    .modal-close {
        position: absolute;
        top: 1rem;
        right: 1rem;
        background: none;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
        color: #666;
    }

    .modal-close:hover {
        color: #000;
    }
    </style>
</body>
</html>