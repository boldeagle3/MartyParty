<%@page import="org.postgresql.util.PSQLException"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="UTF-8">
<title>Products page</title>
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
		if (action.equals("new_product")) {	// Submit a new product
			%>
			<script type="text/javascript">
			<%
			String newName = request.getParameter("new_name").trim();
			String newSKU = request.getParameter("new_sku").trim();
			String newCategory = request.getParameter("new_category").trim();
			String newPrice = request.getParameter("new_price").trim();
			
			Statement st = conn.createStatement();

	        conn.setAutoCommit(false);
	        try {
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
	        	// TODO product already exists
	        	e.printStackTrace();
	        }
            conn.commit();
            conn.setAutoCommit(true);
		} else if (action.equals("all_categories")) {
			System.out.println("allcategories");
		} else if (action.equals("filter")) {
			System.out.println("filter");
		}
	}
	%>
</head>

<body>
<div id="columns">
<div id="left_column">
    Categories
	<form action="products_management.jsp" method="post">
   		<input type="radio" name="action" value="all_categories" onclick="this.form.submit();">All Categories<br>
    <%
    
    Statement st = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

    conn.setAutoCommit(false);
    
    ResultSet rs = st.executeQuery("SELECT name FROM category");
    
    if (rs.first()) {
    	String categoryName = rs.getString("name");
    	%>
    	<input type="radio" name="action" value="filter_<%=categoryName%>" onclick="this.form.submit();"><%=categoryName%><br>
    	<%
    	while (rs.relative(1)) {
    		categoryName = rs.getString("name");
        	%>
    		<input type="radio" name="action" value="filter_<%=categoryName%>" onclick="this.form.submit();"><%=categoryName%><br>
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
    <form id="new_product_form" action="products_management.jsp" method="post">
   		<input type="hidden" name="action" value="new_product">
        <table>
        <tr>
        	<td>Name:</td>
            <td><input type="text" name="new_name" /></td>
        </tr>
        <tr>
            <td>SKU:</td>
            <td><input type="text" name="new_sku" /></td>
        </tr>
        <tr>
            <td>Category:</td>
            <td>
            	<select id="category" name="new_category">
            	<%
            	Statement stc = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

                conn.setAutoCommit(false);
                
                ResultSet rsc = stc.executeQuery("SELECT name FROM category");
                
                if (rsc.first()) {
                	String categoryName = rsc.getString("name");
                	%>
                	<option value="<%=categoryName%>"><%=categoryName%>
                	<%
                	while (rsc.relative(1)) {
                		categoryName = rsc.getString("name");
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
            <td>Price:</td>
            <td><input type="text" name="new_price" /></td>
        </tr>
        </table>
        <input type="submit" class="button" value="Submit a new product" />
    </form>
    </div>
    <div id="right_bot">
    	<table id="products_table">
    	<%
    	if (action != null && !action.equals("all_categories")) {
    		if (action.equals("search_product")) {	// Search for a product
    			String search = request.getParameter("search");
    			
    			Statement sts = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

    	        conn.setAutoCommit(false);
    	        
    	        ResultSet rss = st.executeQuery("SELECT * FROM products WHERE name LIKE '%" + search + "%';");

    	        if (rss.first()) {
    	    	   	String productName = rss.getString("name");
    	        	String productSKU = rss.getString("sku");
    	        	String productCategory = rss.getString("category");
    	        	String productPrice = rss.getString("price");
    	        	
    	        	System.out.println(productName+productSKU+productCategory+productPrice);
    	        	
    	        	// TODO display product information
    	        	
    	        	while (rss.relative(1)) {
    	        		productName = rss.getString("name");
    		        	productSKU = rss.getString("sku");
    		        	productCategory = rss.getString("category");
    		        	productPrice = rss.getString("price");
    	        		
    		        	// TODO display product information
    	        	}
    	        } else {
    	        	// TODO: no results
    	        }
    	        
                conn.commit();
                conn.setAutoCommit(true);
    		} else if (action.startsWith("filter_")) {	// Filter by category
    	
    		}
    	} else {
    		// show all products
    		
    	}
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