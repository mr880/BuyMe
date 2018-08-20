package cs336.pkg;

public class auction {
	
	private double init_price;
	private double sec_price;
	private double min_increment_price;
	private double current_price;
	private int auction_ID;
	private int item_ID;
	private String email;
	private boolean active;
	private String date;
	
	
	public auction(double i_price, double m_price, double s_price , int a_ID, int i_ID, String email, double c_price, boolean active, String date) {
		
		
		init_price = i_price;
		min_increment_price = m_price;
		sec_price = s_price;
		auction_ID = a_ID;
		item_ID = i_ID;
		this.email = email;
		current_price = c_price;
		this.active = active;
		this.date = date;
	}


	public double getInit_price() {
		return init_price;
	}


	public void setInit_price(double init_price) {
		this.init_price = init_price;
	}


	public double getSec_price() {
		return sec_price;
	}


	public void setSec_price(double sec_price) {
		this.sec_price = sec_price;
	}


	public double getMin_increment_price() {
		return min_increment_price;
	}


	public void setMin_increment_price(double min_increment_price) {
		this.min_increment_price = min_increment_price;
	}


	public double getCurrent_price() {
		return current_price;
	}


	public void setCurrent_price(double current_price) {
		this.current_price = current_price;
	}


	public int getAuction_ID() {
		return auction_ID;
	}


	public void setAuction_ID(int auction_ID) {
		this.auction_ID = auction_ID;
	}


	public int getItem_ID() {
		return item_ID;
	}


	public void setItem_ID(int item_ID) {
		this.item_ID = item_ID;
	}
	
	public String getDate() {
		return date;
	}
	public boolean getStatus() {
		
		return this.active;
	}


	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}
	
	
	
}
