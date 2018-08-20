package cs336.pkg;

public class Account {

	String first="";
	String last = "";
	String username = "";
	String pass = "";
	String email = "";
	
	
	
	public Account(String first, String last, String username, String pass, String email) {
		
		this.first = first;
		this.last = last;
		this.username = username;
		this.pass = pass;
		this.email = email;
	}
	
	public String getName() {
		
		return this.first + " " + this.last;
	}
	
	
	
	public String getUsername() {
		return username;
	}
	
	
	public String getPass() {
		return pass;
	}
	
	
	public String getEmail() {
		return email;
	}
	
	public String getFirst() {
		return first;
	}
	
	public String getLast() {
		return last;
	}
	
	public void setPass(String pass) {
		this.pass = pass;
	}
	
}
