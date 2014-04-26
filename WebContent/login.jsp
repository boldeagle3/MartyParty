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


			           <%
                    String action = request.getParameter("action");
			          int login = 0;
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {
					Statement st = conn.createStatement();

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
						String name = request.getParameter("name");
                        ResultSet rs = st.executeQuery("select * from users where name='" + name + "'");
    
	
						if (rs.next()) {
						session.setAttribute("id",rs.getInt("id"));
						session.setAttribute("name",rs.getString("name"));
						session.setAttribute("role",rs.getString("role"));
						login = 1;
					} else {
						login = 2;
						
					}
                                 

                        
                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }

       
       %>      
       
       
            <%
                    if ( login == 1){
                    %>
                  <script type="text/javascript">
          		window.onload = function(){
              document.location.href = "index.jsp";

          }
          	</script>    
          	<%} 
            if ( login == 2){
                %>
              <script type="text/javascript">
      		window.onload = function(){
      		    alert("User Name not found");

      }
      	</script>    
      	<%} %>
            <%-- -------- SELECT Statement Code -------- --%>
           
<title> Login </title>

<script>



</script>

<link rel="stylesheet" href="css/main.css" type="text/css" title = "normal" />

</head>
<body>

<%@include file="header.jsp" %>

<div style = "background-image:url('img/happy.jpg');background-size:100%;background-repeat:no-repeat;";>
<h1> PUT YOUR NAME IN HERE </h1>


<form action = "login.jsp" method = "post">
<input type = "hidden" value = "insert" name = "action">
<table>
	<tr>
		<th>Name</th>
	</tr>

<tr>
<th>
		<input type = "text" name = "name" id = "name"> 
	</th>
	<th>

<th>
	<input type = "submit" name = "save" id = "save" value = "Login">
</th>

</tr>
</form>
</table>

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>



</div>

            <%

                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
            
</body>
</html>








