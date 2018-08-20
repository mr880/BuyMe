<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Sales Report</title>
	</head>
	<style>
			
			
	</style>
	<body>
		<font size="+3" face = "Baskerville" color="scarlet"><br>Customer Rep Hub</font>
		<font face = "Baskerville">
		<div>
			<h4>Total Earnings:</h4>
			<%
				//total earnings
				try{
					
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();	
					Statement stmt = con.createStatement();
					
					String totalEarning = "SELECT SUM(currentPrice) AS Total_Earning FROM auction WHERE active = false";
					ResultSet result = stmt.executeQuery(totalEarning);
					
					if(result.next()){
						double x = result.getDouble("Total_Earning");
						out.println("$" + x);
					}
					
					db.closeConnection(con);
				}catch(Exception e){
					out.println(e.fillInStackTrace());
				}
				
			%>
		</div>
	
		<div>
			<h4>Items By: </h4>
			<form action="salesReport.jsp" method="get">
				<select name="here">
				  <option value="itemName">Item</option>
				  <option value="itemType">Item Type</option>
				  <option value="endUser">End User</option>
				</select>
				<input type="submit" value="Filter" name="submitFilter"/>
			</form>
			<%
				if (request.getParameter("submitFilter") != null){
					
					try{
						ApplicationDB db = new ApplicationDB();	
						Connection con = db.getConnection();	
						Statement stmt = con.createStatement();
						
						String select = request.getParameter("here");
						
						String query; 
						
						if(select.equals("endUser")){
							query = "SELECT email, SUM(A.currentPrice) AS Earnings_Per FROM auction A WHERE A.active = false GROUP BY email;";
							ResultSet result = stmt.executeQuery(query);
							
							while(result.next()){
								out.println(result.getString("email") + "===>");
								out.println(result.getString("Earnings_Per") + "<br>");
								
							}
						}
						else if(select.equals("itemType")){
							query = "SELECT itemType, SUM(A.currentPrice) AS Earnings_Per FROM auction A, item I WHERE A.active = false AND I.itemID = A.itemID GROUP BY itemType;";
							ResultSet result = stmt.executeQuery(query);
							
							while(result.next()){
								out.println(result.getString("itemType") + "===>");
								out.println(result.getString("Earnings_Per") + "<br>");
							}
						}
						else if(select.equals("itemName")){
							query = "SELECT itemName, SUM(currentPrice) AS Earnings_Per FROM auction A, item I WHERE I.itemID = A.itemID AND active = false GROUP BY itemName;"; 
							ResultSet result = stmt.executeQuery(query);
							
							while(result.next()){
								out.println(result.getString("itemName") + "===>");
								out.println(result.getString("Earnings_Per") + "<br>");
							}
						}
						else{
							System.out.println("error IS HERE");
						}
						
						
						
						db.closeConnection(con);
					}catch(Exception e){
						out.println(e.fillInStackTrace());
					}
				
				}
			%>
		</div>
		<br>
		<div>
			<h4>Best Selling Item:</h4>
			<%
				try{
					
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();	
					Statement stmt = con.createStatement();
					
					String totalEarning = "Select I.itemName , count(I.itemName) as temp FROM auction A , item I WHERE A.itemID = I.itemID AND active = false GROUP BY I.itemName ORDER BY temp DESC;";
					ResultSet result = stmt.executeQuery(totalEarning);
					
					if(result.next()){
						String shit = result.getString("itemName") + " ===> ";
						int num = result.getInt("temp");
						out.println(shit + num);
					}
					
					db.closeConnection(con);
				}catch(Exception e){
					out.println(e.fillInStackTrace());
				}
			%>
			<br>
			<h4>Best Buyer:</h4>
			<%
				try{
					
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();	
					Statement stmt = con.createStatement();
					
					String totalEarning = "SELECT AH.email , count(AH.email) AS BEST_BUYER FROM auction_history AH INNER JOIN auction A ON A.auctionID = AH.auctionID WHERE A.active = false AND AH.bidID = (SELECT  max(AH3.bidID) FROM auction_history AH3 WHERE AH3.auctionID = AH.auctionID) GROUP BY AH.email ORDER BY AH.email DESC;";
					ResultSet resultNew = stmt.executeQuery(totalEarning);
					
					if(resultNew.next()){
						String shit = resultNew.getString("AH.email") + " ===> ";
						int num = resultNew.getInt("BEST_BUYER");
						out.println(shit + num);
					}
					
					db.closeConnection(con);
				}catch(Exception e){
					out.println(e.fillInStackTrace());
				}
			%>
			
		</div>
		</font>
	</body>
</html>