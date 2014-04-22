<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" language="java" import="java.sql.*" %>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="UTF-8">
<title>Products Browsing</title>
<link rel="stylesheet" href="css/main.css" type="text/css" title="normal">
<link rel="stylesheet" type="text/css" href="products.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<%
	Class.forName("org.postgresql.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:postgresql://localhost:5432/postgres",
			"postgres",
			"password");
	conn.setAutoCommit(false);
	%>
</head>
<body>
<%@include file="header.jsp" %>
<div id="columns">
<div id="left_column">
	<form id="categoryFilter" action="products_browsing.jsp" method="post">
   		<input type="radio" name="action" value="all_categories" onclick="this.form.submit();">All Categories
   		<br>
    	<%
    	ResultSet rsCategories = null;
    	try {
    		PreparedStatement prst = conn.prepareStatement(
    				"SELECT name " +
    	        	"FROM category;",
    	        	ResultSet.TYPE_SCROLL_INSENSITIVE,
    	        	ResultSet.CONCUR_READ_ONLY);
        	
        	rsCategories = prst.executeQuery();
        	conn.commit();
        
        	if (rsCategories.first()) {
        		String categoryName = rsCategories.getString("name");
    		    %>
    	    	<input type="radio" name="action" value="filter_<%=categoryName%>" onclick="this.form.submit();"><%=categoryName%>
    	    	<br>
    	    	<%
        	}
    	    while (rsCategories.next()) {
    	    	String categoryName = rsCategories.getString("name");
    		    %>
    	    	<input type="radio" name="action" value="filter_<%=categoryName%>" onclick="this.form.submit();"><%=categoryName%>
    	    	<br>
    	    	<%
        	}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	%>
    </form>
</div>
<div id="right_column">
   	<table id="products_table">
   		<tr>
   			<td colspan="2">
    			<form action="products_browsing.jsp" method="post">
                <input type="text" name="search" />
                <input type="submit" name="action" value="Search products">
           		</form>
   			</td>
   		</tr>
   		<tr>
   			<td>Name</td><td>SKU</td><td>Category</td><td>Price</td>
   		</tr>
   		<%
   		String action = request.getParameter("action");
       	ResultSet rsProducts = null;
   		PreparedStatement prst = null;
   		if (action != null && action.equals("Search products")) {
   			// Show products that match the search
   			try {
   	   			prst = conn.prepareStatement(
   	   					"SELECT * " +
   	   					"FROM products " +
   	   					"WHERE name LIKE ?");
   	   			
   	   			System.out.println("'%"+request.getParameter("search").trim()+"%'");
   	   			prst.setString(1, "%"+request.getParameter("search").trim()+"%");
   	   			
   	   			rsProducts = prst.executeQuery();
   	   			conn.commit();
   			} catch (Exception e) {
   				e.printStackTrace();
   			}

  		} else if (action != null && action.startsWith("filter_")) {
  			// Show products that match the selected category
  			try {
  	  			prst = conn.prepareStatement(
  	  					"SELECT * " +
  	  					"FROM products " +
  	  					"WHERE category=?;");
  	  			
  	  			prst.setString(1, action.substring("filter_".length()));
  	  			
  	  			rsProducts = prst.executeQuery();
  				conn.commit();
  			} catch (Exception e) {
				e.printStackTrace();
  			}
  		} else {
  			// Show all products
  			try {
  				prst = conn.prepareStatement(
  						"SELECT * " +
  						"FROM products;");
  				
  				rsProducts = prst.executeQuery();
  				conn.commit();
  			} catch (Exception e) {
  				e.printStackTrace();
  			}
  		}
   		
       	while (rsProducts.next()) {
       		String productID = rsProducts.getString("id");
       		String productName = rsProducts.getString("name");
        	String productSKU = rsProducts.getString("sku");
        	String productCategory = rsProducts.getString("category");
        	String productPrice = rsProducts.getString("price");
        	
        	%>
        	<tr>
	        	<td>
	        		<a href="ProductOrder.jsp" name="product" value=<%=productName%>><%=productName%>
	        	</td>
	       		<td><%=productSKU%></td>
	       		<td><%=productCategory%></td>
	       		<td><%=productPrice%></td>
        	</tr>
        	<%
       	}
       	rsProducts.close();
       	prst.close();
       	
   	%>
   	</table>
</div>
</div>
<%
conn.close();
%>
</body>
</html>