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
	
	if (session.getAttribute("productsSearch") == null) {
			session.setAttribute("productsSearch", "");
	}

	String action = request.getParameter("action");
	if (action != null) {
		Statement st = conn.createStatement();
	}
	%>
</head>
<body>
<%@include file="header.jsp" %>
<div id="columns">
<div id="left_column">
	<form action="products_browsing.jsp" method="post">
		<input type="radio" name="action" value="all_categories" onclick="this.form.submit();">All Categories
	   	<br>
		<%
    	try {
    		PreparedStatement prst = conn.prepareStatement(
    				"SELECT name " +
    	        	"FROM category;",
    	        	ResultSet.TYPE_SCROLL_INSENSITIVE,
    	        	ResultSet.CONCUR_READ_ONLY);
        	
    		ResultSet rsCategories = prst.executeQuery();
        	conn.commit();
        
    	    while (rsCategories.next()) {
   	    		String categoryName = rsCategories.getString("name");
    		    %>
    	    	<input type="radio" name="action" value="filter_<%=categoryName%>" onclick="this.form.submit();"><%=categoryName%>
    	    	<br>
    	    	<%
        	}
    	    
    	    rsCategories.close();
    	    prst.close();
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
                <input id="searchField" type="text" name="search" />
                <input type="submit" name="action" value="Search products">
           		</form>
           		<script type="text/javascript">
           			document.getElementById("searchField").value = "<%=session.getAttribute("productsSearch").toString()%>";
           		</script>
   			</td>
   		</tr>
   		<tr>
   			<td>Name</td><td>SKU</td><td>Category</td><td>Price</td>
   		</tr>
   		<%
       	ResultSet rsProducts = null;
   		PreparedStatement prst = null;
   		if (action != null && action.equals("Search products")) {
   			// Show products that match the search
   			try {
   				if (null != session.getAttribute("productsCategory")) {
   	   	   			prst = conn.prepareStatement(
   	   	   					"SELECT * " +
   	   	   					"FROM products " +
   	   	   					"WHERE name LIKE ? " +
   	   	   							"AND category=?;");
   	   	   			
   	   	   			prst.setString(1, "%"+request.getParameter("search").trim()+"%");
   	   	   			prst.setString(2, session.getAttribute("productsCategory").toString());
   				} else {
   	   	   			prst = conn.prepareStatement(
   	   	   					"SELECT * " +
   	   	   					"FROM products " +
   	   	   					"WHERE name LIKE ?");
   	   	   			
   	   	   			prst.setString(1, "%"+request.getParameter("search").trim()+"%");
   				}
   	   			
   	   			rsProducts = prst.executeQuery();
   	   			conn.commit();
   	   			
   	   			session.setAttribute("productsSearch", request.getParameter("search").trim());
   	   			%>
   	   			<script type="text/javascript">
	   			document.getElementById("searchField").value = "<%=session.getAttribute("productsSearch").toString()%>";
	   			</script>
   	   			<%
   			} catch (Exception e) {
   				e.printStackTrace();
   			}

  		} else if (action != null && action.startsWith("filter_")) {
  			// Show products that match the selected category
  			try {
  	  			prst = conn.prepareStatement(
  	  					"SELECT * " +
  	  					"FROM products " +
  	  					"WHERE category=? " +
  	  							"AND name LIKE ?;");
  	  			
  	  			prst.setString(1, action.substring("filter_".length()));
  	  			prst.setString(2, "%"+session.getAttribute("productsSearch").toString()+"%");
  	  			
  	  			rsProducts = prst.executeQuery();
  				conn.commit();
  				
  				session.setAttribute("productsCategory",action.substring("filter_".length()));
  			} catch (Exception e) {
				e.printStackTrace();
  			}
  		} else {
  			// Show all products
  			try {
  				if (action == null || action.equals("all_categories")) {
  					session.setAttribute("productsCategory", null);
  					
  					prst = conn.prepareStatement(
	  						"SELECT * " +
	  						"FROM products " +
	  						"WHERE name LIKE ?;");
  					
  					prst.setString(1, "%"+session.getAttribute("productsSearch").toString()+"%");
  				} else {
	  				if (null != session.getAttribute("productsCategory")) {
	  					prst = conn.prepareStatement(
		  						"SELECT * " +
		  						"FROM products " +
		  						"WHERE category=? " +
  	  									"AND name LIKE ?;");
	  					prst.setString(1, session.getAttribute("productsCategory").toString());
	  					prst.setString(2, "%"+session.getAttribute("productsSearch").toString()+"%");
	  				} else {
		  				prst = conn.prepareStatement(
		  						"SELECT * " +
		  						"FROM products;");
	  				}
  				}
  				rsProducts = prst.executeQuery();
  				conn.commit();
  			} catch (Exception e) {
  				e.printStackTrace();
  			}
  		}
   		
       	while (rsProducts != null && rsProducts.next()) {
       		String productID = rsProducts.getString("id");
       		String productName = rsProducts.getString("name");
        	String productSKU = rsProducts.getString("sku");
        	String productCategory = rsProducts.getString("category");
        	String productPrice = rsProducts.getString("price");
        	
        	%>
        	<tr>
        		<form action="ProductOrder.jsp" method="GET">
        		<input type="hidden" name="product" value="<%=productID%>">
	        	<td><button type="submit" name="productID" value="<%=productID%>" onclick="this.form.submit();"><%=productName%></td>
	       		<td><%=productSKU%></td>
	       		<td><%=productCategory%></td>
	       		<td><%=productPrice%></td>
	       		</form>
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