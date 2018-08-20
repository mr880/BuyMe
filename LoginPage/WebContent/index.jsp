	<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	    pageEncoding="ISO-8859-1"%>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
	
	
	
	
	
	
	<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
	
	
	<head>
	
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Password Storage</title>
	
		<style>
	
		
		</style>
	</head>
	
	
	<body>
	
	<h1> <blink>BUYME </blink></h1>
	
	
				
	 		
	 			<div>
	 				<!-- ! -->
					<form method="post" action="redirect_decision.jsp" >
		   
					 	 <p class="txt">UserName:<br>  <input type="text" name="username"  placeholder="jon.doe"/></p> 
					 	 <br>
					  	<p class="txt">Password:<br> <input type="password" name="pass" placeholder="jondoe123"/></p> 
					 	 <br>
					  
					  	<input type="submit" value="Submit"/>
					  	
					</form>
		
		
					<a href="createAccount.jsp" title="Create Account">Do not have account? Sign up</a>
					<br>
					<a href="forgotPass.jsp" title="Forgot Pasword?">Forgot Password?</a>
	 			
	 			</div>
	 			
				
    			
	 			
	 			
	</html>
	
	