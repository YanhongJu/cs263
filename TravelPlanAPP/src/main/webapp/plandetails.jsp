<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.List"%>

<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/header.css" />
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<style>
.container {
	width: 100%;
	height: 100%;
}

.body {
	width: 100%;
	height: 100%;
}



.nav {
	align: center;
}

.nav ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
	overflow: hidden;
}

.nav li {
	float: left;
}

.nav a:link, a:visited {
	display: block;
	width: 150px;
	font-size: 120%;
	font-weight: bold;
	text-align: center;
	padding: 4px;
	text-decoration: none;
}

.nav a:hover, a:active {
	background-color: #CCDDFF;
}

.subpageframe {
	width: 100%;
	height: 100%;
}

iframe {
	width: 100%;
	height: 100%;
}
</style>
</head>
<body>

	<%
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		pageContext.setAttribute("userName", userName);
		String planName = request.getParameter("planName");
		pageContext.setAttribute("planName", planName);
		String date = request.getParameter("date");
		pageContext.setAttribute("date", date);
	%>
	<div class="container">
		<div id="header" class="headernav">
			<h3 float="right">Welcom! ${fn:escapeXml(userName)}</h3>
			<ul>
				<li><a
					href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
						out</a></li>
				<li><a href="">MyBlog</a></li>
				<li><a href="">MyPlans</a></li>
				<li><a href="newplan.jsp">PlanATrip</a>
				<li><a href="welcom.jsp">Home</a> <!-- <ul>
				<li><a href="">Create a new Plan</a></li>
				<li><a href="">Edit a Plan</a></li>
			</ul> --></li>
			</ul>
		</div>


		<div>
			<p align="center">
				<font size="4">Plan details for your trip(Start From
					${fn:escapeXml(date)}):</font>
			</p>
			<p align="center">
				<font face="verdana" size="6" color="#0B173B"> planName
					${fn:escapeXml(planName)}</font>
			</p>
		</div>
		<div class="body">
			<div class="leftbody">
				<div class="nav" align="center">
					<ul>
						<li><a style="color: black"
							href="activity.jsp?planName=${fn:escapeXml(planName)}"
							target="iframe_a">Activities</a></li>
						<!-- <li><a style="color: black" href="try.html?"
							target="iframe_a">Activities</a></li> -->
						<li><a style="color: black" href="fooddrink.html"
							target="iframe_a">Food & Drinks</a></li>
						<li><a style="color: black" href="hotel.html"
							target="iframe_a">Hotels</a></li>
						<li><a style="color: black" href="#" target="iframe_a">Flights</a></li>
					</ul>
				</div>
				<div class="subpageframe">
					<iframe src="activity.jsp?planName=${fn:escapeXml(planName)}"
						name="iframe_a"></iframe>
				</div>
			</div>
		

		</div>

	</div>


</body>
</html>