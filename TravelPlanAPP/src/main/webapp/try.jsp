<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>Place Autocomplete</title>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
<meta charset="utf-8">
<style>
#pac-input {
	background-color: #fff;
	padding: 0 11px 0 13px;
	width: 400px;
	font-family: Roboto;
	font-size: 15px;
	font-weight: 300;
	text-overflow: ellipsis;
}

#pac-input:focus {
	border-color: #4d90fe;
	margin-left: -1px;
	padding-left: 14px; /* Regular padding-left + 1. */
	width: 401px;
}

.pac-container {
	font-family: Roboto;
}

#type-selector {
	color: #fff;
	background-color: #4d90fe;
	padding: 5px 11px 0px 11px;
}

#type-selector label {
	font-family: Roboto;
	font-size: 13px;
	font-weight: 300;
}
}
</style>
<script
	src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places"></script>

<script>
	function autocomplete() {
		var input = /** @type {HTMLInputElement} */
		(document.getElementById('pac-input'));
		var autocomplete = new google.maps.places.Autocomplete(input);
		autocomplete.bindTo('bounds', map);
		var infowindow = new google.maps.InfoWindow();
	}
	google.maps.event.addDomListener(window, 'load', autocomplete);
</script>
</head>
<body>
	<div class="subpageframe">
		<iframe src="activity.jsp" name="iframe_a"></iframe>
	</div>


	<%
		
		pageContext.setAttribute("planName", "xxxxxxx");
	%>
	<form action="/context/jerseyws/test2?planName=${fn:escapeXml(planName)}"
		 method="post">

		<p>
			${fn:escapeXml(planName)}:<input type="text" name="activityTitle" style="width: 80%">
		</p>
		<p>
			<input type="submit" value="Submit">
		</p>
	</form>





	<form action="/context/newactivity/enqueue?planName="
		+${fn:escapeXml(planName)} method="post">

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





	<div style="position: relative;">
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
		</span><input name="box" style="width: 100px; position: absolute; left: 0px;">
</body>
</html>