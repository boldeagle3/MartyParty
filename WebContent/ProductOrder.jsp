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

	<%
		try{
			  Class.forName("org.postgresql.Driver");
				Connection conn = null;
				conn = DriverManager.getConnection(
				"jdbc:postgresql://localhost:5432/postgres", "postgres", "password");
		
	%>
	<%	String proccess=request.getParameter("amount");
		if(proccess!=null){
			conn.setAutoCommit(false);
			ResultSet peq=null;
			PreparedStatement rr=conn.prepareStatement(
					"INSERT INTO cart(userid,products,amount) VALUES()");
			conn.setAutoCommit(true);
		}
		System.out.println("what is going on?");
		String pro=request.getParameter("product");
		System.out.println("pro is null maybe");
		if(pro!=null){
			System.out.println("hello world");
			conn.setAutoCommit(false);
			ResultSet tt=null;
			PreparedStatement ps=conn.prepareStatement(
					"SELECT * FROM products WHERE id=?");
			ps.setInt(1, 1);
			System.out.println("gets to the point a");
		    tt=ps.executeQuery();
		    System.out.println("gets to the point b");
		    if(tt.next()){
		    	System.out.println("Is tt null? "+tt.getString("name"));
		    	%>
		    		<table>
		    		<form action="products_browsing.jsp" method="POST">
		    		<tr>
		    			<td><%=tt.getString("name") %></td>
		    			<td><%=tt.getInt("price") %></td>
		    			<td><input type="number" name="amount" min="1" max="2000"></td>
		    			<td><button type="submit">Accepted</button></td>
		    			
		    		</tr>
		    		</form>
		    		
		    		</table>
		    	<% 
		    	conn.setAutoCommit(true);
		    }
		    }
			
		
		
	%>
   <table border="3">
	<tr>
		<th>name</th>	
		<th>quantity</th>
		<th>price</th>
		
	</tr>
	<%
	conn.setAutoCommit(false);
	ResultSet rs=null;
	PreparedStatement statement=conn.prepareStatement(
			"SELECT * FROM cart WHERE userid=?");
	String s=session.getAttribute("id").toString();
	int d=Integer.parseInt(s);
	statement.setInt(1, d);
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