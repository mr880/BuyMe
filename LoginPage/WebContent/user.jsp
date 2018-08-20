<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*" import ="java.sql.SQLException" import = "java.sql.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<style>
	body {
  		margin: 0;
  		font-family: Arial, Helvetica, sans-serif;
	}

.topnav {
  overflow: hidden;
  background-color: #333;
}

.topnav a {
  float: left;
  color: #f2f2f2;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 17px;
}

.topnav a:hover {
  background-color: #ddd;
  color: black;
}

.topnav a.active {
  background-color: #4CAF50;
  color: white;
}
</style>	
</head>
<body>

	<%
	Account user = (Account)session.getAttribute("user");
	String u_name = user.getName();
	session.setAttribute("user", user);
	%>
	
	
		<%
		
		 
		 /**for Customer Password changes EVENT HANDLER**/
		 
		 String p_name = "";
		
			if (request.getParameter("AA")!=null){
				
				 p_name = request.getParameter("pass_in");
				
				
				boolean param_check =  p_name.equals(user.getPass());
					
						
				
				if (param_check){//password is the same
					
					out.println("<h1>Pasword Is the Same</h1>");
					
				}else{
					
					/**we update the information for the admin **/
					

					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();		

					//Create a SQL statement
					Statement stmt = con.createStatement();
					//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
					
					/**
					UPDATE admin A
					set A.first = 'Faris'
					WHERE A.email = 'farasxarafat@hotmail.com';
					
					**/
					
					String str = "UPDATE customer A set A.password = \'" + p_name + "\' WHERE  A.email = \'" + user.getEmail() +"\';" ;
					
					//out.println(str);
					
					
					try{
						
						
						int result = stmt.executeUpdate(str);
						if(result >= 1){
							
							out.println("<h1>Password Changed Sucessfully to --->" + p_name + "</h1>");
							
						}else{
							
							 out.println("<br><h1 style = 'color:RED;'>SOMETHING WENT WRONG. PLEASE TRY AGAIN LATER</h1><br>");
						}
					}
					 
					 catch(SQLException excep){
						 
						 out.println("<br><h1 style = 'color:RED;'>SOMETHING WENT WRONG. PLEASE TRY AGAIN LATER</h1><br>");
						 
					 }
					
					
					//out.println("<h1>something changes</h1>");
				}
			}
			
			else if (request.getParameter("delete")!=null){
				
				out.println("<h2>Are You sure you wanto to delete the account?</h2>");
				
				out.println(  "<form action = \'user.jsp\' method=\'post\'><input type=\'submit\' name=\'yes\' value=\'yes\' title=\'yes\'/>");
				out.println( "<input type=\'submit\' name=\'No\' value=\'No\' title=\'No\'/></form>");
				
			}
			
			/*else if(request.getParameter("search")!=null){
				
				
				String item_name = request.getParameter("item_name");
				String item_id = request.getParameter("item_id");
				out.println("<h3>Search For Item <br>Item Name: " + item_name + "<br>Item Id: " + item_id);
			}*/
			
			else if(request.getParameter("yes")!=null){
				
				Operations op = new Operations();
				if(op.Delete("customer", user)){
					
					response.sendRedirect("index.jsp");
					return;
				}
				
				out.println("<h1>Problem Deleting an account. Please Try Again Later</h1>");
			
			}
				
			
			
			
		
		%>

	<div class="topnav">
  		<a class="active" href="user.jsp">Home</a>
  		<a href="Search.jsp">Search</a>
  		<a href="customerSupport.jsp">Customer Support</a>
  		<a href="Sell_Item.jsp">Sell Item</a>
  		<a href="messageBoard.jsp">Message Board</a>
  		<a href="Notifications.jsp">Notifications</a>
	</div>
	<br><br>
	
	
	
	<div style="padding-left:16px">
  		<p>Welcome <%= user.getName() %></p>
	</div>
	
	<br><br>
	
	
	
	<!--  <div align="center">
	
	
		<form action="user.jsp" method="post">
		
		
			<input type = "submit" value = "search" name="search">
			<input class = "search_fields" type = "text" name="item_name" placeholder = "Item Name">
			<input class="search_fields" type="text" name="item_id" placeholder="Item ID (optional)">
	
		</form>
		
	</div>
	
	-->
	<%
	
		if (request.getParameter("submit_alert")!= null){
			
			String item_type  = request.getParameter("item_type");
			String item_name =  request.getParameter("item_name");
			
			
			if (!item_name.isEmpty()){
				
				String Query = "INSERT INTO wish_list (email, itemName, item_type) VALUES (\'" +user.getEmail() +"\',\'"+item_name + "\',\'" + item_type + "\');"; 
				try{
					
				   if(!Operations.Insert(Query)){throw new Exception();}
					out.println("<strong style='color:Green;'>Item Added to your Wish List </strong>");

				} 
				catch(Exception e){
					
					out.println("<strong style='color:RED'> You have already have Alert set for the item</strong>");

				}
			}else{
				
				out.println("<strong style='color:RED'> Must Provide Item Name</strong>");
			}
		}
	%>
	
	<form action ="user.jsp" method="post">
	
			<input type="button" value="Set Alert" onClick = "showAlert()" >
	
			<div id = "Alert" hidden>
			<br>
			Item type: 
			<select id="itemType" name="item_type">
				
				<option value="Desktop">Desktop</option>
  				<option value="Laptop">Laptop</option>
  				<option value="Tablet">Tablet</option>
			</select>
			
			<br><br>
			Item Name: <input type = "text" name="item_name" placeholder="Dell Y50"><br><br>
			
			<input type="submit" value = "submit" name="submit_alert">
			
			
			</div>
			
	</form>
	
	<br><br>
	

	
	
	<input type="button" value="Account Setting" onClick="showSetting()" align="right">
	
			<div hidden id="settings" class="forms">
	
			<form action = "user.jsp" action= "POST">
			<h3> Change My Account Setting</h3>
			<h4 style="color: red;">!!!YOU CAN ONLY CHANGE YOUR PASSWORD. IF YOU WISH TO CHANGE YOUR OTHER INFORMATION PLEASE CONTANCT CUSTOMER RESPRESENTATIVE!!!</h4>
		<div>
	
	   First Name:<input type="text" name="f_name_in" disabled value='<%=user.getFirst()%>'/>
	  <br>
	  <br>
	  
	   Last Name:<input type="text" name="l_name_in" disabled value = '<%=user.getLast()%>'/>
	  <br>
	  <br>
	
	  UserName:<input type="text" name="username_in" disabled value =  '<%=user.getUsername()%>'/>
	  <br>
	  <br>
	  Password: <input type="password" name="pass_in" value = '<%= user.getPass() %>'/>
	  <br>
	  <br>
	  Email: <input type="text" name="email_in" disabled value= '<%=user.getEmail() %>' style="margin-left: 20px;width: 200pt;"/>
	  <br>
	  <br>
	  <input type="submit" name="AA" value="Submit Changes" title="Submit Changes"/>
	  
	  
	  
	  </div>
	  
	 
	 
	
	</form>

	
		</div>
		
		
	<br>
	<br>
	
	
	<form action="user.jsp" method="post">	
		<input type = "submit" value="Delete Account" name="delete" style="color: red;">
	</form>
	
		<div>
			<br><br>
			
			<a href ="index.jsp"  >
		<img src = "logout.jpg"  style= 'width:125px;height:125px;' >
		</a>
		</div>
		<!--  <img  height = '150px' width = '150px' src = 'http://www.reactiongifs.com/r/2013/04/celebrate.gif'>
		<img  height = '150px' width = '150px' src = 'http://www.reactiongifs.com/r/gj1.gif'>
		<img  height = '150px' width = '150px' src = 'http://i.imgur.com/DjPMzlU.gif'><br>
		-->
		
			
		
		
	
	
	<script>
	
	function showAlert() {
		   var x = document.getElementById("Alert");
		   if (x.style.display == "block") {
		       x.style.display = "none";
		   } else {
		       x.style.display = "block";
	   		}
		}
	
	
	function showSetting() {
	   var x = document.getElementById("settings");
	   if (x.style.display == "block") {
	       x.style.display = "none";
	   } else {
	       x.style.display = "block";
   		}
	}
	
	</script>
	
	
</body>
</html>