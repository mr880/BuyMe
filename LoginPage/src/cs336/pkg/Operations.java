package cs336.pkg;



import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.StringTokenizer;

import com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException;


public class Operations {
	
	public static String[] MONTHS = {"JANUARY", "FEBUARY" , "MARCH", "APRIL", "MAY","JUNE","JULY", "AUGUST", "OCTOBER","NOVEMBER","DECEMBER"};
	public static SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
	
	public Operations() {}
	
	
	public static boolean notify_sender(auction auc,String subject, String message) {
		
		String highest_bidder_email = "SELECT AH.email from auction_history AH WHERE AH.auctionID = " +auc.getAuction_ID()+  " AND AH.bidID = (SELECT max(bidID) FROM auction_history);";
				
		
		ApplicationDB db =null;
		Connection con = null;

	
		try{
			
			db = new ApplicationDB();	
			con = db.getConnection();
			Statement stmt = con.createStatement();
			ResultSet result = stmt.executeQuery(highest_bidder_email);
			
			result.next();
				
				
			
			String email = result.getString("email");
			if (email == null) {return false;}
			System.out.println(email);
			
			send_message(email,subject, message);
			
			db.closeConnection(con);
			return true;
		}
		 
		 catch(Exception excep){
			 
			 
			db.closeConnection(con);
			System.out.println("PROBLEM OCCURED NOTIFYING THE OWNER IN THE notify_sender() METHOD");
			System.out.println("Executed Query: " + highest_bidder_email);
			return false;
		 }	
		
		
		
	}
	
	
	public static boolean send_message(String email,String subject, String message ) {
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		String strEmail = null;
		String emailCondition = null;
		try {
			
			Statement stmt = con.createStatement();

			strEmail = "INSERT INTO email(`to`, `from`, `date`, `time`, `subject`, `message`) VALUES ";
			SimpleDateFormat sdfr = new SimpleDateFormat("MM/dd/yyyy");
			SimpleDateFormat sdfr2 = new SimpleDateFormat("HH:mm:ss.SSSSSS");
		    Date date = new Date();
		    String currentdate = "";
		    String currentTime = "";
		    currentdate = sdfr.format(date);
		    currentTime = sdfr2.format(date);
			emailCondition = "(\'"+ email+"\' ,"+ "\'farasxarafat@hotmail.com\',  \'" + currentdate+"\', \'" + currentTime+"\' , \'" + subject+"\', \'"+ message +"\' )"; 
			System.out.println(strEmail+emailCondition);
			stmt.executeUpdate(strEmail+emailCondition);
			
			
			
			return true;
		}
		catch(Exception e) {
			db.closeConnection(con);
			System.out.println("ERROR SENDING THE MESSAGE");
			System.out.println("EXECUTED QUERY: " + strEmail+emailCondition);
			return false;
		}
			
		
	}
	
	/**
	 * 
	 * @param Table_name: The name of the table that will be used from BUYME databse
	 * @param user_info : user Object that will be deleted from the table
	 * @return
	 * @throws SQLException 
	 */
	public boolean Delete(String Table_name, Account user_info) throws SQLException {
		
		/**need to delete the account**/
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		

		//Create a SQL statement
		Statement stmt = con.createStatement();
		//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
		
		String str = "DELETE FROM " + Table_name +" WHERE email = \'" + user_info.getEmail()+"\'";
		//System.out.println(str);
		
		//out.println("<h1>"+str + "</h1>");
		
		
		try{
			
			
			stmt.executeUpdate(str);
		
			
			
		}
		 
		 catch(Exception excep){
			 
			 
			db.closeConnection(con);
			return false;
		 }
		
		
		
		
		
		return true;
	}

	
	/**
	 * 
	 * @return Integer Array with first Index of Auction ID and Second Index of Item ID
	 */
	public static int[] item_Auction_ID (boolean bidID) {
		
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		

		
		try{
			
			Statement stmt = con.createStatement();
			String str = null;
			
			
				
			str = "SELECT  auctionID ,itemID, secret_price FROM auction WHERE email = 'dummyxdummy@hotmail.com';";
			
			ResultSet result;
			
			result = stmt.executeQuery(str);
			int[] output = {0,0,0};
			
			
			result.next();
			output[0] = result.getInt("auctionID");
			output[1] = result.getInt("itemID");
			output[2] = result.getInt("secret_price");
			
			db.closeConnection(con);
			if (!update_item_Auction_ID(output, bidID)) {
				
				System.out.println("Problem Occured Updating ITEM ID and AUCTION ID");
			}
			return output;
			
			
		}
		 
		 catch(Exception excep){
			 
			db.closeConnection(con);
			return null;
			
		 }
		
		
		
	
	}
	
	

	private static boolean update_item_Auction_ID (int[] IDS, boolean bidID) {
		
		
		int new_auc_ID = IDS[0] + 1;
		int new_item_ID = IDS[1] + 1;
		int new_bid_id = IDS[2] + 1;
		
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		

		
		try{
			
			
			if (bidID) {
				
				Statement stmt = con.createStatement();
				String str = "UPDATE auction set secret_price = "+ new_bid_id +" WHERE email = 'dummyxdummy@hotmail.com';";
				stmt.executeUpdate(str);
				
			}else {
				
				
				Statement stmt = con.createStatement();
				String str = "UPDATE auction set auctionID = "+ new_auc_ID +" WHERE email = 'dummyxdummy@hotmail.com';";
				
				
				Statement stmt_2 = con.createStatement();
				String str_3 = "UPDATE item set itemID = "+ new_item_ID +" WHERE itemID =" + IDS[1];
				//System.out.println(str_3);
				
				int result, result_2;
				
				result = stmt.executeUpdate(str);
				stmt_2.executeUpdate(str_3);
				
			}
			
			db.closeConnection(con);
		
			return true;
			
			
		}
		 
		 catch(Exception excep){
			 excep.printStackTrace();
			db.closeConnection(con);
			return false;
			
		 }
	}


