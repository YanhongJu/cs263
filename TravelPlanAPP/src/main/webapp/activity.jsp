<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.List"%>

<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
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

.leftbody {
	float: left;
	width: 65%;
	height: 100%;
}

.rightbody {
	float: left;
	width: 35%;
	height: 100%;
}

.rightbody p {
	padding: 10px 10px;
	margin: 10px 10px
}
</style>

<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?libraries=places"></script>
<script type="text/javascript">
	function initialize1() {
		var input1 = document.getElementById('pac-input1');
		var autocomplete1 = new google.maps.places.Autocomplete(input1);
	}
	google.maps.event.addDomListener(window, 'load', initialize1);
	function initialize() {
		var input = /** @type {HTMLInputElement} */
		(document.getElementById('pac-input'));
		var autocomplete = new google.maps.places.Autocomplete(input);
		autocomplete.bindTo('bounds', map);
		var infowindow = new google.maps.InfoWindow();
	}
	google.maps.event.addDomListener(window, 'load', initialize);
</script>
</head>
<body>

	<%
		UserService userService = UserServiceFactory.getUserService();
		String userName = userService.getCurrentUser().toString();
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
						<li><a style="color: black; background: #0489B1" href="#">Activities</a></li>
						<!-- <li><a style="color: black" href="try.html?"
							target="iframe_a">Activities</a></li> -->
						<li><a style="color: black"
							href="food.jsp?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}">Food &
								Drinks</a></li>
						<li><a style="color: black"
							href="hotel.jsp?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}">Hotels</a></li>
						<li><a style="color: black"
							href="flight.jsp?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}">Flights</a></li>
					</ul>
				</div>

				<fieldset style="margin-left: 8px; margin-right: 2px">
					<form
						action="/context/search/activity?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}"
						method="post" >

						<p>Want suggestions? Find something to do in</p>
						<p>
							<input id="pac-input1" class="controls" type="text"
								placeholder="Please enter a city" autocomplete="on"
								name="searchCity"> <input type="submit" value="Submit">
						</p>

					</form>



					<form
						action="/context/enqueue/newactivity/?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}"
						method="post">


						<p>Or you can enter your activity details:</p>
						<p>
							Title:<input type="text" name="activityTitle" style="width: 80%">
						</p>
						<p>
							Address:<input id="pac-input" name="address" class="controls"
								type="text" placeholder="Enter a location" style="width: 80%">
						</p>

						<div style="position: relative;">
							<p>Day</p>
							<span style="margin-left: 100px; width: 18px; overflow: hidden;">
								<select style="width: 118px; margin-left: -100px"
								onchange="this.parentNode.nextSibling.value=this.value">
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									<option value="6">6</option>
									<option value="7">7</option>
									<option value="8">8</option>
									<option value="9">9</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
									<option value="13">13</option>
									<option value="14">14</option>
									<option value="15">15</option>
									<option value="16">16</option>
							</select>
							</span><input name="day"
								style="width: 100px; position: absolute; left: 0px;"
								style="width:40%">
						</div>
						<p>
							Notes:<input type="text" name="notes" style="width: 90%">
						</p>

						<p>
							<input type="submit" value="Submit">
						</p>

					</form>

				</fieldset>


			</div>

			<div class="rightbody">
				<p>Plan Summary(start at ${fn:escapeXml(date)}):</p>
				<%
					DatastoreService datastore = DatastoreServiceFactory
							.getDatastoreService();

					/* 
					datastore.get(planKey).getKey();
					pageContext.setAttribute("planKey", planKey); */
					// Run an ancestor query to ensure we see the most up-to-date
					// view of the Greetings belonging to the selected Guestbook.
					//Query q = new Query("Activity");

					/* Filter propertyFilter = new FilterPredicate("user",
							FilterOperator.EQUAL, userName.toString()); 
					
					.setFilter(propertyFilter)*/
					Key userKey = KeyFactory.createKey("User", userName);
					Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
					pageContext.setAttribute("planKey", planKey);
					Query q = new Query("Activity").setAncestor(planKey).addSort("day", SortDirection.ASCENDING);
					//Query q = new Query("Activity");
					PreparedQuery pq = datastore.prepare(q);
					for (Entity result : pq.asIterable()) {
						String title = (String) result
								.getProperty("title");
						String day = (String)result.getProperty("day");
						pageContext.setAttribute("parentKey", result.getParent());
						pageContext.setAttribute("title", title);
						pageContext.setAttribute("day", day);
				%>
				<p>

					Day ${fn:escapeXml(day)} :  	${fn:escapeXml(title)}
					<%
						}
					%>
				
			</div>
		</div>

	</div>


</body>
</html>