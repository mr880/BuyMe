<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	
	
	
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>


	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Message</title>
	</head>
	
	
	<body>
	
		<% 
		
		int result = 0;
		String link_back = "";
			try{
			String f_name = request.getParameter("f_name");
			String l_name = request.getParameter("l_name");
			String u_name = request.getParameter("username");
			String p_name = request.getParameter("pass");
			String email = request.getParameter("email");
			
			String acc =(String) session.getAttribute("class");
			
			if (acc.equals("customer")){
				
				link_back = "<br> <a href =index.jsp> Done </a>";
			}else if (acc.equals("rep")){
				
				link_back = "<br> <a href =AdminStaff.jsp> Done </a>";
			}
			
			
			
			//out.println(link_back + "<br>");
			//out.println(acc);
			
			boolean param_check = f_name.isEmpty() || l_name.isEmpty() || u_name.isEmpty() || p_name.isEmpty() || email.isEmpty();
			
			if (param_check){
				
				out.println("<h1> Every Field Required </h1><br>" + link_back);
				return ;
			}
					
			
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			
			String str = "INSERT INTO account (first,last,username,password,email) VALUES";
			String values =  "(\'" +f_name +"\'"+ "," + "\'"+l_name+"\'" + ",\'" + u_name +"\',\'" + p_name + "\',\'"+email + "\');";
			
			//Run the query against the database.
			
			Statement stmt_2 = con.createStatement();
			String str_2 = "INSERT INTO "+acc+" (first,last,username,password,email) VALUES";
			//out.println(str_2+values);
			
			
			
			try{
				
				
				result = stmt.executeUpdate(str+values);
				stmt_2.executeUpdate(str_2+values);
			}
			 
			 catch(Exception excep){
				 
				out.println("<h1>ALREADY EXISTS</h1><br>" + link_back);
				db.closeConnection(con);
				 return ;
			 }
			
			
			
			String message= "<h1>" + "Your Information below is successfully Stored in our database" + "</h1>" +"<br><br>" + 
					"First Name: " + f_name +"<br>Last Name: " + l_name+"<br>UserName:"+u_name+"<br>Pass: "+p_name + "<br>Email: "+email;
			out.println(message);				
			out.println(link_back);
			db.closeConnection(con);
			
			}catch(Exception e){
				e.printStackTrace();
			
			}
			
			
		
		
		
		
		%>
		
	
		
	</body>
	
	
</html>