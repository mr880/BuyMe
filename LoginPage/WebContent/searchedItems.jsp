<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Results</title>
</head>
<body>


<%
Account user = (Account)session.getAttribute("user"); 
session.setAttribute("user", user); 
%>

<% 

String item_redirect = request.getParameter("items");

if (item_redirect != null){
	
	List<String> itemList = Arrays.asList(item_redirect.split(","));
	session.setAttribute("item", new Item(Integer.parseInt(itemList.get(0)), itemList.get(1), itemList.get(2)));
	
	response.sendRedirect("auction.jsp");
}

else{
out.println("<h2>Results:</h2>");

	try {
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		
	
		//Create a SQL statement
		Statement stmt = con.createStatement();
		//Get the selected radio button from the index.jsp
		String itemName = request.getParameter("item_name");
		String itemID = request.getParameter("item_id");
		String itemType = request.getParameter("item_type");
		String SortBy = request.getParameter("SortBy");
		String AorD = request.getParameter("AscendOrDescend");
		System.out.println(itemType);
		//if there is an item id
		boolean param_Check = !itemID.isEmpty();
		if(param_Check){
			String str = "SELECT * FROM item I WHERE I.itemID = " + itemID;
			ResultSet result = stmt.executeQuery(str);
			if (result.next()){
				String itemResultsName = result.getString("itemName");
				String itemResultsType = result.getString("itemType");
				String itemResultID = result.getString("itemID");
				auction auc = null;
				auc =  Operations.get_item_auction(Integer.parseInt(itemResultID));
				String form = "<form action='searchedItems.jsp' method = 'post'><input type = 'submit' name='items' value = '" +itemResultID+","+itemResultsName+","+itemResultsType + "'></form><br>";
				out.println("<b> Item Name:</b> "+ itemResultsName + ", <b>Item Type:</b>     "+ itemResultsType+ ", <b>Current Bid Price:</b> $"+ auc.getCurrent_price() +form);
			}
		}
		else{
			//If all types are selected
			if(itemType.compareToIgnoreCase("All") == 0){
				String str = "SELECT * FROM item INNER JOIN auction ON item.itemID = auction.itemID WHERE item.itemName LIKE \'%" +itemName + "%\' ORDER BY (" + SortBy + ") " + AorD;
				System.out.println(str);
				ResultSet result = stmt.executeQuery(str);
				while(result.next()){
							
					String itemResultsName = result.getString("itemName");
					String itemResultsType = result.getString("itemType");
					String itemResultID = result.getString("itemID");
						
					auction auc = null;
					auc =  Operations.get_item_auction(Integer.parseInt(itemResultID));
					String form = "<form action='searchedItems.jsp' method = 'post'><input type = 'submit' name='items' value = '" +itemResultID+","+itemResultsName+","+itemResultsType + "'></form><br>";
					out.println("<b> Item Name:</b> "+ itemResultsName + ", <b>Item Type:</b>     "+ itemResultsType+ ", <b>Current Bid Price:</b> $"+ auc.getCurrent_price() +form);
				}	
			
			}
			else{
				String str = "SELECT * FROM item INNER JOIN auction ON item.itemID = auction.itemID WHERE item.itemName LIKE \'%" +itemName + "%\' AND " + "item.itemType = \'"+ itemType + "\'  ORDER BY (" + SortBy + ") " + AorD;
				System.out.println(str);
				ResultSet result = stmt.executeQuery(str);
				while(result.next()){
							
					String itemResultsName = result.getString("itemName");
					String itemResultsType = result.getString("itemType");
					String itemResultID = result.getString("itemID");
						
					auction auc = null;
					auc =  Operations.get_item_auction(Integer.parseInt(itemResultID));
					String form = "<form action='searchedItems.jsp' method = 'post'><input type = 'submit' name='items' value = '" +itemResultID+","+itemResultsName+","+itemResultsType + "'></form><br>";
					out.println("<b> Item Name:</b> "+ itemResultsName + ", <b>Item Type:</b>     "+ itemResultsType+ ", <b>Current Bid Price:</b> $"+ auc.getCurrent_price() +form);
				}
			}
		}
		
		db.closeConnection(con);
	} catch (Exception e) {
		out.println(e.fillInStackTrace());

	}
}

%>
</body>
</html>