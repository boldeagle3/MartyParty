<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<h1>Current Contents</h1>
	<table border="3">
	<%
		try{
			  Class.forName("org.postgresql.Driver");
				Connection conn = null;
				conn = DriverManager.getConnection(
				"jdbc:postgresql://localhost:5432/postgres", "postgres", "password");
		
	%>
	<%
		
	%>
	<form method="POST"></form>
	<tr>
		<th>name</th>	
		<th>quantity</th>
		<th>price</th>
		
	</tr>
	<%
	conn.setAutoCommit(false);
	ResultSet rs=null;
	PreparedStatement statement=conn.prepareStatement(
			"SELECT * FROM cart WHERE user=?");
	String s=session.getAttribute("id").toString();
	statement.setString(1,s);
	rs= statement.executeQuery();
	while(rs.next()){
		ResultSet gg=null;
		PreparedStatement st=conn.prepareStatement(
				"SELECT * FROM products WHERE id=?");
		statement.setString(1,new Integer(rs.getInt("product")).toString());
		gg=statement.executeQuery();
		if(gg.next()){
			%>
			<tr>
			<td><%=gg.getString("name") %></td>
			<td><%=rs.getInt("amount") %></td>
			<td>$<%=gg.getInt("price")*rs.getInt("amount")%></td>
			</tr>
			<% 
		}
			
		%>
		
		<% conn.setAutoCommit(true);
	}
	
	
	
	%>
	<!-- list shoping cart -->
	</table>
	<!-- ask if how much of the thing they selected from productBrowsing they wanted added to the shopping list -->
	<%conn.close();
	}catch (SQLException sqle) {
	    out.println(sqle.getMessage());
	} catch (Exception e) {
	    out.println(e.getMessage());
	} %>
</body>
</html>