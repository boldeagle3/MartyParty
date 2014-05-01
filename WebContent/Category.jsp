<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@include file="header.jsp" %>
<%

try {                 
                    Class.forName("org.postgresql.Driver");
					Connection conn = null;
					conn = DriverManager.getConnection(
					"jdbc:postgresql://localhost:5432/postgres", "postgres", "password");
					conn.setAutoCommit(false);
                  

            %>

            <%
            String action=request.getParameter("action");
            if(session.getAttribute("role")==null||session.getAttribute("role").equals("customer")){
            	response.sendRedirect("error.jsp");
            }
            if(request.getParameter("namebox") != null &&request.getParameter("namebox").contains("\"")){
            	%>that wont work here<% 
            }
            if (action != null && action.equals("insert")&&!request.getParameter("namebox").contains("\"")) {
            	
            	try{
            	System.out.println("gets into the intial part");
            	conn.setAutoCommit(false);
            	PreparedStatement pstmt =conn.prepareStatement(
            			"INSERT INTO category(name,description) VALUES(?,?)");
            	pstmt.setString(1,request.getParameter("namebox").trim());
            	pstmt.setString(2,request.getParameter("dbox"));
            	int rowCount= pstmt.executeUpdate();
            	conn.commit();
            	}
            	catch(SQLException e){
            		%>name or description error<%
            	
            	}
            }
            
            String deletion=request.getParameter("delete");
             if (deletion != null) {
            	 try{
            	System.out.println("gets into the intial part delete "+request.getParameter("delete"));
            	PreparedStatement ps =conn.prepareStatement(
            			"SELECT * FROM products WHERE category=?");
            	ps.setString(1,request.getParameter("delete").trim());
            	ResultSet rq=ps.executeQuery();
            	if(!rq.next()){          	
            	PreparedStatement pstmt =conn.prepareStatement(
            			"DELETE FROM category WHERE category.name= ?");
            	pstmt.setString(1,request.getParameter("delete").trim());
            	int rowCount= pstmt.executeUpdate();
            
            	}
            	else{
            		%>You can not delete <%=request.getParameter("delete").trim()%><%
            	}
            	conn.commit();
            	 }catch(SQLException e){
            		 %>SQL delete problem <%
            	
            	 }
            }
            
             String update=request.getParameter("update");
             if (update != null) {
            	 try{
            	System.out.println("gets into the intial part update"+request.getParameter("nameboxup"));
            	PreparedStatement pstmt =conn.prepareStatement(
            			"UPDATE category SET description=? WHERE category.name=?");
            	pstmt.setString(1,request.getParameter("dboxup"));
            	pstmt.setString(2,request.getParameter("update").trim());
            	int rowCount= pstmt.executeUpdate();
            	conn.commit();
            	 }
            	 catch(SQLException e){
            		 %>Description too long<%
            	
            	}
            }
             conn.setAutoCommit(true);
            %>
<title>Insert title here</title>
</head>
<body>
	<% 
	if(session.getAttribute("role") != null && session.getAttribute("role").equals("owner")) {
		System.out.println("gets into here");
	%>
	<div style = "text-align:center">Insert</div>
	<table>
	<tr>
	<form method="POST" action="Category.jsp">
	<input type="hidden" name="action" value="insert">
	<td><input type="text" name="namebox" placeholder="name" required></td>
	<td><textarea name="dbox" rows="1" cols="20" placeholder="description"></textarea></td>
	<!-- <input type="text" name="dbox"> -->
	<td><button type="submit">Insert</button></td>
	</tr>	
	</form>
	</table>
	<!--
	<form method="POST" action="Category.jsp">
	<input type="hidden" name="action" value="delete">
	<input type="text" name="nameboxde">
	<button type="submit">Delete</button>
	</form>-->
	<!--  
	<form method="POST" action="Category.jsp">
	<input type="hidden" name="action" value="update">
	<input type="text" name="nameboxup">
	<input type="text" name="dboxup">
	<button type="submit">Update</button>
	</form>-->
	<%} %>
	<table border="3">
	<tr>
		<th>name</th>
		<th>description</th>
	</tr>
	<% 
		ResultSet rs=null;
		Statement statement=conn.createStatement();
		rs=statement.executeQuery("SELECT * FROM category");
		while(rs.next()){
			String name=rs.getString("name");
			%>
			<tr>
			<td><%=rs.getString("name") %></td>
			<td><%=rs.getString("description") %></td>
			<td>	
			<%
			PreparedStatement ps =conn.prepareStatement(
            			"SELECT * FROM products WHERE category=?");
            	ps.setString(1,rs.getString("name"));
            	ResultSet rq=ps.executeQuery();
            	if(!rq.next()){%>
			<form method="POST" action="Category.jsp">
			<input type="hidden" name="delete" value="<%=rs.getString("name")%>">
			<button type="submit">Delete</button>
			</form>
			<%}
			%>
				
			</td>
			<td>
				<form method="POST" action="Category.jsp">
				<input type="hidden" name="update" value="<%=rs.getString("name")%>">
				<input type="text" name="dboxup">
				<button type="submit">Update</button>
				</form>
			</td>
			</tr>
			
			<% 
		}
	%>
	<!-- loop through and add all categories -->
	</table>
	<%
conn.setAutoCommit(true);
 conn.close();
} catch (SQLException sqle) {
    out.println(sqle.getMessage());
} catch (Exception e) {
    out.println(e.getMessage());
}
%>
</body>
</html>