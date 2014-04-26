<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="css/main.css" type="text/css"
	title="normal" />

</head>
<body>

	<%@ page language="java" import="java.sql.*"%>
	<%
		try {

			Class.forName("org.postgresql.Driver");
			Connection conn = null;
			conn = DriverManager.getConnection(
					"jdbc:postgresql://localhost:5432/postgres",
					"postgres", "password");

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


	<%@include file="header.jsp"%>

	<h1 style="text-align: center">
		You Shouldn't Be Here >:| 
	</h1>
	<a href = "index.jsp"><h2> Go Back to the Index</h2> </a>
	<center>
	<img src = "img/error.png " width="25%" height="25%" alt = "Yes" > 
	<center>
</body>
</html>