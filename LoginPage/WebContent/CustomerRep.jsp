<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Customer Representative Page</title>

	</head>
	
	<BODY bgcolor="white">
  		<font size="+3" face = "Baskerville" color="scarlet"><br>Customer Rep Hub</font>
		<font face = "Baskerville">
		<h4>Change Account Info</h4>
		<style>
		.button {
		    background-color: black; 
		    border: none;
		    color: white;
		    padding: 15px 32px;
		    text-align: center;
		    text-decoration: none;
		    display: inline-block;
		    font-size: 16px;
		}
		</style>
		<form action="CustomerRep.jsp" method="post">
		
			<TABLE style="background-color: #ECE5B6;" WIDTH="30%" >
				 <i>All fields left blank will not be updated</i>
				 <br />
				 User Current Email<font color="red">*</font>: <input type = "text" name = "userEmail">
		         <br />
		         Change Current Email: <input type = "text" name = "newEmail">
		         <br />
		         Change First Name: <input type = "text" name = "first" />
		         <br />
		         Change Last Name: <input type = "text" name = "last" />
		         <br />
		         New Username: <input type = "text" name = "newu">
		         <br />
		         New Password: <input type = "text" name = "newp" />
		         <br />
		         Confirm Password: <input type = "text" name = "confp" />
		         <br />
		         <font color="red">*</font> = require field
	        </TABLE>
	         <input type="submit" value="Update Info" title="Update" name="submit">
      	 </form>
      	   <%
		        	if (request.getParameter("submit") != null){
		        		
		        	
		        		try{
		        			
		        			//Get the database connection
	            			ApplicationDB db = new ApplicationDB();	
	            			Connection con = db.getConnection();	
	            			
	            		
	            			//Create a SQL statement
	            			Statement stmt = con.createStatement();
	            			String currEmail = request.getParameter("userEmail");
	            			
	            			if(currEmail.isEmpty()){
	            				out.println("<p><font color = \"red\">User Email is Required</font> </p>");
	            				
	            			}
	            			else{
	            				
		            			String searchStr = "SELECT * FROM account WHERE email = \"" + currEmail+ "\"";
		            			//out.println("<h3> SEARCH: " + searchStr + "</h3>");
		            			ResultSet result = stmt.executeQuery(searchStr);
		            			
		            			String changeEmail, first, last, newUName, newPass, confirmPass;
		            			if(result.next()){
			            		
					        		if(!request.getParameter("newEmail").isEmpty()){
					        			changeEmail = request.getParameter("newEmail");
					        		}else{
					        			changeEmail = result.getString("email");
					        		}
					        		 
					        	    if(!request.getParameter("first").isEmpty()){
					        			first = request.getParameter("first");
					        		}else{
					        			first = result.getString("first");
					        		}
					        		if(!request.getParameter("last").isEmpty()){
					        			last = request.getParameter("last");
					        		}else{
					        			last = result.getString("last");
					        		}
					        		if(!request.getParameter("newu").isEmpty()){
					        			newUName = request.getParameter("newu");
					        		}else{
					        			newUName = result.getString("username");
					        		}
					        		if(!request.getParameter("newp").isEmpty() && !request.getParameter("confp").isEmpty()){
					        			newPass = request.getParameter("newp");
					        			confirmPass = request.getParameter("confp");
					        			
					        			if(newPass == confirmPass){
					        				//
					        			}
					        			else
					        				out.println("<h3> Passwords do not match! </h3>");
					        		
					        		}else{
					        			newPass = result.getString("password");
					        			
					        		} 
					        		db.closeConnection(con); 
			            			
			            			String update = "UPDATE account SET email = \""+ changeEmail + "\", first = \""+ first +"\", last = \""+ last+ "\", username = \""+ newUName+"\", password = \""+ newPass+"\" WHERE email = \"" + currEmail +"\"";
			            			String update2 = "UPDATE customer SET email = \""+ changeEmail + "\", first = \""+ first +"\", last = \""+ last+ "\", username = \""+ newUName+"\", password = \""+ newPass+"\" WHERE email = \"" + currEmail +"\"";
			            			System.out.println(update);
			            			
			            			ApplicationDB db2 = new ApplicationDB();	
			            			Connection con2 = db.getConnection();	
			            			
			            		
			            			//Create a SQL statement
			            		
			            			stmt = con2.createStatement();
			            			stmt.executeUpdate(update);
			            			stmt.executeUpdate(update2);
			            		
			            			db2.closeConnection(con2);
			            			
		            			}
	            			}
		        			
		        		}catch(Exception e){
		        			
		        			out.println("Error: " + e.fillInStackTrace());
		        		}
		        	}
	    		
	        %>
      	 <h4>Remove Auction</h4>
		 <form action = "CustomerRep.jsp" method = "GET">
		   	 Auction ID: <input type = "text" name = "AuctionID">
	         <br />
	         <input type = "submit" value = "Submit" name = "submitAuction"/>
      	 
      	 	<%
		  		if (request.getParameter("submitAuction") != null){
		  			try{
			  			//Get the database connection
	            			ApplicationDB db = new ApplicationDB();	
	            			Connection con = db.getConnection();	
	            			Statement stmt = con.createStatement();
	            			
		  				String id = request.getParameter("AuctionID");
		  				int newId = Integer.parseInt(id);
		  				System.out.println(newId);
		  				String delete = "DELETE FROM auction WHERE auctionID = " + id;
		  				
		  				int x = stmt.executeUpdate(delete);
		  				System.out.println(delete);
		  	            if (x > 0)            
		  	                System.out.println("One Auction Successfully Deleted");            
		  	            
		  	                //System.out.println("ERROR OCCURED :("); 
		  	            
		  				db.closeConnection(con);
		  				
		  			}catch(Exception e){
		  				out.println("<p> Auction Deletion Error</p>");
		  			}
		  		}
		    %>
		    
		  </form>
      	 <h4>Remove Bid</h4>
		 <form action = "CustomerRep.jsp" method = "GET">
		   	 Bid ID: <input type = "text" name = "BidID">
	         <br />
	         <input type = "submit" value = "Submit" name= "submitHere" />
	          <%
		  		if (request.getParameter("submitHere") != null){
		  			try{
			  			//Get the database connection
	            			ApplicationDB db = new ApplicationDB();	
	            			Connection con = db.getConnection();
	            			Connection con2 = db.getConnection();
	            			Connection con3 = db.getConnection();
	            		
	            	
	            			Statement stmt = con.createStatement();
	            			
		  				String id = request.getParameter("BidID");
		  				
		  				String bidQuery = "SELECT MAX(H3.price) AS max FROM auction_history H3 WHERE H3.bidID = (SELECT MAX(H.bidID) FROM auction_history H WHERE H.auctionID = (SELECT H2.auctionID FROM auction_history H2 WHERE H2.bidID =" + id + "))";
		  				
		  				ResultSet res = stmt.executeQuery(bidQuery);
		  				int high = 0;
		  				
		  				if(res.next()){
		  					high = res.getInt("max");
		  					System.out.println("High: " + high);
		  				}
		  				
		  	
		  				
		  				
		  				Statement stmt7 = con2.createStatement();
		  				
		  				String priceQuery = "SELECT price As play FROM auction_history WHERE bidID = " + id;
		  				
		  				ResultSet res7 = stmt7.executeQuery(priceQuery);
		  				
		  				int bid = 0;
		  				
		  				if(res7.next()){
		  					bid = res7.getInt("play");
		  					System.out.println("Price: " + bid);
		  				}
		  				
		  			
		  				
		  				if(bid != 0 && high != 0){
		  					if(bid == high){
		  						System.out.println("MATCH!");
		  						String getCurrentPrice = "SELECT A.currentPrice, A.auctionID From auction A INNER JOIN auction_history AH ON A.auctionID = AH.auctionID WHERE AH.bidID = " + id + ";";
		  						
		  						Statement newStmt = con3.createStatement();
		  						ResultSet result = newStmt.executeQuery(getCurrentPrice);
		  						
		  						if(result.next()){
		  							double d = result.getDouble("currentPrice");
		  							double solution = d - bid;
		  							int ac = result.getInt("auctionID");
		  							String finalUpdateBruh = "UPDATE auction SET currentPrice = " + solution + " WHERE auctionID = " + ac + ";";
		  							System.out.println(finalUpdateBruh);
		  							Operations.Insert(finalUpdateBruh);
		  							
		  							String delete = "DELETE FROM auction_history WHERE bidID = " + id;
		  							
		  							
		  						}
		  					}
		  					String delete = "DELETE FROM auction_history WHERE bidID = " + id;
		  					Operations.Insert(delete);
		  				}
		  				
		  			
		  	          	db.closeConnection(con);
		  				
		  				
		  			}catch(Exception e){
		  				out.println(e.fillInStackTrace());
		  			}
		  		}
		    %>
      	 </form>
      	
		    <br>
      		<form  action="customerInquiry.jsp">
      		<input class="button" type = "submit" value = "Customer Inquiry Page" name= "submit" />
      		</form> 
      		<br>
      		<form  action="salesReport.jsp">
      		<input class="button" type = "submit" value = "Sales Report" name= "submitSales" />
      		</form><br><br>
      		<a href= "index.jsp">Logout</a>
        		
       </font>
    	</body>
</html>