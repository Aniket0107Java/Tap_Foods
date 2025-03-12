<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tap Foods - Sign Up</title>
<link rel="stylesheet" href="styles/main.css">
<link rel="stylesheet" href="styles/sign_up.css">
</head>
<body>
	<div class="container">
		<div class="form-card">
			<div class="form-header">
				<h2>Create Account</h2>
				<p>Join our food delivery platform</p>
			</div>

			<form action="saveUser" id="signupForm" method="post">
				<div class="form-group">
					<label for="name">Full Name</label> <input type="text" id="name"
						name="name" required>
				</div>

				<div class="form-group">
					<label for="username">Username</label> <input type="text"
						id="username" name="username" required>
				</div>

				<div class="form-group">
					<label for="password">Password</label> <input type="password"
						id="password" name="password" required>
				</div>

				<div class="form-group">
					<label for="email">Email</label> <input type="email" id="email"
						name="email" required>
				</div>

				<div class="form-group">
					<label for="phone">Phone Number</label> <input type="tel"
						id="phone" name="phone" required>
				</div>

				<div class="form-group">
					<label for="address">Address</label>
					<textarea id="address" name="address" rows="3" required></textarea>
				</div>

				<div class="form-group">
					<label for="role">Role</label> <select id="role" name="role"
						required>
						<option value="customer">Customer</option>
						<option value="Admin">Admin</option>
						<option value="delivery">Delivery Partner</option>
					</select>
				</div>

				<button type="submit" class="submit-btn">Create Account</button>

				<p class="login-link">
					Already have an account? <a href="sign_in.jsp">Sign in</a>
				</p>
			</form>
		</div>
	</div>
</body>
</html>