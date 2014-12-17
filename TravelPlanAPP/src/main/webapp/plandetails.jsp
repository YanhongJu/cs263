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
<title>Trip Plan PlanDetails</title>
<style type="text/css">
#activityLink  a {
	color: black;
}

#activityLink  a:hover {
	color: #0B4C5F;
}

#activityLink  a:active {
	color: #0B4C5F;
}

#addLink a {
	color: #086A87;
}

#addLink a:hover {
	color: #0B2F3A;
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



	<%
		pageContext.setAttribute("userName", userName);
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		pageContext.setAttribute("userName", userName.toString());
		Key userKey = KeyFactory.createKey("User", userName.toString());
		String planName = request.getParameter("planName");
		pageContext.setAttribute("planName", planName);
		String startDate = request.getParameter("startDate");
		pageContext.setAttribute("startDate", startDate);
	%>
	<div>
		<h1 align="center">
			<font size="4px"> Details about Plan </font>
			${fn:escapeXml(planName)} <font size="4px"> :(Start at
				${fn:escapeXml(startDate)}) </font>
		</h1>
	</div>
	<%
		Key planKey = KeyFactory.createKey(userKey, "Plan", planName);

		Query q = new Query("Activity").setAncestor(planKey).addSort("day",
				SortDirection.ASCENDING);
		PreparedQuery pq = datastore.prepare(q);

		for (Entity detail : pq.asIterable()) {
			String detailTitle = (String) detail.getProperty("title");
			String day = (String) detail.getProperty("day");
			pageContext.setAttribute("detailTitle", detailTitle);
			pageContext.setAttribute("day", day);
			String address = (String) detail.getProperty("address");
			pageContext.setAttribute("address", address);
			String notes = (String) detail.getProperty("notes");
			pageContext.setAttribute("notes", notes);
	%>
	<div id="activityLink">
		<form style="position: relative; left: 130px;"
			action="/context/enqueue/deleteactivity?planName=${fn:escapeXml(planName)}&title=${fn:escapeXml(detailTitle)}&startDate=${fn:escapeXml(startDate)}"
			method="post">

			<p style="position: relative; left: 100x; font-size: 25px">
				<a
					href="updateform.jsp?planName=${fn:escapeXml(planName)}&day=${fn:escapeXml(day)}&address=${fn:escapeXml(address)}&notes=${fn:escapeXml(notes)}&title=${fn:escapeXml(detailTitle)}&startDate=${fn:escapeXml(startDate)}">
					Day ${fn:escapeXml(day)}: ${fn:escapeXml(detailTitle)} </a>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit"
					value="Delete">
			</p>

		</form>
		<p style="position: relative; left: 150px; font-size: 20px">Address:
			${fn:escapeXml(address)}</p>
		<p style="position: relative; left: 150px; font-size: 20px">Notes:
			${fn:escapeXml(notes)}</p>

	</div>


	<%
		}
	%>
	<div id="addLink">
		<a style="position: relative; left: 130px; font-size: 25px"
			href="activity.jsp?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(startDate)}">
			Add A New Activity To This Plan</a>
	</div>



</body>
</html>