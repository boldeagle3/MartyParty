<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" language="java" import="java.sql.*" %>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="UTF-8">
<title>Products Management</title>
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

	String action = request.getParameter("action");
	if (action != null) {
		Statement st = conn.createStatement();
        
		if (action.equals("Insert a new product")) {
			// Insert a new product
	        try {
				%>
				<script type="text/javascript">
				<%
	        	String newName = request.getParameter("new_name");
				String newSKU = request.getParameter("new_sku");
				String newCategory = request.getParameter("new_category");
				Float newPrice = Float.valueOf(request.getParameter("new_price"));
				
	        	PreparedStatement prst = conn.prepareStatement(
	        			"INSERT INTO products (name,sku,category,price) " +
	        			"VALUES (?,?,?,?);");
	        	
				prst.setString(1,newName);
				prst.setString(2,newSKU);
				prst.setString(3,newCategory);
				prst.setFloat(4,newPrice);
				
				prst.execute();
				conn.commit();
				prst.close();
		        %>
	            alert("Successfully inserted a new product:" +
	            		"\nname: <%=newName%>" +
	            		"\nsku: <%=newSKU%>" +
	            		"\ncategory: <%=newCategory%>" +
	            		"\nprice: <%=newPrice%>");
	            </script>
	            <%
	        } catch (Exception e) {
	        	e.printStackTrace();
	        }
		} else if (action.equals("Update")) {
			// Update a product
			try {
				String id = request.getParameter("id");
				String newName = request.getParameter("new_name");
				String newSKU = request.getParameter("new_sku");
				String newCategory = request.getParameter("new_category");
				float newPrice = Float.parseFloat(request.getParameter("new_price"));
				
				PreparedStatement prst = conn.prepareStatement(
						"BEGIN; " +
						"UPDATE products " +
						"SET name=?,sku=?,category=?,price=? " +
						"WHERE products.id=id; " +
						"COMMIT;");
				
				prst.setString(1, newName);
				prst.setString(2, newSKU);
				prst.setString(3, newCategory);
				prst.setFloat(4, newPrice);
				
				prst.execute();
				conn.commit();
				prst.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (action.equals("Delete")) {
			// Delete a product
			try {
				String id = request.getParameter("id");
				
				PreparedStatement prst = conn.prepareStatement(
						"DELETE FROM products " +
						"WHERE id=?;");
				prst.setInt(1, Integer.parseInt(id));
				
				prst.execute();
				conn.commit();
				prst.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	%>
</head>
<body>
<%@include file="header.jsp" %>
<div id="columns">
<div id="left_column">
	<form action="products_management.jsp" method="post">
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
    			<form action="products_management.jsp" method="post">
                <input type="text" name="search" />
                <input type="submit" name="action" value="Search products">
           		</form>
   			</td>
   		</tr>
   		<tr>
   			<td>Name</td><td>SKU</td><td>Category</td><td>Price</td>
   		</tr>
   		<form action="products_management.jsp" method="post">
   		<tr>
  			<td><input type="text" name="new_name" required /></td>
            <td><input type="text" name="new_sku" required /></td>
            <td><select id="category" name="new_category" required >
            	<%
            	if (rsCategories.first()) {
            		String categoryName = rsCategories.getString("name");
	                %>
	               	<option value="<%=categoryName%>"><%=categoryName%>
	               	<%
            	}
               	while (rsCategories.next()) {
               		String categoryName = rsCategories.getString("name");
                %>
               	<option value="<%=categoryName%>"><%=categoryName%>
               	<%
               	}
               	%>
                </select>
            </td>
            <td><input type="text" name="new_price" required /></td>
            <td>
            	<input type="submit" name="action" value="Insert a new product" />
            </td>
        </tr>
        </form>
   		<%
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
	        	<form action="products_management.jsp" method="post">
	        	<td><input type="text" name="new_name" value="<%=productName%>" required></td>
	       		<td><input type="text" name="new_sku" value="<%=productSKU%>" required></td>
	       		<td><select id="category" name="new_category" required>
	            	<%
	            	if (rsCategories.first()) {
	            		String categoryName = rsCategories.getString("name");
	            		if (productCategory.equals(categoryName)) {
	            			%>
	            			<option value="<%=categoryName%>" selected><%=categoryName%></option>
	            			<%	
	            		} else {
		               		%>
		               		<option value="<%=categoryName%>"><%=categoryName%></option>
		               		<%
	            		}
	            	}
	               	while (rsCategories.next()) {
	            		String categoryName = rsCategories.getString("name");
	            		if (productCategory.equals(categoryName)) {
	            			%>
	            			<option value="<%=categoryName%>" selected><%=categoryName%></option>
	            			<%	
	            		} else {
		                	%>
		               		<option value="<%=categoryName%>"><%=categoryName%></option>
		               		<%
	            		}
	               	}
	            	%>
	                </select>
	       		</td>
	       		<td><input type="text" name="new_price" value="<%=productPrice%>" required></td>
	       		<td>
	       			<input type="hidden" name="id" value="<%=productID%>">
	       			<input type="submit" name="action" value="Update">
	       			<input type="submit" name="action" value="Delete">
	       		</td>
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