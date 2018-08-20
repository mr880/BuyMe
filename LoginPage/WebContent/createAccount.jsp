<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	    pageEncoding="ISO-8859-1"%>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
	
	
	
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<html>


<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" type="text/css" href="style.css">
	<title>New User</title>
</head>



<body>
	
	<%
	session.setAttribute("class", "customer");
	%>
	<form action="message.jsp" method="post">
	
	<div>
	
	   First Name:<input type="text" name="f_name"/>
	  <br>
	  <br>
	  
	   Last Name:<input type="text" name="l_name"/>
	  <br>
	  <br>
	
	  UserName:<input type="text" name="username"/>
	  <br>
	  <br>
	  Password: <input type="password" name="pass"/>
	  <br>
	  <br>
	  Email: <input type="text" name="email" style="margin-left: 20px"/>
	  <br>
	  <br>
	  <input type="submit" value="Create My Account" title="create account"/>
	  
	  </div>
	
	</form>

</body>


</html>