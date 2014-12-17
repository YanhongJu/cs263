

<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@ page import="java.util.Date"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection"%>

<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="/stylesheets/header.css" />
<title>Trip Plan</title>
<style type="text/css">
#planLink  a {
	color: black;
}

#planLink  a:hover {
	color: #0B4C5F;
}

#planLink  a:active {
	color: #0B4C5F;
}
</style>

</head>
<body>

	<%
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		if (userName != null) {
			pageContext.setAttribute("userName", userName);
	%>
	<div class="headernav">
		<h3 float="right">Welcom! ${fn:escapeXml(userName)}</h3>
		<ul>
			<li><a
				href="<%=userService.createLogoutURL("welcom.jsp")%>">Sign
					out</a></li>
			<li><a href="album.jsp">MyAlbum</a></li>
			<li><a href="allplans.jsp">MyPlans</a></li>
			<li><a href="newplan.jsp">PlanATrip</a>
			<li><a href="welcom.jsp">Home</a> <!-- <ul>
				<li><a href="">Create a new Plan</a></li>
				<li><a href="">Edit a Plan</a></li>
			</ul> --></li>
		</ul>
	</div>
	<%
		} else {
	%>
	<div class="headernav">
		<ul>
			<li><a
				href="<%=userService.createLoginURL(request.getRequestURI())%>">SignIn</a></li>
			<li><a
				href="<%=userService.createLoginURL(request.getRequestURI())%>">MyBlogs</a></li>
			<li><a
				href="<%=userService.createLoginURL(request.getRequestURI())%>">MyPlans</a></li>
			<li><a
				href="<%=userService.createLoginURL(request.getRequestURI())%>">NewTrip</a>
				<!-- <ul>
			<li><a href="">Create a new Plan</a></li>
			<li><a href="">Edit a Plan</a></li>
			</ul> --></li>


		</ul>
	</div>
	<%
		}
	%>

	<div>

		<h1 align="center">My PlanList:</h1>

		<%
			pageContext.setAttribute("userName", userName);
			DatastoreService datastore = DatastoreServiceFactory
					.getDatastoreService();
			pageContext.setAttribute("userName", userName.toString());
			Key userKey = KeyFactory.createKey("User", userName.toString());
			Query q = new Query("Plan").setAncestor(userKey).addSort("date",
					SortDirection.DESCENDING);
			//Query q = new Query("Activity");
			PreparedQuery pq = datastore.prepare(q);
			for (Entity result : pq.asIterable()) {
				String planName = (String) result.getProperty("planName");
				pageContext.setAttribute("planName", planName);
				Date date = (Date) result.getProperty("date");
				String dateString = (date.getYear()+1900) + "-" + (date.getMonth()+1)
						+ "-" + date.getDate();
				pageContext.setAttribute("date", dateString);
		%>
		<div id="planLink" style="position: relative; left: 250px;">
			<form
				action="/context/enqueue/deleteplan?planName=${fn:escapeXml(planName)}"
				method="post">
				<h1>
					<a
						href="plandetails.jsp?planName=${fn:escapeXml(planName)}&startDate=${fn:escapeXml(date)}">
						${fn:escapeXml(planName)} </a> &nbsp;&nbsp;&nbsp;&nbsp; <font size="4px"> (Start at
						${fn:escapeXml(date)})   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   <input type="submit"
						value="Delete This Plan">
					</font>
				</h1>

			</form>
		</div>

		<%
			}
		%>

	</div>


</body>
</html>