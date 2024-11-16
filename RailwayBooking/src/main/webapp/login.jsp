<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <h2>Login</h2>
    <form action="loginProcess.jsp" method="post">
        <label for="userType">Select User Type:</label><br>
        <input type="radio" id="customer" name="userType" value="customer" required>
        <label for="customer">Customer</label><br>
        <input type="radio" id="employee" name="userType" value="employee" required>
        <label for="employee">Employee</label><br><br>
        
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        
        <input type="submit" value="Login">
    </form>

    <br><br>

    <h2>Register</h2>
    <form action="registerProcess.jsp" method="post">
        <label for="first_name">First Name:</label>
        <input type="text" id="first_name" name="first_name" maxlength="20" required><br>

        <label for="last_name">Last Name:</label>
        <input type="text" id="last_name" name="last_name" maxlength="20" required><br>

        <label for="username_reg">Username:</label>
        <input type="text" id="username_reg" name="username" maxlength="10" required><br>

        <label for="password_reg">Password:</label>
        <input type="password" id="password_reg" name="password" maxlength="16" required><br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" maxlength="50" required><br>

        <input type="submit" value="Register">
    </form>
</body>
</html>
