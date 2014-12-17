<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Trip Plan Albums</title>
<link type="text/css" rel="stylesheet" href="stylesheets/header.css" />
<style type="text/css">
#newlink  a {
	color: black;
}

#newlink  a:hover {
	color: #0B4C5F;
}

#newlink  a:active {
	color: #0B4C5F;
}

#photo  a {
	color: black;
}

#photo  a:hover {
	color: #0B4C5F;
}

#photo  a:active {
	color: #0B4C5F;
}
</style>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js">
	
</script>

</head>
<body>
	<script type="text/javascript">
		$(document)
				.ready(
						function() {

							$
									.getJSON(
											"context/album/allalbums",
											function(data) {
												//alert("data");
												for (var i = 0; i < data.results.length; i++) {
													var albumName = data.results[i].albumName;
													$("#list")
															.append(
																	//'<div onclick="showdetail(albumName);"'
																	'<div id ="photo" class ="photo" style="width:240px; height:260px;float:left" >'
																			+ '<h4  align="center" style="margin-top:2px; margin-bottom:3px">'
																			+ data.results[i].albumName
																			+ '</h4>'
																			+ '<a href="gallery.jsp?albumName='
																			+ data.results[i].albumName
																			+ '">'
																			+ '<img  style="padding-top: 0px;padding-left: 20px;width:200px;height:180px" src="'
												+ data.results[i].imageUrl
												+'" /><br/>'
																			+ '</a>'
																			+ '<p  align="center" style="margin-top:2px; margin-bottom:3px">'
																			+ data.results[i].notes
																			+ '</p> <form action="/context/album/deletealbum?albumName='
																			+data.results[i].albumName
																			+'" method="post"> <input align="center" type="submit" value="Delete"></form>'
																			+ '</div>');
													/* alert("UserName:"
															+ i
															+ data.results[i].notes);
													alert("albumName:"
															+ i
															+ data.results[i].albumName); */

												}
												$("#list")
														.append(
																'<div id="newlink" style="width:240px; height:240px;float:left" >'
																		+ '<h2 style="margin:50px;"> <a href="newalbum.jsp">Add New Album </a>'
																		+ '</h2>'
																		+ '</div>');

											});

						});
	</script>

	<%
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		if (userName != null) {
			pageContext.setAttribute("userName", userName);
	%>
	<div class="headernav">
		<h3 float="right">Welcom! ${fn:escapeXml(userName)}</h3>
		<ul>
			<li><a href="<%=userService.createLogoutURL("welcom.jsp")%>">Sign
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
	<div id="list"></div>
	</ body>
</html>