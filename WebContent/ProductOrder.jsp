<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@include file="header.jsp" %>
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
				conn.setAutoCommit(false);

		
	%>	
	
	<%	
		System.out.println("let it begin");
		String pro=request.getParameter("product");
		String proccess=request.getParameter("amount");
		if(proccess==null&&pro==null){
			response.sendRedirect("error.jsp");
		}
		if(proccess!=null){
			try{
			System.out.println("does it get in here kappa");
			conn.setAutoCommit(false);
			ResultSet peq=null;
			PreparedStatement rr=conn.prepareStatement(
					"INSERT INTO cart(userid,product,amount) VALUES(?,?,?)");
			rr.setInt(1, Integer.parseInt(session.getAttribute("id").toString()));
			rr.setInt(2,Integer.parseInt(request.getParameter("pid")));
			rr.setInt(3,Integer.parseInt(request.getParameter("amount")));
			rr.executeUpdate();
			System.out.println("does it get past here maybe");

			
			response.sendRedirect("products_browsing.jsp");
			}catch(SQLException e){
				%>Incorrect input<% 
				pro=request.getParameter("pid");
				System.out.println("Gets into that nice sweet spot");
			}
			catch(NumberFormatException e){
				%>Incorrect input<% 
				pro=request.getParameter("pid");
				System.out.println("Gets into that nice sweet spot");
			}
		}
		System.out.println("what is going on?");
		
		System.out.println("pro is null maybe");
		if(pro!=null){
			System.out.println("hello world");
			conn.setAutoCommit(false);
			ResultSet tt=null;
			PreparedStatement ps=conn.prepareStatement(
					"SELECT * FROM products WHERE id=?");
			System.out.println("product id is "+Integer.parseInt(pro));
			ps.setInt(1,Integer.parseInt(pro));
			System.out.println("gets to the point a");
		    tt=ps.executeQuery();
		    System.out.println("gets to the point b");
		    if(tt.next()){
		    	System.out.println("Is tt null? "+tt.getString("name"));
		    	%>
		    		<table>
		    		<form action="ProductOrder.jsp" method="GET">
		    		<tr>
		    			<input type="hidden" name="pid" value="<%=Integer.parseInt(pro)%>">
		    			<td><%=tt.getString("name") %></td>
		    			<td><%=tt.getInt("price") %></td>
		    			<td><input type="text" name="amount"></td>
		    			<td><button type="submit">Accepted</button></td>
		    			
		    		</tr>
		    		</form>
		    		
		    		</table>
		    	<% 
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
		st.setInt(1,Integer.parseInt(rs.getString("product")));
		gg=st.executeQuery();
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
		
		<%
	}
	
	
	
	%>
	<!-- list shopping cart -->
	</table>
	<!-- ask if how much of the thing they selected from productBrowsing they wanted added to the shopping list -->
	<%			conn.setAutoCommit(true);

	conn.close();
	}catch (SQLException sqle) {
	    out.println(sqle.getMessage());
	} catch (Exception e) {
	    out.println(e.getMessage());
	} %>
</body>
</html>
