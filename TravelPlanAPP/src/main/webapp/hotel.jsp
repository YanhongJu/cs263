<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="com.google.appengine.api.memcache.ErrorHandlers"%>
<%@ page import="com.google.appengine.api.memcache.MemcacheService"%>
<%@ page
	import="com.google.appengine.api.memcache.MemcacheServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterOperator"%>

<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/header.css" />
<link type="text/css" rel="stylesheet" href="/stylesheets/innerNav.css" />
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Trip Plan Hotel</title>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js">
	
</script>


<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?libraries=places"></script>
<script type="text/javascript">
	
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


		<div>
			<p align="center">
				<font size="4">Plan details for your trip(Start From
					${fn:escapeXml(date)}):</font>
			</p>
			<p align="center">
				<font face="verdana" size="6" color="#0B173B">
					${fn:escapeXml(planName)}</font>
			</p>
		</div>
		<div class="body">
			<div class="leftbody">
				<div class="nav" align="center">
					<ul>
						<li><a style="color: black"
							href="activity.jsp?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}">Activities</a></li>
						<!-- <li><a style="color: black" href="try.html?"
							target="iframe_a">Activities</a></li> -->
						<li><a style="color: black"
							href="food.jsp?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}">Food
								& Drinks</a></li>
						<li><a style="color: black; background: #0489B1" href="">Hotels</a></li>
						<li><a style="color: black"
							href="flight.jsp?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}">Flights</a></li>

					</ul>
				</div>

				<fieldset style="margin-left: 8px; margin-right: 2px">


					<form id="submitform" name="form1"
						action="/context/enqueue/newactivity?planName=${fn:escapeXml(planName)}&date=${fn:escapeXml(date)}"
						method="post">

						<p>
							Hotel Name:<input type="text" name="activityTitle"
								style="width: 80%">
						</p>
						<p>
							Hotel Address:<input id="pac-input" name="address"
								class="controls" type="text" placeholder="Enter a location"
								style="width: 80%">
						</p>

						<div>
							<p>Day</p>
							<span> <select name="day"
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
							</select>
						</div>
						<p>
							Notes:<input type="text" name="notes" style="width: 90%">
						</p>

						<p>
							<input type="submit" value="Submit">
						</p>

					</form>
					<script>
						$("#submitform")
								.submit(
										function(event) {
											var planName = document.forms["form1"]["activityTitle"].value;

											event.preventDefault();
											if (planName == null
													|| planName == "") {
												alert("Title can not be empty!");
											} else
												$('#submitform').unbind(
														'submit').submit();

										});
					</script>

				</fieldset>


			</div>

			<div class="rightbody">

				<p>Plan Summary(start at ${fn:escapeXml(date)}):</p>
				<%
					MemcacheService syncCache = MemcacheServiceFactory
							.getMemcacheService();
					if (syncCache.get(planName) != null) {
						String details = (String) syncCache.get(planName);
						if (!details.equals("")) {
							String[] list = details.split(",");
							HashSet<String> h = new HashSet<String>(Arrays.asList(list));
							list = h.toArray(new String[0]);
							Arrays.sort(list);
							for (String s : list) {
								if (!s.equals("")) {
									String[] subList = s.split("\t");
									if (subList.length == 2) {
										pageContext.setAttribute("title", subList[1]);
										pageContext.setAttribute("day", subList[0]);
				%>
				<p>

					Day ${fn:escapeXml(day)} : ${fn:escapeXml(title)}
					<%
						}
									}
								}
							}
						} else {

							DatastoreService datastore = DatastoreServiceFactory
									.getDatastoreService();

							Key userKey = KeyFactory.createKey("User", userName);
							Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
							pageContext.setAttribute("planKey", planKey);
							Query q = new Query("Activity").setAncestor(planKey).addSort(
									"day", SortDirection.ASCENDING);
							//Query q = new Query("Activity");
							PreparedQuery pq = datastore.prepare(q);

							String details = "";
							for (Entity result : pq.asIterable()) {
								String title = (String) result.getProperty("title");
								String day = (String) result.getProperty("day");
								pageContext.setAttribute("parentKey", result.getParent());
								pageContext.setAttribute("title", title);
								pageContext.setAttribute("day", day);
								details = details + day + "\t" + title + ",";
					%>
				
				<p>

					Day ${fn:escapeXml(day)} : ${fn:escapeXml(title)}
					<%
						}
							if(details.length()>0){
								details = details.substring(0, details.length()-1);
								syncCache.put(planName, details);
							}
						}
					%>
				
			</div>
		</div>

	</div>


</body>
</html>