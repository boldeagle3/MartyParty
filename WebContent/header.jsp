<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!doctype html>
<html>
<head>
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


<%
    if ((session.getAttribute("id") == null) || (session.getAttribute("id") == "")) {
%>
You are not logged in
<div style = "float: right;display:inline">
<a href = registration.jsp>Registration</a> | <a href = login.jsp>Login</a>
</div>
<%} else {
%>
Welcome <%=session.getAttribute("name")%>
<div style = "float: right;display:inline">
<a href = logout.jsp>Logout</a>
</div>
<br>
<%
    }
	} catch (SQLException sqle) {
    out.println("sqlexception: " + sqle.getMessage());
} catch (Exception e) {
    out.println("exception: " + e.getMessage());
}
%>

</body>