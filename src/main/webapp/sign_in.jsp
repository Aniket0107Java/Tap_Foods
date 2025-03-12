<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tap Foods - Sign In</title>
<link rel="stylesheet" href="styles/main.css">
<link rel="stylesheet" href="styles/sign_up.css">
</head>
<body>
	<div class="container">
		<div class="form-card">
			<div class="form-header">
				<%
					/* String msg = (String)request.getAttribute("message"); */
				String msg = (String)session.getAttribute("message");
				
					if(msg == null){
						%>
				<h2>Welcome Back</h2>
				<p>Sign in to your account</p>
				<% 	
					}else if(msg.equals("Login Failed: Invalid Username or Password")){
						session.removeAttribute("message");
						%>
				<h2>Login Failed:</h2>
				<p>Invalid Username or Password</p>
				<%
					}
				%>
			</div>
			<!-- onsubmit="return false;" -->
			<form id="signinForm" action="UserLogin" method="post">
				<div class="form-group">
					<label for="email">Email</label> <input type="email" id="email"
						name="email" required>
				</div>
				<input type="hidden" value = "customer" name="role">
				<div class="form-group">
					<label for="password">Password</label> <input type="password"
						id="password" name="password" required> <a href="#"
						class="forgot-password">Forgot password?</a>
				</div>

				<button type="submit" class="submit-btn">Sign In</button>

				<p class="login-link">
					Sign in as<a href="Admin/admin_sign_in.jsp"> Admin</a>
				</p>
				<p class="login-link">
					Don't have an account? <a href="sign_up.jsp">Sign up</a>
				</p>
			</form>
		</div>
	</div>
</body>
</html>