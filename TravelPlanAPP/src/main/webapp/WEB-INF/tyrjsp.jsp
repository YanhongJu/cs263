<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?libraries=places"></script>
<script type="text/javascript">
	<script language="JavaScript">
	/* function initialize() {
		var input = document.getElementById('pac-input');
		var autocomplete = new google.maps.places.Autocomplete(input);
	}
	google.maps.event.addDomListener(window, 'load', initialize); */
	<script>
	function initialize() {
		var input = /** @type {HTMLInputElement} */
		(document.getElementById('pac-input'));
		var autocomplete = new google.maps.places.Autocomplete(input);
		autocomplete.bindTo('bounds', map);
		var infowindow = new google.maps.InfoWindow();
	}
	google.maps.event.addDomListener(window, 'load', initialize);
</script>
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
	<input id="pac-input" class="controls" type="text"
		placeholder="Please enter a city" autocomplete="on">
	<p>
		<font size="6">Or enter a place to go</font>
	</p> -->


	<form action="/newactivity/enqueue?planName="+${fn:escapeXml(planName)} method="post">

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


</body>
</html>