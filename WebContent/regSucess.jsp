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

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO users(name, role, age,state) VALUES (?, ?, ?, ?)");                       					
								
                        pstmt.setString(1, request.getParameter("name"));
                        pstmt.setString(2, request.getParameter("role"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("age")));
                        pstmt.setString(4, request.getParameter("state"));
                                 

                        int rowCount = pstmt.executeUpdate();
                        
                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }

    
       
       %>            

<%-- -------- UPDATE Code --------------------------------------------------------------- --%>
    
<title> Registered </title>

<script>



</script>

<style type="text/css">
body {
	font-family:"webfontregular";
	margin: 0;
	padding: 0;
	font-size:18px;
}

/* Using the font used in The Prisoner (1968) */
@font-face {
    font-family: 'webfontregular';
          src: url('css/Fonts/village-webfont.eot');
		src: url('css/Fonts/village-webfont.eot?#iefix') format('embedded-opentype'),
         url('css/Fonts/village-webfont.woff') format('woff'),
         url('css/Fonts/village-webfont.ttf') format('truetype'),
         url('css/Fonts/village-webfont.svg#webfontregular') format('svg');
    font-weight: normal;
    font-style: normal;

}

h1, h2, h3, h4, h5, h6 {
	text-align:center;
}

h1{
margin:0;
padding-top:15px;
padding-bottom:15px;

}

table{
margin:0 auto; 

}

header{
background-color:#E0E0E0;

}

hr{
margin-top:0;

}

th{
padding-left:40px;
}

</style>
</head>
<body>
<marquee> THE WINNER IS YOU!!!!!!!!!!!</marquee>
<a href = "index.jsp">Back to Index</a>

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