	/**
	 * 
	 * @param SQL_Statement: pass the sql statements that you would enter in SQL workBench
	 * @return
	 */
	public static boolean Insert(String SQL_Statement) {
		
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		

		try{
			
			
			Statement stmt = con.createStatement();
			
			//out.println(str+values);
			int result = stmt.executeUpdate(SQL_Statement);
			

			db.closeConnection(con);
			
			return true;
			
		}
		 catch(MySQLIntegrityConstraintViolationException e) {
			 
			 return false;
		 }
		 catch(Exception excep){
			 
			 System.out.println("SOMETHING WENT WRONG IN INSERT METHOD");
			 System.out.println(SQL_Statement);
			 excep.printStackTrace();
			 db.closeConnection(con);
			 return false;
		 }	
	
	}
	
	public static auction get_item_auction(int itemID) {
		
		auction output = null;
		

		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		
		String str = "SELECT * from item INNER JOIN auction ON item.itemID = auction.itemID and item.itemID =" + itemID+";";
				
		try{
			
			
			Statement stmt = con.createStatement();
			
			//out.println(str+values);
			ResultSet result = stmt.executeQuery(str);
			
			if (result.next() == false) {
				
				System.out.println("Something went wrong retrieving the auction in get_item_auction method");
				return null;
			}
			
			output = new auction(result.getDouble("i_price"), result.getDouble("min_increment_price"), result.getDouble("secret_price"), result.getInt("auctionID"), result.getInt("itemID"),result.getString("email"),result.getDouble("currentPrice"),result.getBoolean("active"),result.getString("date"));

			db.closeConnection(con);		
			return output;
		
		
		}catch(Exception e) {
		
			db.closeConnection(con);

			return null;
		
		}
	}
	
	/**
	 * 
	 * @param SQL_Statement
	 * @return Specifally used for auction _history
	 */
	public static String executeHistoryBidQuery(String SQL_Statement) {
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		
				
		try{
			
			
			Statement stmt = con.createStatement();
			
			
			ResultSet result = stmt.executeQuery(SQL_Statement);
			
			if (result.next() == false) {
				
				System.out.println("EMPTY RESULT FROM executeQuery Method");
				return null;
			}
			String output = "";
			do{
					
					
					output += "<tr> <td>"+ result.getString("email") + "</td><td>"+result.getDouble("price") +"</td><td>" + result.getInt("auctionID")+ "</td><td>" + result.getInt("bidID") + "</td></tr>";
					//System.out.println(output);
					
				}while(result.next());
			

			db.closeConnection(con);		
			return  output;
		
		
		}catch(Exception e) {
		
			db.closeConnection(con);

			return null;
		
		}

		
	}
	
	public static String executeQueryAutoBid(String SQL_Statement) {
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		
				
		try{
			
			
			Statement stmt = con.createStatement();
			
			
			ResultSet result = stmt.executeQuery(SQL_Statement);
			
			if (result.next() == false) {
				
				System.out.println("EMPTY RESULT FROM executeQueryAutoBid Method");
				return null;
			}
			String output = "";
			do{
					
					
					output +=  result.getDouble("target_price")+"," +result.getDouble("new_price") + "," +result.getInt("auctionID")+ "," + result.getString("email") + "\n";
					//System.out.println(output);
					
				}while(result.next());
			

			db.closeConnection(con);		
			return  output;
		
		
		}catch(Exception e) {
		
			db.closeConnection(con);
			e.printStackTrace();
			System.out.println(SQL_Statement);

			return null;
		
		}

		
	}
	
public static String executeNotificationQuery(String SQL_Statement) {
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		
				
		try{
			
			
			Statement stmt = con.createStatement();
			
			
			ResultSet result = stmt.executeQuery(SQL_Statement);
			
			if (result.next() == false) {
				
				System.out.println("EMPTY RESULT FROM executeNotificationQuery Method");
				return null;
			}
			String output = "";
			do{
					
				
					output += "<tr> <td>" + result.getString("date")+ "</td><td>" + result.getString("time") +"</td><td>" + result.getString("subject") + "</td><td>"+ result.getString("message")+ "</td></tr>";
					//System.out.println(output);
					
				}while(result.next());
			

			db.closeConnection(con);		
			return  output;
		
		
		}catch(Exception e) {
		
			db.closeConnection(con);
			e.printStackTrace();
			return null;
		
		}

		
	}


public static int Date_compare(String[] today , String[] future){
	
	String today_date = today[0];
	String today_time = today[1];
	
	String future_date = future[0];
	String future_time = future[1];
	
	
	StringTokenizer t_d = new StringTokenizer(today_date, "-");
	
	StringTokenizer f_d = new StringTokenizer(future_date, "-");
	
	int i = 0 ;
	
	while ( i< 3){
		
		double t = Double.parseDouble(t_d.nextToken());
		double f = Double.parseDouble(f_d.nextToken());
		
		if (t == f){}
		
		else if(t > f){
			
			return 1;
		}
		else {
			
			return -1;
		}
		
		i++;
	}
	
	 t_d = new StringTokenizer(today_time, ":");
	
	 f_d = new StringTokenizer(future_time, ":");
	 
	 i=0 ;
	 while (i < 2){
		 
		float t = Float.parseFloat(t_d.nextToken());
		float f = Float.parseFloat(f_d.nextToken());
		
		
		if (t == f) {}
		
		else if (t > f){
			
			return 1;
		}else {
			
			return -1;
		}
			
		 
		 i++;
	 }
	 
	 return 0;
	
	
} 

}


