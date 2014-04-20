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
					Connection conn = null;
					conn = DriverManager.getConnection(
					"jdbc:postgresql://localhost:5432/postgres", "postgres", "password");

            %>

			      
            <%-- -------- SELECT Statement Code -------- --%>
           






</head>
<body>


<%
    if ((session.getAttribute("id") == null) || (session.getAttribute("") == "")) {
%>
You are not logged in<br/>
<%} else {
%>
Welcome <%=session.getAttribute("name")%>,<%=session.getAttribute("role")%>
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