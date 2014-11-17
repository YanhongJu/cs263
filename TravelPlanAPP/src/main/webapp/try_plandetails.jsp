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
<title>Insert title here</title>
<style type="text/css">
#planName {
	a: link{
    color: #FF0000;
}
a:visited {
	color: #00FF00;
}

/* mouse over link */
a:hover {
	color: #FF00FF;
}

/* selected link */
a:active {
	color: #0000FF;
}
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
				href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
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
				String dateString = date.getYear() + "-" + date.getMonth()
						+ "-" + date.getDate();
				pageContext.setAttribute("date", dateString);
		%>
		<h1 style="position: relative; left: 40px;">
			Plan ${fn:escapeXml(planName)} <font size="4px"> Start at
				${fn:escapeXml(date)} </font>
		</h1>

		<form style="position: relative; left: 100px;"
			action="/context/enqueue/deleteplan?planName=${fn:escapeXml(planName)}"
			method="post">
			<input type="submit" value="Delete">
		</form>

		<%
			Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
				Query detailq = new Query("Activity").setAncestor(planKey)
						.addSort("day", SortDirection.ASCENDING);
				PreparedQuery pdetailq = datastore.prepare(detailq);
				for (Entity detail : pdetailq.asIterable()) {
					String detailTitle = (String) detail.getProperty("title");
					String day = (String) detail.getProperty("day");
					pageContext.setAttribute("detailTitle", detailTitle);
					pageContext.setAttribute("day", day);
					String address = (String) detail.getProperty("address");
					pageContext.setAttribute("address", address);
					String notes = (String) detail.getProperty("notes");
					pageContext.setAttribute("notes", notes);
					pageContext.setAttribute("redirect", "false");
		%>

		<p>
			<a id="planName"
				style="position: relative; left: 70px; font-size: 25px"
				href="planForm.jsp?planName=${fn:escapeXml(planName)}&day=${fn:escapeXml(day)}&address=${fn:escapeXml(address)}&notes=${fn:escapeXml(notes)}&title=${fn:escapeXml(detailTitle)}&redirect=${fn:escapeXml(redirect)}">
				Day ${fn:escapeXml(day)}: ${fn:escapeXml(detailTitle)}</a>
		</p>
		<form style="position: relative; left: 100px;"
			action="/context/enqueue/deleteactivity?planName=${fn:escapeXml(planName)}&title=${fn:escapeXml(detailTitle)}"
			method="post">
			<input type="submit" value="Delete">
		</form>

		<%-- <input type=button value="Update"
			onclick="window.open('planForm.jsp?planName=${fn:escapeXml(planName)}&day=${fn:escapeXml(day)}&address=${fn:escapeXml(address)}&notes=${fn:escapeXml(notes)}&title=${fn:escapeXml(detailTitle)}&redirect=${fn:escapeXml(redirect)}')">
		<a
			href="planForm.jsp?planName=${fn:escapeXml(planName)}&day=${fn:escapeXml(day)}&address=${fn:escapeXml(address)}&notes=${fn:escapeXml(notes)}&title=${fn:escapeXml(detailTitle)}&redirect=${fn:escapeXml(redirect)}">
			Update</a> --%>


		<p style="position: relative; left: 100px;">Address:
			${fn:escapeXml(address)}</p>
		<p style="position: relative; left: 100px;">Notes:
			${fn:escapeXml(notes)}</p>
		<%
			}
		%>
		<a id="planName" style="position: relative; left: 40px;"
			href="plandetails.jsp?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}">
			Add A New Activity</a>
		<%
			}
		%>

	</div>


</body>
</html>