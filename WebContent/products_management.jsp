<%@page import="org.postgresql.util.PSQLException"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="UTF-8">
<title>Products Management</title>
<link rel="stylesheet" type="text/css" href="products_management.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<%
	Class.forName("org.postgresql.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection(
	"jdbc:postgresql://localhost:5432/postgres", "postgres", "password");

	String action = request.getParameter("action");
	System.out.println("action="+action);
	if (action != null) {
		Statement st = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        conn.setAutoCommit(false);
        
		if (action.equals("new_product")) {	// Submit a new product
	        try {
				%>
				<script type="text/javascript">
				<%
	        	String newName = request.getParameter("new_name").trim();
				String newSKU = request.getParameter("new_sku").trim();
				String newCategory = request.getParameter("new_category").trim();
				String newPrice = request.getParameter("new_price").trim();
		        st.execute("INSERT INTO products (name,sku,category,price) VALUES ('" +
		        			newName + "','" +
		        			newSKU + "','" +
		        			newCategory + "','" + 
		        			newPrice + "');"
		        );
		        %>
	            alert("Successfully submitted a new product:"+
	            	"\nname: <%=newName%>" +
	            	"\nsku: <%=newSKU%>" +
	            	"\ncategory: <%=newCategory%>" +
	            	"\nprice: <%=newPrice%>"
	            );
	            </script>
	            <%
	        } catch (PSQLException e) {
	        	e.printStackTrace();
	        }
		} else if (action.equals("Update")) {
			// TODO
			/*
			st.execute(
					"UPDATE products " +
					"SET " +
					"WHERE" +
					";"
			);
			*/
		} else if (action.equals("Delete")) {
			try {
				String newName = request.getParameter("new_name").trim();
				String newSKU = request.getParameter("new_sku").trim();
				String newCategory = request.getParameter("new_category").trim();
				String newPrice = request.getParameter("new_price").trim();
				st.execute(
						"DELETE FROM products " +
						"WHERE name = '" + newName + "' " +
								"AND sku = '" + newSKU + "'" +
								"AND category = '" + newCategory + "'" +
								"AND price = '" + newPrice + "'" +
						";"
				);
				
			} catch (PSQLException e) {
				e.printStackTrace();
			}
		}
		conn.commit();
        conn.setAutoCommit(true);
	}
	%>
</head>
<body>
<div id="columns">
<div id="left_column">
	<form action="products_management.jsp" method="post">
   		<input type="radio" name="action" value="all_categories" onclick="this.form.submit();">All Categories
   		<br>
    	<%
		Statement st = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	    conn.setAutoCommit(false);   
	    ResultSet rsCategories = st.executeQuery("SELECT name FROM category;");
    
    	if (rsCategories.first()) {
	    	String categoryName = rsCategories.getString("name");
	    %>
    	<input type="radio" name="action" value="filter_<%=categoryName%>" onclick="this.form.submit();"><%=categoryName%>
    	<br>
    	<%
	    	while (rsCategories.next()) {
	    		categoryName = rsCategories.getString("name");
	    %>
    	<input type="radio" name="action" value="filter_<%=categoryName%>" onclick="this.form.submit();"><%=categoryName%>
    	<br>
    	<%
    		}
    	%>
    </form>
    <%
    	} else {
    		System.out.println("no categories");
    	}
    	conn.commit();
    	conn.setAutoCommit(true);
    %>
