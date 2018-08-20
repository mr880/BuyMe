<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Item Here</title>
</head>
<body>

<a href ="user.jsp" >
		<img src = "goback.png" style= 'width:50px;height:50px;' >
	</a>

<%

	Account user =(Account)session.getAttribute("user");
%>

<%

	if(request.getParameter("search")!=null){
	
	
		String item_name = request.getParameter("item_name");
		String item_id = request.getParameter("item_id");
		out.println("<h3>Search For Item <br>Item Name: " + item_name + "<br>Item Id: " + item_id);
	}
%>

	
	<div align="center">
		<h2>Search</h2>
		<br>
	
		<form action="searchedItems.jsp" method="post">
		
			Item Name: 
			<input class = "search_fields" type = "text" name="item_name" placeholder = "Item Name">
			Item Type: 
			<select id="itemType" name="item_type">
				<option value="All">All Types</option>
				<option value="Desktop">Desktop</option>
  				<option value="Laptop">Laptop</option>
  				<option value="Tablet">Tablet</option>
			</select>
			 Sort By: 
			<select id="itemType" name="SortBy">
				<option value="currentPrice">Bids</option>
				<option value="itemName">Item Name</option>
  				<option value="itemType">Item Type</option>
			</select>
			  Ascend Or Descend Order:
			<select id="itemType" name="AscendOrDescend">
				<option value="ASC">Ascend</option>
				<option value="DESC">Descend</option>
			</select>
			<br>
			<br>
			<br>
			<br>
			<br>
			Or you can optionally put in the Item ID for a direct Loop Up of the one item
			<br>
			<input class="search_fields" type="text" name="item_id" placeholder="Item ID (optional)">
			<br>
			<br>
			<input type = "submit" value = "Search" name="search">
	
		</form>
		
	</div>

</body>
</html>