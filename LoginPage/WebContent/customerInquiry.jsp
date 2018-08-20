<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Customer Inquiry</title>
	</head>
	<body>
		<font face = "Baskerville">
		<font size="+3" face = "Baskerville" color="scarlet"><br>Message Hub</font>
		<br><br>
		<style>
			h1 {
				
			    position: relative;
			    left: 175px;
			  
			}
			ul {
				 width: 400px;
				  list-style:none;
				  margin: 0;
   				 padding: 10px;
				 border-bottom: 2px solid #ddd;
				  
				 
			}
		</style>
		<% 
			Account user_account = (Account)session.getAttribute("user");
			String u_email = user_account.getEmail();

        			try {
        				
        				boolean isRep = false;
        				
            			//Get the database connection
            			ApplicationDB db = new ApplicationDB();	
            			Connection con = db.getConnection();	
            			
            			ApplicationDB db4 = new ApplicationDB();
            			Connection con4 = db4.getConnection();
            			
            			Statement stmt4 = con4.createStatement();
            			String rep = "SELECT * FROM rep";
            			
            			ResultSet res4 = stmt4.executeQuery(rep);
            			
            			//Create a SQL statement
            			Statement stmt = con.createStatement();
            			String str = "SELECT * FROM email WHERE email.from <> \'farasxarafat@hotmail.com\';";
            			ResultSet result = stmt.executeQuery(str);
            			
            			
            			
            			while(res4.next()){
            				
            				String email = res4.getString("email");
            				
            				if(email.equals(u_email)){
            					isRep = true;
            				}
            			}
        			
         			while(result.next()){
         				boolean isAdmin = false;
         				String to_String = result.getString("to");
         				int eID = result.getInt("eID");
         				String user = result.getString("from");
         				String subject = result.getString("subject");
         				
         				boolean reply = false; 
         				boolean repliedTo = false;
         				
         				if(subject.startsWith("Reply to: ")){
         					reply = true;
         				}
         				
         				if(subject.startsWith("(Replied To) - ")){
         					repliedTo = true;
         				}
         				
         				if(user.compareToIgnoreCase("farasxarafat@hotmail.com") == 0){
         					isAdmin = true;
         					System.out.println(isAdmin);
         				}
         				String textId = "textInput" + eID;
         				if(isRep && !reply && !repliedTo && isAdmin != true){
         					
         					out.println("<ul>");
         					out.println("<li><p>"+ "User: " + result.getString("from") + "<br> <p>Subject: " + result.getString("subject") + "</p> <p> Message: " +result.getString("message") + "</p>"  + "</p></li>");
         				
         					out.println("<form action=\"customerInquiry.jsp\" method=\"post\"><textarea name = \"textInput" + eID + "\" rows=\"6\" cols=\"50\"></textarea><br><input type = \"submit\" value = \"Send Response\" name= \"submit\" /></form>");
         					String textInput = request.getParameter(textId); 
         					
         					//Insert new email
         					String insert = "INSERT INTO email ";
         					SimpleDateFormat sdfr = new SimpleDateFormat("MM/dd/yyyy");
         					SimpleDateFormat sdfr2 = new SimpleDateFormat("HH:mm");
         					Date date = new Date();
         					String currentdate = "";
         					String currentTime = "";
         					currentdate = sdfr.format(date);
         					currentTime = sdfr2.format(date);
         					String insert2 = "(`to`, `from`, `date`, `time`, `subject`, `message`)";
         					String insert3 = " VALUES (\'" + user + "\', \'customerRep@buy.me\', \'" + currentdate + "\', \'" + currentTime + "\', \'Reply to: "+ subject + ", "+ eID +"\', \'" + textInput + "\')"; 
         					String insertFinal = insert + insert2 + insert3; 
         					
         					//Update customer email replied to
         					String update = "UPDATE email SET subject = \"(Replied To) - "+ subject +"\" WHERE eID = " + eID;
         					System.out.println("YESTERDAY: " + update);
         					
         					if(textInput != null){
         						//System.out.println(insertFinal);
         						Statement stmt2 = con.createStatement();
         						
         						int x = stmt2.executeUpdate(insertFinal);
         						
         						Statement stmt3 = con.createStatement();
         						
         						int y = stmt3.executeUpdate(update);
         						
         						response.sendRedirect("customerInquiry.jsp");
         						
         						
         					}
         					
         					
         				
         					//out.println("<input type = \"submit\" value = \"Close Request\" name= \"submit\" />");
							out.println("</ul>");
				
						}
         				else{
         					out.println("<ul>");
         					out.println("<li><p>"+ "User: " + result.getString("from") + "<br> <p>Subject: " + result.getString("subject") + "</p> <p> Message: " +result.getString("message") + "</p>"  + "</p></li>");
         					out.println("</ul>");
         				}
         					
         			}
         			
         			db.closeConnection(con);
         			
        			}catch(Exception e) {
        				out.println(e.fillInStackTrace());
        			}
        	%>
        	</font>
	</body>
</html>