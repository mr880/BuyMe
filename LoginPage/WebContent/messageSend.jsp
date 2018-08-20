<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat" %>  
<%@ page import="java.util.Date" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Message Send in Progress</title>
</head>
<body>
<%
	Account user = (Account) session.getAttribute("user");
	String u_name = user.getName();
	session.setAttribute("user",user);
%>
<% 
	try {
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		
	
		//Create a SQL statement
		Statement stmt = con.createStatement();
		//Get the selected radio button from the index.jsp
		String subject = request.getParameter("subjectLine");
		String message = request.getParameter("messageLine");
		
		
		
		boolean param_Check = subject.isEmpty()||message.isEmpty();
		
		if (param_Check){
			out.println("<h1> Subject and Message required </h1><br>" + "<a href = customersMessage.jsp>Go Back</a>");
			return ;
		}
		
		
		//Here i am inserting to tables email and sends
		String strEmail = "INSERT INTO email(`to`, `from`, `date`, `time`, `subject`, `message`) VALUES ";
		SimpleDateFormat sdfr = new SimpleDateFormat("MM/dd/yyyy");
		SimpleDateFormat sdfr2 = new SimpleDateFormat("HH:mm");
	    Date date = new Date();
	    String currentdate = "";
	    String currentTime = "";
	    currentdate = sdfr.format(date);
	    currentTime = sdfr2.format(date);
		String emailCondition = "(" + "\'customerRep@buy.me\', \'"+ user.getEmail()+"\' , \'" + currentdate+"\', \'" + currentTime+"\' , \'" + subject+"\', \'"+ message +"\' )"; 
		System.out.println(strEmail+emailCondition);
		stmt.executeUpdate(strEmail+emailCondition);
		out.println("<h1>Message Sent!</h1><br><a href = user.jsp>Go Back</a>");
		
		db.closeConnection(con);
	} catch (Exception e) {
		out.println("<h2>Message did not send! Either because the database is down or your subject line contains an illegal argument reserved for customer Reps only!</h2><br><br><a href = user.jsp>Go Back</a>");
	}

%>
</body>
</html>