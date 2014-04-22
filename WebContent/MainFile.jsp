<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>

<%@ page language="java" import="java.sql.*" %>
<%
try {

	Class.forName("org.postgresql.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection(
			"jdbc:postgresql://localhost:5432/postgres", "postgres", "password");
	
	ResultSet rset = null;
    Statement st = null;
    st = conn.createStatement();

    //-----------------if need to delete tables to run, do here------------------------------//
	DatabaseMetaData md = conn.getMetaData();
		
    	st.executeUpdate("DROP TABLE IF EXISTS users");
    	st.executeUpdate("Drop TABLE IF EXISTS category");
    	st.executeUpdate("DROP TABLE IF EXISTS products");
    //set up tables

   st.executeUpdate("CREATE TABLE users(  id serial NOT NULL, name varchar(30) NOT NULL, role varchar(30), age int, " +
	    "state varchar(30) , PRIMARY KEY(id) )");
   st.executeUpdate("CREATE TABLE category( id serial NOT NULL,name varchar(30) UNIQUE NOT NULL,description varchar(140))");
   st.executeUpdate("CREATE TABLE products(id serial NOT NULL" + 
   										", name varchar(30) NOT NULL" +
   										", sku varchar(30) UNIQUE NOT NULL" +
   										", category varchar(30) NOT NULL" +
   										", price decimal(18,2) NOT NULL" +
   										");"
   	);
    
    response.sendRedirect("index.jsp");

	conn.close();
	
} catch (SQLException sqle) {
    out.println("sqlexception: " + sqle.getMessage());
} catch (Exception e) {
    out.println("exception: " + e.getMessage());
}

%>



</body>