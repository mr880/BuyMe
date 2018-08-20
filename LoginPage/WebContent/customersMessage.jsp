<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Message System</title>
</head>
<body>
<%
	Account user = (Account) session.getAttribute("user");
	String u_name = user.getName();
	session.setAttribute("user",user);
%>
	<div>
	 				<!-- ! -->
					<form method="post" action="messageSend.jsp" >
		   
					 	 <p class="txt">Subject:<br>  <input type="text" name="subjectLine"  placeholder="Subject goes here"/></p> 
					 	 <br>
					  	<p class="txt">Message:<br> <input type="text" name="messageLine" placeholder="Message goes here"/></p> 
					 	 <br>
					  
					  	<input type="submit" value="Send Message"/>
					  	
					</form>
	</div>
</body>
</html>