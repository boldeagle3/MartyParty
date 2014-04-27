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
	
	if (session.getAttribute("productsSearch") == null) {
			session.setAttribute("productsSearch", "");
	}

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
				
				PreparedStatement prst0 = conn.prepareStatement(
						"DELETE FROM products " +
						"WHERE id=?;");
				prst0.setInt(1, Integer.valueOf(id));
				prst0.execute();
				PreparedStatement prst = conn.prepareStatement(
						"INSERT INTO products (name,sku,category,price) " +
	        			"VALUES (?,?,?,?);");
				/* PostgreSQL has some problem updating with unique constraint?		
						"BEGIN " +
						"UPDATE products " +
						"SET name=?,sku=?,category=?,price=? " +
						"FROM (SELECT * FROM products ORDER BY id DESC) " +
						"WHERE products.id=id " +
						"END;");
				*/
				prst.setString(1, newName);
				prst.setString(2, newSKU);
				prst.setString(3, newCategory);
				prst.setFloat(4, newPrice);
				
				prst0.execute();
				prst.execute();
				conn.commit();
				prst0.close();
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
<%if(session.getAttribute("role") != null && session.getAttribute("role").equals("owner")) {%>
<%@include file="header.jsp" %>
<div id="columns">
<div id="left_column">
	<form action="products_management.jsp" method="post">
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
    			<form action="products_management.jsp" method="post">
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
   		<form action="products_management.jsp" method="post">
   		<tr>
  			<td><input type="text" name="new_name" required /></td>
            <td><input type="text" name="new_sku" required /></td>
            <td><select id="category" name="new_category" required >
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
	               		<option value="<%=categoryName%>"><%=categoryName%>
	               		<%
	               	}
	               	
	               	rsCategories.close();
	               	prst.close();
            	} catch (Exception e) {
            		e.printStackTrace();
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
	        	<form action="products_management.jsp" method="post">
	        	<td><input type="text" name="new_name" value="<%=productName%>" required></td>
	       		<td><input type="text" name="new_sku" value="<%=productSKU%>" required></td>
	       		<td><select id="category" name="new_category" required>
	            	<%
	            	try {
		            	PreparedStatement prst2 = conn.prepareStatement(
		        				"SELECT name " +
		        	        	"FROM category;",
		        	        	ResultSet.TYPE_SCROLL_INSENSITIVE,
		        	        	ResultSet.CONCUR_READ_ONLY);
		            	
		        		ResultSet rsCategories = prst2.executeQuery();
		            	conn.commit();
		            	
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
	           		} catch (Exception e) {
	           			e.printStackTrace();
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
       	if (rsProducts != null && prst != null) {
       		rsProducts.close();
       		prst.close();
       	}
   	%>
   	</table>
</div>
</div>
<%
conn.close();
} else {%>
	<script type="text/javascript">
    	window.onload = function(){
    		document.location.href = "error.jsp";
    	}
    </script>
	<%
}
%>
</body>
</html>