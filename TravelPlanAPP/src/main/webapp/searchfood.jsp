<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

.leftbody {
float:left;
	width: 55%;
	height: 100%;
}
.rightbody {
float:left;
	width: 45%;
	height: 100%;
}
#gmap_canvas {
	height: 700px;
	position: relative;
	width: 900px;
}
</style>
<script
	src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places"></script>
<script>
	var geocoder;
	var map;
	var markers = Array();
	var infos = Array();

	function initialize() {

		// set initial position (New York)
		var myLatlng = new google.maps.LatLng(
				document.getElementById('lat').value, document
						.getElementById('lng').value);

		var myOptions = { // default map options
			zoom : 14,
			center : myLatlng,
			mapTypeId : google.maps.MapTypeId.ROADMAP
		};
		map = new google.maps.Map(document.getElementById('gmap_canvas'),
				myOptions);

		getAddress();

	}

	function clearOverlays() {
		if (markers) {
			for (i in markers) {
				markers[i].setMap(null);
			}
			markers = [];
			infos = [];
		}
	}

	// clear infos function
	function clearInfos() {
		if (infos) {
			for (i in infos) {
				if (infos[i].getMap()) {
					infos[i].close();
				}
			}
		}
	}

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
	function createMarkers(results, status,pagination) {
		if (status == google.maps.places.PlacesServiceStatus.OK) {
			
			if(pagination.hasNextPage){
				pagination.nextPage();
			}			
			for (var i = 0; i < results.length; i++) {
				createMarker(results[i]);
			}
		} else if (status == google.maps.places.PlacesServiceStatus.ZERO_RESULTS) {
			alert('Sorry, nothing is found');
		}
	}

	// creare single marker function
	function createMarker(obj) {

		// prepare new Marker object
		var mark = new google.maps.Marker({
			position : obj.geometry.location,
			map : map,
			title : obj.name
		});
		markers.push(mark);

		// prepare info window
		var infowindow = new google.maps.InfoWindow(
				{
					content : '<img src="' + obj.icon + '" /><font style="color:#000;">'
							+ obj.name
							+ '<br />Rating: '
							+ obj.rating
							+ '<br />Vicinity: ' + obj.vicinity + '</font>'
				});

		// add event handler to current marker
		google.maps.event.addListener(mark, 'click', function() {
			clearInfos();
			infowindow.open(map, mark);
		});
		infos.push(infowindow);
	}

	function addList(results, status, pagination) {

		if (status == google.maps.places.PlacesServiceStatus.OK) {
			//document.getElementById('list').innerHTML += ('length     ' + results.length);
			for (var i = 0; i < results.length; i++) {
				addPhoto(results[i]);
			}
			if (pagination.hasNextPage) {
				pagination.nextPage();
			}
		} else if (status == google.maps.places.PlacesServiceStatus.ZERO_RESULTS) {
			alert('Sorry, nothing is found');
		}

	}
	function addPhoto(obj) {
		document.getElementById('list').innerHTML += ('<div class ="photo" style="width:33%; float:left">'
				+ obj.name
				+ '<br/>'
				+ 'rating:'
				+ obj.rating
				+ '<br/>'
				+ '<img src="' + obj.photos[0].getUrl({
					'maxWidth' : 200,
					'maxHeight' : 200
				}) + '" style="width:200px; height:200px"/><br/>' + '</div>');
	}

	function getAddress() {

		geocoder = new google.maps.Geocoder();
		var address = getParam("query");
		geocoder
				.geocode(
						{
							'address' : address
						},
						function(results, status) {
							if (status == google.maps.GeocoderStatus.OK) { // and, if everything is ok

								var addrLocation = results[0].geometry.location;
								map.setCenter(addrLocation);
								document.getElementById('lat').value = results[0].geometry.location
										.lat();
								document.getElementById('lng').value = results[0].geometry.location
										.lng();

								var request = {
									location : addrLocation,
									radius : '5000',
									types : [ 'food']
								};

								// send request
								service = new google.maps.places.PlacesService(
										map);
								service.search(request, addList);
								service.search(request, createMarkers);
								

							} else {
								alert('Geocode was not successful for the following reason: '
										+ status);
							}
						});
	}
	// initialization
	google.maps.event.addDomListener(window, 'load', initialize);
</script>

</head>
<body>

	<div class="container">
	
	<%
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		pageContext.setAttribute("userName", userName);
		
	%>
		<div class="leftbody"><div id="list"></div></div>
		<div class="rightbody">
			<input type="hidden" id="lat" name="lat" value="40.7143528" /> <input
				type="hidden" id="lng" name="lng" value="-74.0059731" />
			<div id="gmap_canvas"></div>
		</div>
	</div>

</body>
</html>