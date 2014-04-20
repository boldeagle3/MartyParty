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


</head>
<body>

<header>

<%@include file="header.jsp" %>

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
	<option value="AL">Alabama</option>
	<option value="AK">Alaska</option>
	<option value="AZ">Arizona</option>
	<option value="AR">Arkansas</option>
	<option value="CA">California</option>
	<option value="CO">Colorado</option>
	<option value="CT">Connecticut</option>
	<option value="DE">Delaware</option>
	<option value="FL">Florida</option>
	<option value="GA">Georgia</option>
	<option value="HI">Hawaii</option>
	<option value="ID">Idaho</option>
	<option value="IL">Illinois</option>
	<option value="IN">Indiana</option>
	<option value="IA">Iowa</option>
	<option value="KS">Kansas</option>
	<option value="KY">Kentucky</option>
	<option value="LA">Louisiana</option>
	<option value="ME">Maine</option>
	<option value="MD">Maryland</option>
	<option value="MA">Massachusetts</option>
	<option value="MI">Michigan</option>
	<option value="MN">Minnesota</option>
	<option value="MS">Mississippi</option>
	<option value="MO">Missouri</option>
	<option value="MT">Montana</option>
	<option value="NE">Nebraska</option>
	<option value="NV">Nevada</option>
	<option value="NH">New Hampshire</option>
	<option value="NJ">New Jersey</option>
	<option value="NM">New Mexico</option>
	<option value="NY">New York</option>
	<option value="NC">North Carolina</option>
	<option value="ND">North Dakota</option>
	<option value="OH">Ohio</option>
	<option value="OK">Oklahoma</option>
	<option value="OR">Oregon</option>
	<option value="PA">Pennsylvania</option>
	<option value="RI">Rhode Island</option>
	<option value="SC">South Carolina</option>
	<option value="SD">South Dakota</option>
	<option value="TN">Tennessee</option>
	<option value="TX">Texas</option>
	<option value="UT">Utah</option>
	<option value="VT">Vermont</option>
	<option value="VA">Virginia</option>
	<option value="WA">Washington</option>
	<option value="WV">West Virginia</option>
	<option value="WI">Wisconsin</option>
	<option value="WY">Wyoming</option>
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