</div>
<div id="right_column">
	<div id="right_top">
    <table>
    <tr>
    	<td>
            <form action="products_management.jsp" method="post">
            	<input type="hidden" name="action" value="search_product">
                <input type="text" name="search" />
                <input type="submit" class="button" value="Search products">
            </form>
        </td>
    </tr>
    </table>
    <%
    try {
    %>
    <form id="new_product_form" action="products_management.jsp" method="post">
   		<input type="hidden" name="action" value="new_product">
        <table>
	        <tr>
	        	<td>Name:</td><td><input type="text" name="new_name" required /></td>
	        </tr>
	        <tr>
	            <td>SKU:</td><td><input type="text" name="new_sku" required /></td>
	        </tr>
	        <tr>
	            <td>Category:</td>
	            <td>
	            	<select id="category" name="new_category">
	            	<%
	                if (rsCategories.first()) {
	                	String categoryName = rsCategories.getString("name");
	                %>
	                	<option value="<%=categoryName%>"><%=categoryName%>
	                	<%
	                	while (rsCategories.next()) {
	                		categoryName = rsCategories.getString("name");
	                    %>
	                	<option value="<%=categoryName%>"><%=categoryName%>
	                	<%
	                	}
	                }
	                	%>
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <td>Price:</td><td><input type="text" name="new_price" required /></td>
	        </tr>
        </table>
        <input type="submit" class="button" value="Submit a new product" />
    </form>
    <%
    } catch(Exception e) {
    	// TODO handle exception
    }
    %>
    </div>
    <div id="right_bot">
    	<table id="products_table">
    		<tr>
    			<td>Name</td><td>SKU</td><td>Category</td><td>Price</td>
    		</tr>
    		<%
	    	//Statement sts = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	        conn.setAutoCommit(false);
        	ResultSet rs;
	   		if (action != null && action.equals("search_product")) {	// Search for a product
	   			String search = request.getParameter("search");
	   	        rs = st.executeQuery(
	   	        		"SELECT * " +
	   	        		"FROM products " +
	   	        		"WHERE name LIKE '%" + search + "%';"
	   			);
   			} else if (action != null && action.startsWith("filter_")) {	// Filter by category
	   	        String theCategory = action.substring("filter_".length());
   				System.out.println(theCategory);
	   	        rs = st.executeQuery(
	   	        		"SELECT * " +
	   	        		"FROM products " +
	   	        		"WHERE category = '" + theCategory + "'" +
	   	        		";"
	   	        );
   			} else {	// Show all products
	    		rs = st.executeQuery(
	    				"SELECT * " +
	    				"FROM products" +
	    				";"
	    		);
   			}
	   		
    		if (rs.first()) {
 	    	   	String productName = rs.getString("name");
 	        	String productSKU = rs.getString("sku");
 	        	String productCategory = rs.getString("category");
 	        	String productPrice = rs.getString("price");
 	        	%>
 	        	<tr>
 	        		<form action="products_management.jsp" method="post">
	 	        		<td><input type="text" name="new_name" value="<%=productName%>"></td>
	 	        		<td><input type="text" name="new_sku" value="<%=productSKU%>"></td>
	 	        		<td><input type="text" name="new_category" value="<%=productCategory%>"></td>
	 	        		<td><input type="text" name="new_price" value="<%=productPrice%>"></td>
	 	        		<td><input type="submit" name="action" value="Update"></td>
	 	        		<td><input type="submit" name="action" value="Delete"></td>
 	        		</form>
 	        	</tr>
 	        	<%
 	        	while (rs.next()) {
 	        		productName = rs.getString("name");
 		        	productSKU = rs.getString("sku");
 		        	productCategory = rs.getString("category");
 		        	productPrice = rs.getString("price");
 		        	%>
 	 	        	<tr>
 	 	        		<td><input type="text" name="new_name" value="<%=productName%>"></td>
	 	        		<td><input type="text" name="new_sku" value="<%=productSKU%>"></td>
	 	        		<td><input type="text" name="new_category" value="<%=productCategory%>"></td>
	 	        		<td><input type="text" name="new_price" value="<%=productPrice%>"></td>
	 	        		<td><input type="submit" name="action" value="Update"></td>
	 	        		<td><input type="submit" name="action" value="Delete"></td>
 	 	        	</tr>
 	 	        	<%
 	        	}
    		}
    		
    		conn.commit();
        	conn.setAutoCommit(true);
    	%>
    	</table>
    </div>
</div>
</div>
<%
conn.close();
%>
</body>
</html>