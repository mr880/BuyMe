<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Insert title here</title>
</head>

<%

	out.println("<h1>REDIRECTING...</h1>");
	
	try {
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		
	
		//Create a SQL statement
		Statement stmt = con.createStatement();
		//Get the selected radio button from the index.jsp
		String u_name = request.getParameter("username");
		String pass= request.getParameter("pass");
		
		
		
		boolean param_Check = u_name.isEmpty()||pass.isEmpty();
		
		if (param_Check){
			
			out.println("<h1> UserName and Password Field Required </h1><br>" + "<a href = index.jsp>Go Back</a>");
			return ;
		}
		
		
	
		String str = "SELECT * FROM customer WHERE";
		String condition = " username =\'" +u_name+"\' AND password = \'" + pass+"\'"; 
		ResultSet result = stmt.executeQuery(str+condition);
		
		
		String str_admin = "SELECT * FROM admin WHERE";
		String condition_admin = " username =\'" +u_name+"\' AND password = \'" + pass+"\'"; 
		Statement stmt_2 = con.createStatement();
		ResultSet result_admin = stmt_2.executeQuery(str_admin+condition_admin);
		
		String str_rep = "SELECT * FROM rep WHERE";
		String condition_rep = " username =\'" +u_name+"\' AND password = \'" + pass+"\'"; 
		Statement stmt_3 = con.createStatement();
		ResultSet result_rep = stmt_3.executeQuery(str_rep+condition_rep);
		
		
		
		
		
		
		if (result.next()){
			
			String f_name = result.getString("first");
			String l_name = result.getString("last");
			String email = result.getString("email");
			out.println("<h1> Welcome User, "+ f_name+" "+" "+l_name +"<br>" + email);
			
			session.setAttribute("user", new Account(f_name,l_name,u_name,pass,email));
			response.sendRedirect("user.jsp");
			
			return;
			
		}
		
		
		else if(result_admin.next()){
			

			String f_name = result_admin.getString("first");
			String l_name = result_admin.getString("last");
			String email = result_admin.getString("email");
			out.println("<h1> Welcome User, "+ f_name+" "+" "+l_name +"<br>" + email);
			
			session.setAttribute("user", new Account(f_name,l_name,u_name,pass,email));
			response.sendRedirect("AdminStaff.jsp");
			
			
		}else if(result_rep.next()){
			String f_name = result_rep.getString("first");
			String l_name = result_rep.getString("last");
			String email = result_rep.getString("email");
			out.println("<h1> Welcome User, "+ f_name+" "+" "+l_name +"<br>" + email);
			
			session.setAttribute("user", new Account(f_name,l_name,u_name,pass,email));
			response.sendRedirect("CustomerRep.jsp");
			
		}
		
		
		
		else{
			
			out.println("<h1>Incorrect Credentials</h1><br><a href = index.jsp>Go Back</a>");
			
		}
		
		
		
		
		
		db.closeConnection(con);
	} catch (Exception e) {
		out.println(e.fillInStackTrace());
	}
	

%>


<body>

</body>
</html>