<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>TripPlan Welcom Page</title>
<link type="text/css" rel="stylesheet" href="/stylesheets/header.css"/>
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
			href="<%=userService.createLoginURL(request.getRequestURI())%>">MyAlbum</a></li>
		<li><a
			href="<%=userService.createLoginURL(request.getRequestURI())%>">MyPlans</a></li>
		<li><a
			href="<%=userService.createLoginURL(request.getRequestURI())%>">PlanATrip</a>
		<li><a
			href="">Home</a>	
			<!-- <ul>
			<li><a href="">Create a new Plan</a></li>
			<li><a href="">Edit a Plan</a></li>
			</ul> --></li>


	</ul>
	</div>
	<%
		}
	%>
	<div id="Layer1" clear="both"
		style="position: absolute; width: 100%; height: 100%; z-index: -1">
		<img src="images/back.jpg" height="100%" width="100%" />
	</div >	

</body>


</html>