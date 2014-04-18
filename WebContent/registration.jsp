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
					int checkName = 0;
					int checkAge = 0;
					int register = 0;

            %>
                <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {
                    	Statement st = conn.createStatement();

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
            			String name = request.getParameter("name");
                        ResultSet rs = st.executeQuery("select * from users where name='" + name + "'");
    
	
						if (rs.next()) {
						checkName = 1;
						} 
						
						if (request.getParameter("name") == "")
						{
							checkName = 2;
						}
						int a = 0;
                        try { a = Integer.parseInt(request.getParameter("age"));
                        	 } catch(NumberFormatException e) { 
                        		 checkAge = 1;
                        	 }
                        if(a < 0)
                        {
                        	checkAge = 1;
                        }
						
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        if(checkAge == 0 && checkName == 0)
                        {
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
                        register = 1;

                        }
              
                    }

    
       
       %>         
          <%
          if ( register == 1){
          %>
        <script type="text/javascript">
		window.onload = function(){
    alert("You've registered!!!!");
    document.location.href = "index.jsp";

}
	</script>    
	<%} 
	if ( checkAge== 1){
	    %>
	      <script type="text/javascript">
			window.onload = function(){
		   alert("You gotta put in a legitimate age!");

	}
		</script>    
	<%} 
     if ( checkName == 2){
     %>
        <script type="text/javascript">
		window.onload = function(){
    alert("You need to put in a name!");

}
	</script>    
	<%} 
	  if ( checkName == 1){
     %>
        <script type="text/javascript">
		window.onload = function(){
    alert("That name already exists!");

}
	</script>    
	<%} 
%>

            <%-- -------- SELECT Statement Code -------- --%>
           
<title> Register </title>

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

<header>
<h1> REGISTER HERE!!!!!!</h1>
</header>
<hr> 


<form action = "registration.jsp" method = "post">
<input type = "hidden" value = "insert" name = "action">
<table>
	<tr>
		<th>Name</th>
		<th>Role</th>
		<th>Age</th>
		<th>State</th>
	</tr>

<tr>
<th>
		<input type = "text" name = "name" id = "name"> 
	</th>
	<th>
		<select name = "role">
			<option selected="" value="owner">Owner</option>
			<option value="customer">Customer</option>
		</select>
	</th>
	<th>
		<input type = "text" name = "age" id = "age">
	</th>
	<th>
		<select name = "state">
			<option selected="" value="ca">CA</option>
			<option value="lol">LOL</option>
		</select>
	</th>
	
<th>
	<input type = "submit" name = "save" id = "save" value = "Save">
</th>

</tr>
</form>
</table>



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








