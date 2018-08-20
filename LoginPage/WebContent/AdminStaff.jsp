<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	    pageEncoding="ISO-8859-1"  import = "cs336.pkg.*"%>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
	
	
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>


	.forms{
	
		margin-left: 2in;
		
	}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Welcome Admin</title>
</head>
<body>




	
	<%
		Account user = (Account)session.getAttribute("user");
		String u_name = user.getName();
		
		session.setAttribute("class", "rep");
		
	%>
	
	
	<h1>Welcome Administrator:  <%= user.getName()%></h1>
	
	 <%
	 /**for Admin Password changes EVENT HANDLER**/
	 
	 String p_name = "";
	
		if (request.getParameter("AA")!=null){
			
			 p_name = request.getParameter("pass_in");
			
			
			boolean param_check =  p_name.equals(user.getPass());
				
					
			
			if (param_check){//password is the same
				
				out.println("<h1>Pasword Is the Same</h1>");
			
			}
			else{
				
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
				
				String str = "UPDATE admin A set A.password = \'" + p_name + "\' WHERE  A.email = \'" + user.getEmail() +"\';" ;
				
				//out.println(str);
				
				
				try{
					
					
					int result = stmt.executeUpdate(str);
					if(result >= 1){
						
						out.println("<h1>Password Changed Sucessfully to --->" + p_name + "</h1>");
						user.setPass(p_name);
					}else{
						
						 out.println("<br><h1 style = 'color:RED;'>SOMETHING WENT WRONG. PLEASE TRY AGAIN LATER</h1><br>");
					}
				}
				 
				 catch(SQLException excep){
					 
					 out.println("<br><h1 style = 'color:RED;'>SOMETHING WENT WRONG. PLEASE TRY AGAIN LATER</h1><br>");
					 return ;
				 }
				
				
				//out.println("<h1>something changes</h1>");
			}
		}
	
	%>
	
	
	<input type="button" value="Account Setting" onClick="showSetting()">
	
		<div hidden id="settings" class="forms">
	
			<form action="AdminStaff.jsp" method="POST">
			<h3> Change My Account Setting</h3>
			<h4 style="color: red;">!!!YOU CAN ONLY CHANGE YOUR PASSWORD!!!</h4>
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
	
	<input type="button" value="New Representative" onClick = "Addrep()">
	
		<div hidden id="rep" class="forms">
		
			<form action="message.jsp" method="post">
			
			<h3> Add New Representative</h3>
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
			  <input type="submit"  value="Add Representative" title="Add Rep"/>
			  
			 </div>
			
		</form>
			
			
		</div>
	
	<br>
	<br>
	<input type="button" value="Generate Sales Report">
	
	<div>
		
			<br><br>
			<a href="index.jsp">Logout</a>
			
		
		</div>
	
	
	<script>
	
	
	function showSetting() {
	   var x = document.getElementById("settings");
	   if (x.style.display == "block") {
	       x.style.display = "none";
	   } else {
	       x.style.display = "block";
   		}
	}
	
	function Addrep() {
		   var x = document.getElementById("rep");
		   if (x.style.display == "block") {
		       x.style.display = "none";
		   } else {
		       x.style.display = "block";
	   		}
		   
		 
		}
	

	</script>
	
	
</body>
</html>