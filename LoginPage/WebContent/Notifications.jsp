<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<style>
		table, th, td {
    		border: 1px solid black;
    		
		}
	</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Notifications</title>
</head>
<body>

	
	<a href ="user.jsp" >
		<img src = "goback.png" style= 'width:50px;height:50px;' >
	</a>
	<%
	
	Account user = (Account)session.getAttribute("user");
	String u_name = user.getName();
	session.setAttribute("user", user);
	
	%>



	<h3>NOTIFCATIONS FOR ==> <strong><%= u_name %></strong></h3>
	<img src = "notification.png" alt = "Picture Not Available">
	<br>
	<table>
	
	<tr>
    <th>Date</th>
    <th>Time</th> 
    <th>Subject</th>
    <th>Message</th>
    
  </tr>
	<%
	
	String Query = "SELECT * from email WHERE `from` = 'farasxarafat@hotmail.com' AND `to` = \'" + user.getEmail()+"\' ORDER BY `date` DESC";
	System.out.println(Query);
	
	
	
	out.println(Operations.executeNotificationQuery(Query));
			
	
	
	%>
	</table>
	
	
	
	
</body>
</html>