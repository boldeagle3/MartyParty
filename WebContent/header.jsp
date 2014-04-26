<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!doctype html>
<html>
<head>
<link rel="stylesheet" href="css/main.css" type="text/css" title = "normal" />

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {                 
                    Class.forName("org.postgresql.Driver");
					Connection conn1 = null;
					conn1 = DriverManager.getConnection(
					"jdbc:postgresql://localhost:5432/postgres", "postgres", "password");

            %>

			      
            <%-- -------- SELECT Statement Code -------- --%>
           






</head>
<body>
<header>
<a href = "index.jsp"> 
<img src = "img/art.gif" alt = "logo" > </a>

<%
    if ((session.getAttribute("id") == null) || (session.getAttribute("id") == "")) {
%>
<span style = "display:inline;position:absolute;top:0px;">
You are not logged in</span>

<span >
<a href = "products_browsing.jsp"><span style = "display: inline-block;margin-left: auto; margin-right: auto;font-size:40px;">Check out our fabulous products!!!!</span></a>
</span>

<div style = "float: right;display: inline-block;">
<a href = registration.jsp>Registration</a> | <a href = login.jsp>Login</a>&nbsp;
</div>
<%} else {
%>
<span style = "display:inline;position:absolute;top:0px;">
Welcome <%=session.getAttribute("name")%>
</span>
<span >
<a href = "products_browsing.jsp"><span style = "display: inline-block;margin-left: auto; margin-right: auto;font-size:40px;">Check out our fabulous products!!!!</span></a>
</span>
<div style = "float: right;display:inline">
<%if(session.getAttribute("role").equals("owner"))
{%>

<a href = Category.jsp>Category Edit</a> | <a href = products_management.jsp>Products Edit</a> | 
<% }%>
<a href = ShoppingCart.jsp>Your Cart</a> | <a href = logout.jsp>Logout </a>&nbsp;
</div>
<%
  } %>

	    <div style="display: block; clear: both;"></div> 
	    </header>
	    
<hr>
<%
                } catch (SQLException sqle) {
    out.println("sqlexception: " + sqle.getMessage());
} catch (Exception e) {
    out.println("exception: " + e.getMessage());
}
%>

</body>