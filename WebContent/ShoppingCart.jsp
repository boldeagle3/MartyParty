<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" language="java" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%@include file="header.jsp" %>0
	<h1>Shopping cart</h1>
	<!-- Display the shoping cart of the person -->
	<%
		try{
			  Class.forName("org.postgresql.Driver");
				Connection conn = null;
				conn = DriverManager.getConnection(
				"jdbc:postgresql://localhost:5432/postgres", "postgres", "password");
				conn.setAutoCommit(false);

		
	%>
	
	<table border="3">
	<tr>
		<th>name</th>	
		<th>quantity</th>
		<th>price</th>
		
	</tr>
	<%
	 String b=request.getParameter("credit");
	if(b!=null){
		 try { 
			 int q= Integer.parseInt(b);
			 response.sendRedirect("confirmation.jsp");
    	 } catch(NumberFormatException e) { 
    		%>Not a number<%
    	}
		
	}
	 if(session.getAttribute("role")==null){
     	response.sendRedirect("error.jsp");
     }
	conn.setAutoCommit(false);
	ResultSet rs=null;
	PreparedStatement statement=conn.prepareStatement(
			"SELECT * FROM cart WHERE userid=?");
	String s=session.getAttribute("id").toString();
	int d=Integer.parseInt(s);
	statement.setInt(1, d);
	rs= statement.executeQuery();
	double sum=0;
	while(rs.next()){
		ResultSet gg=null;
		PreparedStatement st=conn.prepareStatement(
				"SELECT * FROM products WHERE id=?");
		st.setInt(1,Integer.parseInt(rs.getString("product")));
		gg=st.executeQuery();
		if(gg.next()){
			%>
			<tr>
			<td><%=gg.getString("name") %></td>
			<td><%=rs.getInt("amount") %></td>
			<td>$<%=gg.getDouble("price")*rs.getInt("amount")%></td>
			</tr>
			<% 
			sum+=gg.getDouble("price")*rs.getInt("amount");
		}
			
		%>
		
		<% 
	}
	
	%>
	Total Price = <%=sum %>
		<form action="ShoppingCart.jsp" method="POST">
		<input type="text" name="credit" required>
		<button type="submit">purchase</button>
		</form>
	
	<%			conn.setAutoCommit(true);

	conn.close();
	}catch (SQLException sqle) {
	    out.println(sqle.getMessage());
	} catch (Exception e) {
	    out.println(e.getMessage());
	} %>
</body>
</html>