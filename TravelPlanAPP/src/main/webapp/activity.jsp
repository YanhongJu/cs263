<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
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
.rightbody p{
	padding:10px 10px;
	margin:10px 10px
}</style>
<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?libraries=places"></script>
<script type="text/javascript">
	/* function initialize() {
		var input = document.getElementById('pac-input');
		var autocomplete = new google.maps.places.Autocomplete(input);
	}
	google.maps.event.addDomListener(window, 'load', initialize); */
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
		String planName = request.getParameter("planName");
		pageContext.setAttribute("planName", planName);
	%>
	<!-- <p>
		<font size="6">Find things to do in:</font>
	</p>
	<input id="pac-input1" class="controls" type="text"
		placeholder="Please enter a city" autocomplete="on">
	<p>
		<font size="6">Or enter a place to go</font>
	</p> -->

	<div class="container">
		<div class="leftbody">


			<form
				action="/context/newactivity/enqueue?planName=${fn:escapeXml(planName)}"
				method="post">

				<fieldset>
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

				</fieldset>
			</form>
		</div>
		<div class="rightbody">
			<p>Plan Summary:</p>
			<%
				DatastoreService datastore = DatastoreServiceFactory
						.getDatastoreService();
				/* Key userKey = KeyFactory.createKey("User", userName.toString());
				Key planKey = KeyFactory.createKey(userKey, "Plan", planName); */
				// Run an ancestor query to ensure we see the most up-to-date
				// view of the Greetings belonging to the selected Guestbook.
				Query q = new Query("Activity");
				//Query q = new Query("Activity").setAncestor(planKey);
				PreparedQuery pq = datastore.prepare(q);
				for (Entity result : pq.asIterable()) {
					String activityTitle = (String) result
							.getProperty("activityTitle");
					String day = (String) result.getProperty("day");
					pageContext.setAttribute("activityTitle", activityTitle);
					pageContext.setAttribute("day", day);
			%>
			<p>
				Day ${fn:escapeXml(day)} : ${fn:escapeXml(activityTitle)}
				<%
					}
				%>
			
		</div>
</body>
</html>