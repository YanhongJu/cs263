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
<title>Insert title here</title>
<style>
ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
	overflow: hidden;
}

li {
	float: right;
}

a:link, a:visited {
	display: block;
	width: 140px;
	font-size: 160%;
	font-weight: bold;
	color: white;
	background-color:;
	text-align: center;
	padding: 4px;
	text-decoration: none;
}

a:hover, a:active {
	background-color: #CCDDFF;
}
</style>
</head>
<body>
<div id="Layer1"
		style="position: absolute; width: 100%; height: 100%; z-index: -1">
		<img src="images\back.jpg" height="100%" width="100%" />
</div>
	<%
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		if (userName != null) {
			pageContext.setAttribute("userName", userName);
	%>
	<h3>Welcom! ${fn:escapeXml(userName)}</h3>
	<ul>
		<li><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a></li>		
		<li><a href="">MyBlog</a></li>
		<li><a href="">MyPlans</a></li>
		<li><a href="newplan.jsp">PlanATrip</a>
			<!-- <ul>
				<li><a href="">Create a new Plan</a></li>
				<li><a href="">Edit a Plan</a></li>
			</ul> --></li>
	</ul>
	<%
		} else {
	%>
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
			</ul> -->
		</li>


	</ul>
	<%
		}
	%>




</body>


</html>