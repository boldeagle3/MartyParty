<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="UTF-8">
<title>Products page</title>
<link rel="stylesheet" type="text/css" href="products_management.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script>
	$(document).ready(function () {
		$("#new_product_button").click(function () {
			$("#new_product_form").slideToggle("fast");
		});
	});
</script>
</head>

<body>
<div id="columns">
<div id="left_column">
    Categories
    <!-- load categories -->
</div>

<div id="right_column">
	<div id="right_top">
    <table>
    <tr>
    	<td>
            <form>
                <input type="text" name="search" />
                <input type="submit" class="button" value="Search products">
            </form>
        </td>
        <td>
        	<input type="button" id="new_product_button" class="button" value="Submit a new product" />
        </td>
    </tr>
    </table>
    <form id="new_product_form">
        <table>
        <tr>
        	<td>Name:</td>
            <td><input type="text" name="name" /></td>
        </tr>
        <tr>
            <td>SKU:</td>
            <td><input type="text" name="sku" /></td>
        </tr>
        <tr>
            <td>Category:</td>
            <td><select id="category" name="category"></select></td>
        </tr>
        <tr>
            <td>Price:</td>
            <td><input type="text" name="price" /></td>
        </tr>
        </table>
        <input type="submit" class="button" value="Submit product" />
    </form>
    </div>
    <div id="right_bot">
    	products be here
    </div>
</div>
</div>
</body>
</html>