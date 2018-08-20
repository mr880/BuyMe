<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>customer support page</title>
</head>
<body>

<%
	Account user = (Account) session.getAttribute("user");
	String u_name = user.getName();
	session.setAttribute("user",user);
%>
<h1>Need Help? Send a Message!</h1>

<form method="post" action="customersMessage.jsp" >
<button>Send Message to a Customer Rep</button>					  	
</form>

<h2>Questions that were answered by a Rep:</h2>
<%
ApplicationDB db = new ApplicationDB();	
Connection con = db.getConnection();		
	
//Create a SQL statement
Statement stmt = con.createStatement();
Statement stmt2 = con.createStatement();

String sentToRep = "SELECT * FROM email WHERE email.to = 'customerRep@buy.me' AND email.from = \'" + user.getEmail()+"'";
System.out.println(sentToRep);
ResultSet result = stmt.executeQuery(sentToRep);
while(result.next()){
	String subject = result.getString("subject");
	int indexOfLast = subject.length();
	subject = subject.substring(15, indexOfLast);
	String msg = result.getString("message");
	String eID = result.getString("eID");
	String sentFromRep = "SELECT * FROM email WHERE email.to =\'"+ user.getEmail() + "\' AND email.from = 'customerRep@buy.me' AND email.subject = \'Reply to: "+ subject+", "+ eID+"\'";
	System.out.println(sentFromRep);
	ResultSet result2 = stmt2.executeQuery(sentFromRep);
	while(result2.next()){
		out.println("<ul><li><b>Subject:</b> "+ subject+ " <br><b>Message:</b> " + msg +"<ul><li><b>Subject From Rep:</b> "+ result2.getString("subject")+ " <br><b>Message From Rep:</b> "+ result2.getString("message") +"</li></ul></li></ul>");
	}
	
}
db.closeConnection(con);
%>
</body>
</html>