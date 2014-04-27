<%@ page language="java" import="java.sql.*"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Confirmation</title>
<link rel="stylesheet" href="css/main.css" type="text/css"
	title="normal">
</head>
<body>

	<%
		if (session.getAttribute("role") != null
				&& (session.getAttribute("role").equals("owner") || session
						.getAttribute("role").equals("customer"))) {
	%>
	<%@include file="header.jsp"%>
	<%
		try {
				Class.forName("org.postgresql.Driver");
				Connection conn = null;
				conn = DriverManager.getConnection(
						"jdbc:postgresql://localhost:5432/postgres",
						"postgres", "password");
	%>

	<p style="text-align: center">
		Purchase successful! <br>You have purchased:
	</p>
	<table border="3">
		<tr>
			<th>name</th>
			<th>quantity</th>
			<th>price</th>
		</tr>
		<%
			conn.setAutoCommit(false);
					ResultSet rs = null;

					PreparedStatement statement = conn
							.prepareStatement("SELECT products.name,cart.amount,products.price "
									+ "FROM cart,products "
									+ "WHERE cart.product=products.id "
									+ "AND cart.userid=?;");
					String s = session.getAttribute("id").toString();
					int d = Integer.parseInt(s);
					statement.setInt(1, d);

					rs = statement.executeQuery();
					conn.commit();

					while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getString("name")%></td>
			<td><%=rs.getInt("amount")%></td>
			<td>$<%=rs.getInt("price") * rs.getInt("amount")%></td>
		</tr>
		<%
			}
		%>
		<%
			
		%>
	</table>
	<%
		statement = conn
						.prepareStatement("DELETE FROM cart WHERE userid=?");
				statement.setInt(1, Integer.valueOf(session.getAttribute(
						"id").toString()));
				statement.execute();
				conn.commit();

				conn.close();
			} catch (SQLException sqle) {
				out.println(sqle.getMessage());
			} catch (Exception e) {
				out.println(e.getMessage());
			}
		} else {
	%>
	<script type="text/javascript">
		window.onload = function() {
			document.location.href = "error.jsp";
		}
	</script>
	<%
		}
	%>
</body>
</html>