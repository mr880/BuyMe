<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*" import="cs336.pkg.Item" import="java.util.Date" import = "java.util.Calendar" import ="java.text.ParseException"
import ="java.text.SimpleDateFormat"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<style>
table {
    font-family: arial, sans-serif;
    border-collapse: collapse;
    width: 100%;
}

td, th {
    border: 1px solid #dddddd;
    text-align: left;
    padding: 8px;
}
.similar_item {
    margin: 5px;
     border: 2px solid GREEN;
    border-radius: 5px;
    float: left;
    width: 180px;
   height: 110px;
   text-align: center;
   padding-top: 20px;
}


</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Auction Profile</title>
</head>
<body>


	<a href ="Search.jsp" >
		<img src = "goback.png" style= 'width:50px;height:50px;' >
	</a>



	<%
		
	
/*
.similar_item {
    margin: 5px;
    border: 1px solid #ccc;
    float: left;
    width: 180px;
}*/
		
		
		Item item = (Item)session.getAttribute("item");
		Account user = (Account)session.getAttribute("user");
		
		auction auc = null;
		auc =  Operations.get_item_auction(item.getItemID());
		out.println(session.getAttribute("message")!=null ? session.getAttribute("message"): "");
		session.setAttribute("user", user);
		session.setAttribute("item", item);
		session.setAttribute("message", null);
		
		//if auction is open but the date is due past . meaning it is time to close.
		String closing_date = auc.getDate();
		Operations.format.setTimeZone(TimeZone.getTimeZone("America/New_York"));
		String today = Operations.format.format(new Date());
		
		if (auc.getStatus() == true && Operations.Date_compare(today.split(" "), closing_date.split(" "))>=0){
			
			out.println("Processing.....");
			
			double initial_price = auc.getInit_price();
			double current_price = auc.getCurrent_price();
			double secret_price = auc.getSec_price();
			
			
			//there is no secret price
			if (secret_price <= 0){
				
				//if there is at least one bid
				if (current_price > initial_price){
					
					//1) Notify the winner
					//2) Notify The owner

					//1
					String img = "<strong> YAYYYYYYY</strong><br><img  height = \"150px\" width = \"150px\" src = \"http://www.reactiongifs.com/r/gj1.gif\"><br>";

					Operations.notify_sender(auc, "WON AUCTION", img +"Congragulations!! You have won the following auction ==> Auction ID: " + auc.getAuction_ID());
					
					//2
					

					Operations.send_message(auc.getEmail(),"Auction Closure ==> Auction Id: "+auc.getAuction_ID(), img +"Congragulations!!! You Auction Is Closed And The Highest Bidder Successfully Won the Auction!");

				}
				//no bids were placed
				else{
					//notify the owner that the item was not sold
					
					String img = "<strong> NOOOOOOO</strong><br><img  height = \"150px\" width = \"150px\" src = \"http://i.imgur.com/DjPMzlU.gif\"><br>";

					Operations.send_message(auc.getEmail(),"Auction Closure ==> Auction Id: "+auc.getAuction_ID(), img +"Unfortunately Your Item Was not sold to Any Bidder. ");
				}
				
			}
			
			//there is secret price specfied by the auction holder
			else{
				
				//if there is atleast one bid
				if (current_price > initial_price){
					
					//if the current price is greater than reserve
					if (current_price >= secret_price){
						
						//0 update the secret resrve to match the price
						//1)notify the owner
						//2)notify the owner
						//change the reserve Price
						
						//0
						String reserve = "UPDATE auction set secret_price = " + current_price + " WHERE auctionID = " + auc.getAuction_ID() + ";";
						Operations.Insert(reserve);

						//1
						String img = "<strong> YAYYYYYYY</strong><br><img  height = \"150px\" width = \"150px\" src = \"http://www.reactiongifs.com/r/gj1.gif\"><br>";

						Operations.notify_sender(auc, "WON AUCTION", img +"Congragulations!! You have won the following auction ==> Auction ID: " + auc.getAuction_ID());
						
						//2
						Operations.send_message(auc.getEmail(),"Auction Closure ==> Auction Id: "+auc.getAuction_ID(), img +"Congragulations!!! You Auction Is Closed And The Highest Bidder Successfully Won the Auction!");

					}else{
						
						
						//notify sender
						//notify owner
						
						
						String img = "<strong> YAYYYYYYY</strong><br><img  height = \"150px\" width = \"150px\" src = \"http://www.reactiongifs.com/r/gj1.gif\"><br>";

						Operations.notify_sender(auc, "WON AUCTION", img +"Congragulations!! You have won the following auction ==> Auction ID: " + auc.getAuction_ID());
						
						
						Operations.send_message(auc.getEmail(),"Auction Closure ==> Auction Id: "+auc.getAuction_ID(),img+ "Congragulations!!! You Auction Is Closed And The Highest Bidder Successfully Won the Auction!");


								
						
					}
					
				}
				//there is no bid
				else{
					
					//Operations.notify_owner(auc, "You Auction is Closed And no Bids Were Placed");
					Operations.send_message(auc.getEmail(),"Auction Closure ==> Auction Id: "+auc.getAuction_ID(), "Unfortunately Your Item Was not sold to Any Bidder. ");


				}
				
			}
			
			String inactive = "UPDATE auction set active = false WHERE auctionID = " + auc.getAuction_ID() + ";";
			Operations.Insert(inactive);
					
					
			out.println("<br><h3 style='color:red;'>It Seems Like This Auction Was Closed On ==>" + closing_date.toString()+ "</h3>");
			return;
		}
		
		String status = auc.getStatus()?" <strong style = 'color:green;'>Active</strong>" : "<strong style = 'color:red;'>InActive</strong>";
		
		
	%>
	
	<h2> Welcome User: <%= user.getName() %></h2>
	
	<div align="center" style="border:1px solid red">
		<p>Status: <%=status %> </p>
		<p>Closing: <strong><%=auc.getDate() %></strong></p>
	</div>
	
	<% 
	 				//FOR BIDS HISTORY
	 				if (request.getParameter("bids")!= null){
	 					
	 					
	 					String sql_statement = "SELECT * FROM auction_history WHERE auctionID = " + auc.getAuction_ID() + ";";
	 					String result = Operations.executeHistoryBidQuery(sql_statement);
	 					//out.println(sql_statement);
	 					
	 					
	 					if (result == null){out.println("<h3> Nothing Found</h3>");}
	 					
	 					else{
	 					out.println("<br><h4> Bids History </h4><br>");
	 					
	 					out.println("<table><tr> <th>Bidders</th><th>Price</th> <th>AuctionID</th> <th>BidID</th> </tr>" + result + "</table>");
	 					}
	 					
	 				
	 				}
	 				%>	
	 			

	<div>
		<br>
		<br>
		 <img src = "http://askabbystokes.com/wp-content/uploads/2015/06/laptop-vs-tablet.jpg" style="width:200px;height:200px;"alt = "Not Available">
		 <p>Item Name: <strong><%=item.getItemName() %></strong></p>
		 <p>Item ID: <strong><%=item.getItemID() %></strong></p>
		 <p>Item Type: <strong><%=item.getItemType() %></strong></p>
		 
	 </div>
	 
	 <br>
	 
	 <form action = "auction.jsp" method="post">
	 
	 
	 		<strong id = "price">Current Price:  $<%= auc.getCurrent_price() %></strong>
	 		<br>
	 		<strong>Minimum Increment Bid: $<%= auc.getMin_increment_price() %></strong>
	 		
	 		<br>
	 			<input type = "text"  name="user_bid" placeholder="$124"> 
	 			<input type = "submit" value= "BID" name="bid">
	 			 <br>
		 		 <br>
				 <br>
				 
				 <div>
		 	 		<input type = "submit" value = "View Bids History" name = "bids">
				 </div>
				 
	 			<%
	 			
	 			if (request.getParameter("auto_bids")!= null && auc.getStatus()){
 					
 					out.println("<h3>AUTO BIDDER ON</h3>");
 					
 					try{
 						
 						double target_price = Double.parseDouble(request.getParameter("target_price"));
 						double new_price =  Double.parseDouble(request.getParameter("post_price"));
 						
 						boolean numbers =( target_price <= auc.getCurrent_price()) || ((new_price - target_price) < auc.getMin_increment_price());
 						
 						if (numbers){
 							
 							throw new IllegalArgumentException();
 						}
 						
 						String query = "INSERT INTO auto_bidding (target_price, new_price, auctionID,email) ";
 						String vals = "VALUES (" + target_price + ", " + new_price + ", " + auc.getAuction_ID() + ",\'" + user.getEmail()+"\');";
 						//out.println(query+vals);
 						if (!Operations.Insert(query+vals)){
 							
 							out.println("<h3 style='color:RED;'> !!!Your Request Could not be Completed at the moment. Please Try Again later!!!</h3>");
 						}else{
 							
 							
 							out.println("<h3 style='color:Green;'> Your Auto Bid is set Now. <br>Target Price: $" + target_price + "<br>Your Price: $" + new_price+ "</h3>");

 						}
 					
 						
 						
 						
 						
 					}catch(NumberFormatException e){
 						
 						out.print("<h3 style='color:RED;'> Both of the fields MUST BE NUMERICAL!!!</h3>");
 					}catch(IllegalArgumentException e){
 						
 						out.print("<h3 style='color:RED;'> Following Condition Must Meet!!!</h3>");
 						out.println("<h3>1)Target Price Must be greater than current price<br>2)You New Price Must Obide Current Minimum Increment<br> 3)Your New Price Must Be greater than target Price</h3>");

 					}
 				}
	 			
	 				//BID REQUEST
	 				if (request.getParameter("bid")!= null && auc.getStatus()){
	 					
	 					try{
	 						
	 						double bid_price = Double.parseDouble(request.getParameter("user_bid"));
	 						
	 						
	 						
	 						
	 						if (bid_price <= auc.getCurrent_price()){
	 							
	 							throw new Exception();
	 						}
	 						
	 						
	 						if ((bid_price - auc.getCurrent_price()) < auc.getMin_increment_price()){
	 							
	 							throw new IllegalArgumentException();
	 						}
	 						double bid_amount =  bid_price - auc.getCurrent_price();
	 						int[] IDS = Operations.item_Auction_ID(true);
	 						//System.out.println(IDS[2]);
	 						
	 						String img = "<strong> NOOOOOOO</strong><br><img  height = \"150px\" width = \"150px\" src = \"http://i.imgur.com/DjPMzlU.gif\"><br>";

	 						Operations.notify_sender(auc, "Higher Bid Alert", img +"Some Body Bidded Higher than you for Auction#: ==> " + auc.getAuction_ID());

	 						
	 						String SQL_COMMAND = "UPDATE auction set currentPrice =" + bid_price + " WHERE auctionID =" + auc.getAuction_ID()+";";
							if (!Operations.Insert(SQL_COMMAND)){
								
								throw new NumberFormatException();
							}
							
							SQL_COMMAND = "INSERT INTO auction_history (email,price,auctionID,bidID)";
							String vals = "VALUES( \'" + user.getEmail() + "\', " + bid_amount + ", " + auc.getAuction_ID() + ", " + IDS[2] + ");";
							
	 						if (!Operations.Insert(SQL_COMMAND + vals)){
	 							
	 							System.out.println("\t!!!!!SOMETHING WENT WRONG ADDING BID INTO AUCTION HISTORY TABLE!!!!");
	 						}
	 						
	 						String message = "<Strong style='color:Green;'>You successfully Bidded: $"+ bid_price +"</strong>`";
	 						//session.setAttribute("message" , message);
	 						
	 						//check for auto_bidding everytime
	 						
	 						SQL_COMMAND = "SELECT  * from auto_bidding AB WHERE AB.target_price <=" +bid_price +" AND AB.auctionID = " +auc.getAuction_ID()+" ORDER BY AB.new_price ASC;";
	 						//System.out.println(SQL_COMMAND);
	 						String auto_bidders = Operations.executeQueryAutoBid(SQL_COMMAND);
	 						//System.out.println(auto_bidders);
	 						
	 						//if some auto bidders found for the current price 
	 						if (auto_bidders != null){
		 						StringTokenizer st  = new StringTokenizer(auto_bidders, "\n");
		 						
								boolean prev_bidder =false;
								String prev_email = "";

		 						while (st.hasMoreElements()){
		 							
		 							
		 							String token = st.nextToken();
		 							StringTokenizer st2 = new StringTokenizer(token, ",");
		 							Double a_target_price = Double.parseDouble(st2.nextToken()); // target price
		 							Double a_new_price = Double.parseDouble(st2.nextToken());
		 							st2.nextToken();
		 							String email = st2.nextToken();
		 							
		 							//System.out.println("New Price: " + a_new_price);
		 							//System.out.println("Email: " + email);
		 							
		 							IDS = Operations.item_Auction_ID(true);
		 							
			 						
		 							String auction_cur_price = "UPDATE auction set currentPrice =" + a_new_price + " WHERE auctionID =" + auc.getAuction_ID()+";";
									
		 							String auc_history = "INSERT INTO auction_history (email,price,auctionID,bidID)";
									String auc_history_vals = "VALUES( \'" + email + "\', " + (a_new_price - bid_price) + ", " + auc.getAuction_ID() + ", " + IDS[2] + ");";
									
									String delete_auto_record_query = "DELETE FROM auto_bidding WHERE target_price =  " + a_target_price + " AND new_price = " + a_new_price + " AND auctionID = " + auc.getAuction_ID() + " AND email = \'" + email + "\';";
									
									
									
									if (prev_bidder){
										
										Operations.send_message(prev_email,"Your Auto Bid Status For Item:  "+ item.getItemName(), "Unfortunately Somebody bidded higher than your auto bid Amount");
										prev_bidder = false;
									}
									//meaning the auto bid amount is not enogh
									if (a_new_price <= bid_price){
										
										
										//1)Delete the record from auto bidding
										//2) Alert the auto bidder
										
										
										//1)  
										Operations.Insert(delete_auto_record_query);

										
										//2)
										Operations.send_message(email,"Your Auto Bid Status For Item:  "+ item.getItemName(), "Unfortunately Somebody bidded higher than your auto bid Amount");

										prev_bidder = false;
										
										
									}
									else{
										
										//1)add to the auction currentPRice
										//2)add to the auction history
										//3)bid_price = a_new_price
										//4) Delete the record from auto_bidding 
										//5) Need to send some notification to the auto bidder
										//6) Update the message for the current user to let him know somebody beat your price by auto bidding
										
										//1
										Operations.Insert(auction_cur_price);
										
										//2
										Operations.Insert(auc_history + auc_history_vals);
										
										//3
										bid_price = a_new_price;
										
										//4 
										Operations.Insert(delete_auto_record_query);
										
										//5
										Operations.send_message(email,"Your Auto Bid Status For Item:  "+ item.getItemName(), "You Have succesffully Auto Bided to ==> $" +a_new_price);

										
										
										//6
										message += "<h2><strong style='color:RED'> Unfortunately Other Bidder/Bidders beat your bid price by Auto Bidding to ==> $" + a_new_price +"</strong></h2>";

										//7
										prev_email = email;
										prev_bidder = true;
										
									}
									
									//Operation.Insert(auction);
									//Opeartion.Insert(auc_history + vals_bid);
									
									//perform deletion
									
									
									/*System.out.println(auction);
									System.out.println(auc_history+ vals_bid);
									System.out.println(delete_auto_record_query);*/
									
		 						}
	 						}
	 						session.setAttribute("message" , message);
	 						response.sendRedirect("auction.jsp");
	 						
	 					}
	 					
	 					
						catch(NumberFormatException e){
	 						
	 						String message = "<Strong style='color:RED;'>Could not Add your Bid . Please Try Again Later </strong>";
							out.println(message);
	 					}
						catch(IllegalArgumentException e){
	 						
	 						String message = "<Strong style='color:RED;'>You New Price must be higher or equal to minimum bid price specified</strong>";
							out.println(message);
	 					}
	 					
	 					catch(Exception e){
	 						
	 						String message = "<Strong style='color:RED;'>You Must Enter Numerical Value And your Price Must be Greater Than Current Auction Price! </strong>";
	 						out.println(message);
	 					}
	 				}
	 			%>
	 </form>
	 
	 <br>
	 <input  type = "button" value = "Set Auto Bidding"  onclick = "showAutoAuction()">
	 <br>
	 <div id = "auto_auction" hidden>
	 
	 	
	 
	 	<form action = "auction.jsp" method = "post">
	 	
	 	
	 		Target Price:<input type = "text" placeholder="$123" name = "target_price"><br>
	 		Your Price:<input type = "text" placeholder="$123" name = "post_price"><br>
	 		<input type = "submit" value = "Set Auto Bid"  name="auto_bids"><br>
	 		
	 		
	 	
	 	</form>
	 
	 </div>
	 <br>
	 <br>
	 <br>
	 <h2>Similar Items: </h2>
	
	 <% 
		 ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		
	
		//Create a SQL statement
		Statement stmt = con.createStatement();
		//Get the selected radio button from the index.jsp
		
		
		String itemType = item.getItemType();
		
		
			String str = "SELECT * FROM item INNER JOIN auction ON item.itemID = auction.itemID WHERE itemType = \'" + item.getItemType() + "\'";
			//System.out.println(str);
			ResultSet result = stmt.executeQuery(str);
			
			String auction_month = auc.getDate().split("-")[1];
			System.out.println(auction_month);
			auction_month = Operations.MONTHS[Integer.parseInt(auction_month)];
			while(result.next()){
				
				//String date =Operations.MONTHS[Operations.format.parse(result.getString("date")).getMonth()];
				String date = result.getString("date");
				System.out.println(date);
				date = date.split("-")[1];
				System.out.println(date);
				date = Operations.MONTHS[Integer.parseInt(date)];
				System.out.println(date);
				System.out.println("\n\n");
				//System.out.println("Similar Item Month: " + date);
				
				if (date.equals(auction_month)){
					
					
					String itemResultsName = result.getString("itemName");
					String itemResultsType = result.getString("itemType");
					String itemResultID = result.getString("itemID");
					
					if (!itemResultsName.equals(item.getItemName())){
						
						auction auc_2 = null;
						auc_2 =  Operations.get_item_auction(Integer.parseInt(itemResultID));
						
						
						String start = "<div class = 'similar_item'>";
						String form = "<form action='searchedItems.jsp' method = 'post'><input type = 'submit' name='items' value = '" +itemResultID+","+itemResultsName+","+itemResultsType + "'></form>";
						String end = "</div>";
						out.println(start+"<b> Item Name:</b> "+ itemResultsName + "<br><b>Item Type:</b>     "+ itemResultsType+ "<br> <b>Current Bid Price:</b> $"+ auc.getCurrent_price() +form + end);
					
					}
					
			
					
				}
				
			}
				
				
				
				
		
		%>
		
		 
		 
		 	</div>
		 	
		
	
		 
		
		 
		 
	
	
	 
	
	<script>
	
	
	function showAutoAuction() {
		   var x = document.getElementById("auto_auction");
		   if (x.style.display == "block") {
		       x.style.display = "none";
		   } else {
		       x.style.display = "block";
	   		}
		}
	
	function showAlert() {
		   var x = document.getElementById("auto_alert");
		   if (x.style.display == "block") {
		       x.style.display = "none";
		   } else {
		       x.style.display = "block";
	   		}
		}
	
	</script>

</body>
</html>