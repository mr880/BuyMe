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
<body>
<%
	Account user = (Account)session.getAttribute("user");
	String u_name = user.getName();
	session.setAttribute("user", user);
%>
	<a href ="user.jsp" >
		<img src = "goback.png" style= 'width:50px;height:50px;' >
	</a>
	<br>
	<br>
	<h2>Searched Questions and Their Corresponding Answers:</h2>
	<br>
<%
ApplicationDB db = new ApplicationDB();	
Connection con = db.getConnection();		
	
//Create a SQL statement
Statement stmt = con.createStatement();
Statement stmt2 = con.createStatement();

String question = request.getParameter("questionSearch");

String sentToRep = "SELECT * FROM email WHERE email.to = 'customerRep@buy.me\' AND (email.subject LIKE '%" +question+"%' OR email.message LIKE '%" + question +"%') ";
System.out.println(sentToRep);
ResultSet result = stmt.executeQuery(sentToRep);
while(result.next()){
	String subject = result.getString("subject");
	int indexOfLast = subject.length();
	subject = subject.substring(15, indexOfLast);
	String msg = result.getString("message");
	String eID = result.getString("eID");
	String email = result.getString("from");
	String sentFromRep = "SELECT * FROM email WHERE email.to =\'"+ email + "\' AND email.from = 'customerRep@buy.me' AND email.subject = \'Reply to: "+ subject+", "+ eID+"\'";
	System.out.println(sentFromRep);
	ResultSet result2 = stmt2.executeQuery(sentFromRep);
	while(result2.next()){
		out.println("<ul><li><b>Question: <br>From: </b>"+ email + "<br><b>Subject:</b> "+ subject+ " <br><b>Message:</b> " + msg +"<ul><li><b>Answer: <br>Subject From Rep:</b> "+ result2.getString("subject")+ " <br><b>Message From Rep:</b> "+ result2.getString("message") +"</li></ul></li></ul>");
	}
	
}
db.closeConnection(con);
%>
</body>
</html>