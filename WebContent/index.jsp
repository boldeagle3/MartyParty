<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="css/main.css" type="text/css" title = "normal" />

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
	
	conn.close();
} catch (SQLException sqle) {
    out.println("sqlexception: " + sqle.getMessage());
} catch (Exception e) {
    out.println("exception: " + e.getMessage());
}

%>


<%@include file="header.jsp" %>

<h1 style = "text-align:center">Welcome to <span style = "text-decoration:line-through"> Amazon</span> Martyzon!!!</h1>
<br>
<hr>
<ul>
    <li>
        <a href="logout.jsp">Logout</a> 
    </li>   
    <li>
        <a href="loginTest.jsp">Login Test</a> 
    </li> 
    <li>
    	<a href="Category.jsp">Category</a>
    </li>
    <li>
    	<a href="products_management.jsp">Products</a>
    </li>

	
</ul>
</body>
</html>