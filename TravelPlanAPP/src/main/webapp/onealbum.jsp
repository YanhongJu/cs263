<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link type="text/css" rel="stylesheet" href="/stylesheets/header.css" />
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js">
	
</script>
<style type="text/css">
img.pos_fixed {
	position: fixed;
	top: 15px;
	right: 20px;
}

#newlink  a {
	color: black;
}

#newlink  a:hover {
	color: #0B4C5F;
}

#newlink  a:active {
	color: #0B4C5F;
}
</style>
<script type="text/javascript">
	var urls = Array();
	function getParam(param) {
		var httprequest = {

			QueryString : function(val) {
				var uri = window.location.search;
				var re = new RegExp("" + val + "=([^&?]*)", "ig");
				return ((uri.match(re)) ? (decodeURI(uri.match(re)[0]
						.substr(val.length + 1))) : '');
			}
		}
		return httprequest.QueryString(param);
	}
	$(document)
			.ready(
					function() {
						/* alert(getParam('albumName')); */

						$
								.getJSON(
										"context/json/testone/"
												+ getParam('albumName'),
										function(data) {
											/* alert("data get "); */
											for (var i = 0; i < data.results.length; i++) {
												$("#list")
														.append(

																'<div id="photo" class ="photo" style="width:240px; height:240px;float:left" >'
																		+ '<a href="">'
																		+ '<img style="padding-top: 10px;padding-left: 20px;width:200px;height:180px"  src="'+data.results[i].imageUrl+'" />'
																		+ '</a>'
																		+ '</div>');
											}
											$("#list")
													.append(
															'<div id="newlink" style="width:240px; height:240px;float:left" >'
																	+ '<h4> <a href="addphoto.jsp?albumName='
																	+ getParam('albumName')
																	+ '"> Add photos </a>'
																	+ '</h4>'
																	+ '</div>');

										});
					});
</script>
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

	<div id="list">

		<%
			String albumName = request.getParameter("albumName");
		%>

	</div>
	<div>
		<input type="hidden" id="albumName" name="albumName"
			value=${fn:escapeXml(albumName)}>
	</div>

</body>

</html>