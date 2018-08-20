<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	    pageEncoding="ISO-8859-1"%>
	<%@ page import="java.io.*,java.util.*,java.sql.*,cs336.pkg.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
	
	
    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Password Retrieval</title>
	
</head>

<body>

	<h1> Please Enter your email to retrieve your password</h1>
	<form action = "forgotPass.jsp" method="post">

		<div>
		
			Email: <input type = "email"  name="email" placeholder="jon.doe@hotmail.com">
			<br>
			<input type="submit" value="submit" name="submit">
		
			
		</div>

	</form>
	
	<%
	
	String link_back = "<br> <a href =index.jsp> Go Back </a>";
	
	if (request.getParameter("email")!=null){
		
		String email = request.getParameter("email");
		
		if (email.equals("")){
			
			out.println("<br>NO INPUT DETECTED</br>");
			return ;
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
			
			String str = "SELECT * FROM account A WHERE A.email = \'" + email +  "\';" ;
			
			//out.println(str);
			
			
			try{
				
				
				ResultSet result = stmt.executeQuery(str);
				if(result.next()== false){
					
					out.println("<h1>Could not find you in our database. Please Enter the correct email</h1>");
					out.println(link_back);
				}else{
					

					out.println("<br> <h3 style = 'color: GREEN;'>LOOK UP SUCCESSFULE</h3> <h3>YOUR PASSWORD: </h3>"+ result.getString("password"));
					
				}
			}
			 
			 catch(SQLException excep){
				 
				 out.println("<br><h1 style = 'color:RED;'>SOMETHING WENT WRONG. PLEASE TRY AGAIN LATER</h1><br>");
				 out.println(link_back);
				 return ;
			 }
		}
	}
	
	%>

</body>
</html>