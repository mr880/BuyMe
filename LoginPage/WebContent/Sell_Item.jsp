<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*" import = "java.util.*" import = "java.util.Date" import = "java.text.ParseException"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create an Auction</title>



</head>
<body>

<a href ="user.jsp" >
		<img src = "goback.png" style= 'width:50px;height:50px;' >
	</a>
<%
Account user = (Account)session.getAttribute("user"); 
session.setAttribute("user", user);

%>

<%

	if (request.getParameter("submit")!=null){
		
		String item_name = request.getParameter("item_name");
		String b_name = request.getParameter("brand_name");
		String date = request.getParameter("date");
		double init_price = -1, min_increment = -1, sec_price = -1;
		
		try{
			
			
			init_price  = Double.parseDouble(request.getParameter("init_price"));
			min_increment = Double.parseDouble(request.getParameter("min_increment"));
			sec_price = request.getParameter("sec_price").isEmpty()? -1 : Double.parseDouble(request.getParameter("sec_price"));
			
			
		
			
			if ( init_price > 0 && min_increment > 0 && !item_name.isEmpty()
					&& !b_name.isEmpty() && !date.isEmpty()){
				
				
				//getting the current date
				Operations.format.setTimeZone(TimeZone.getTimeZone("America/New_York"));
				String today = Operations.format.format(new Date());
				
				//get the closing date
				String closing_date = date;
				
				
				
				
				
				
				out.println("<br>today: "+ today.toString());
				out.println("<br>closing: " + closing_date.toString());
				
				
				
				
				
				if (Operations.Date_compare(today.split(" "), closing_date.split(" "))>=0){
					System.out.println(today.compareTo(closing_date));
					throw new IllegalArgumentException();
				}
				
				//System.out.println("Date good");
				
				
				/*System.out.println(Operations.format.format(closing_date));
				System.out.println(Operations.format.format(new Date()));*/
				
				
				/** getting IDS AND UPDATING IDS**/
				int[] IDS = Operations.item_Auction_ID(false);
				
				String str = "INSERT INTO item (itemID,itemName,itemType) VALUES";
				String values =  "(\'" +IDS[1] +"\'"+ "," + "\'"+item_name+"\'" + ",\'" + b_name +"\');";
				boolean status = Operations.Insert(str+values);
				
				String str_auction = "INSERT INTO auction (i_price,min_increment_price,secret_price, auctionID,itemID,email,currentPrice,active,date) VALUES";
				String vals_auction = "( " + init_price + ", " + min_increment+ ", " + sec_price + ", " + IDS[0] + ", " + IDS[1] + ", \'" + user.getEmail() +"\',"+ init_price + "," +true + ",\'" +closing_date+"\');";
				boolean auc_status = Operations.Insert(str_auction + vals_auction);
				//out.println(str_auction+vals_auction);

				
				
				if (IDS ==null || !status || !auc_status){
					
					//out.println("<br>AUCTION ID: " + IDS[0] + "<br>ITEM ID: " + IDS[1]);
					out.print("<br>Something went wrong retrieving the Auction IDS AND ITEM IDS PLEASE TRY AGAIN LATER");
					
				}else{
					
					
					out.println("<h4 style='color: GREEN;'> Item Successfully Added</h4><br><h3> Item Info<br>Name: " + item_name + "<br>Item Category: "+ b_name+"<br>Item Initial Price: $" +init_price + "<br>Auction Minimum Increment: $"+ min_increment+ "<br>Secret Selling Price: $"+ sec_price );
					out.println("<h4 style='color: GREEN;'> <strong>Your Auction ID: " + IDS[0] + "</strong><br><strong> Your Item ID: " + IDS[1] + "</strong></h4>");
					

					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();
					
					
					String Query = "SELECT * from wish_list WHERE itemName = \'" + item_name +"\' AND item_type = \'" + b_name + "\';";
					System.out.println(Query);
					try{
						
						
						Statement stmt = con.createStatement();
						
						//out.println(str+values);
						ResultSet result = stmt.executeQuery(Query);
						
						while (result.next()){
							
							String w_email  = result.getString("email");
							String w_item_name = result.getString("itemName");
							String w_item_type = result.getString("item_type");
							
							String img = "<strong> YAYYYYYYY</strong><br><img  height = \"150px\" width = \"150px\" src =\"http://www.reactiongifs.com/r/2013/04/celebrate.gif\"><br>";
							
							Operations.send_message( w_email, "Item Alert", img +"Your Item <strong>" + w_item_name + "</strong> is here. ACT QUICK!!!");
							
						}
						
					
					
					}catch(Exception e) {
					
						db.closeConnection(con);

						
					
					}
				}
				
			
			}
			
			else{
				
				out.println("<h2 style = 'color: RED;'>Every Field is required</h2>");

				
			}
			
		}
		
		catch(NumberFormatException e){
			
			out.println("<h2 style = 'color: RED;'>INVALID DATE</h2>");

		}
		catch(IllegalArgumentException e){
			e.printStackTrace();
			out.println("<h2 style = 'color: RED;'>Closing Date Must be occur after the current time!</h2>");
		}
		
		
		
		catch(Exception e){
			
			out.println("<h2 style = 'color: RED;'>Initial Price, Minimum Increment Price, and Secret Price Must be Numerical</h2>");
			e.printStackTrace();
		}
		
		
	}
%>


<h3>Post New Item</h3>
<br>


<form action="Sell_Item.jsp" method="post">


	
	Item Name: <input type="text" placeholder="DellA12" name="item_name"><br><br>
	<!--  Item Category: <input type="text" placeholder="Desktop/Laptop/.." name="brand_name">
	<br><br>-->
	Initial Price: <input type="text" placeholder="$123.00" name="init_price"><br><br>
	Min Increment: <input type="text" placeholder="$123.00" name="min_increment">
	<br><br>
	<b>Secret Price: </b><input type="text" placeholder="$123.00" name="sec_price">
	<br><br>
	
	<strong>Closing Date</strong> <input type = "text" placeholder ="YYYY-MM-DD hh:mm" name = "date">  <strong style='color:red;'>!!!You should Input Date in the Exact Format!!! ==> (YYYY-MM-DD hh:mm)</strong>
	<br>
	
	<input type="radio" name="brand_name" value="Desktop" checked> Desktop<br>
  	<input type="radio" name="brand_name" value="Laptop"> Laptop <br>
  	<input type="radio" name="brand_name" value="Tablet"> Tablet
	
	<br>
	<br>
	<input type="submit" value="Post Item" title="Start Auction" name="submit">
	
	
	

</form>
	
	
	

	
</body>
</html>