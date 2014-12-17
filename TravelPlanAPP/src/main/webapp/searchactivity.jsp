<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trip Plan Search Activity</title>
<style>
.leftbody {
	float: left;
	width: 50%;
	height: 100%;
}

.rightbody {
	float: left;
	width: 50%;
	height: 100%;
}

.infowin {
	width: 450px;
	background: #D8CEF6;
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

	function addList(results, status, pagination) {

		if (status == google.maps.places.PlacesServiceStatus.OK) {

			for (var i = 0; i < results.length; i++) {
				if (results[i].photos)
					addPhoto(results[i]);
			}
			if (pagination.hasNextPage) {
				pagination.nextPage();
			}
		} else if (status == google.maps.places.PlacesServiceStatus.ZERO_RESULTS) {
			alert('Sorry, nothing is found');
		}

	}
	function showdetail(elmnt) {
		//elmnt.style.border-width = "1px";
		var placeID = elmnt.getElementsByTagName('input')[0].value;

		var request = {
			placeId : placeID

		};
		var service = new google.maps.places.PlacesService(map);
		service
				.getDetails(
						request,
						function(place, status) {

							if (status == google.maps.places.PlacesServiceStatus.OK) {
								map.setZoom(18);
								map.setCenter(place.geometry.location);
								var thisTitle = place.name;

								for (i = 0; i < markers.length; i++) {

									marker = markers[i];
									// If is same category or category not picked
									if (marker.title == thisTitle) {
										var infowindow = new google.maps.InfoWindow(
												{
													content :

													'<div class="infowin"> <h2><a href="planForm.jsp?address='
															+ place.formatted_address
															+ '&title='
															+ place.name
															+ '&planName='
															+ getParam('planName')
															+ '&date='
															+ getParam('date')
															+ '" target="_blank">Add To Plan</a></h2>'

															+ '<img src="' + place.icon + '" /><font style="font-size: 20px; color:black;">'
															+ '<font style="font-size: 30px">'
															+ place.name
															+ '</font>'
															+ '<br />Type   : '
															+ place.types
															+ '<br />Rating : '
															+ place.rating
															+ '<br />Website: '
															+ '<a href="'+place.website+'">'
															+ place.website
															+ '</a>'
															+ '<br />Address: '
															+ '<font style="font-size: 15px">'
															+ place.formatted_address
															+ '</font>'
															+ '</font> </div>'

												});

										clearInfos();
										infowindow.open(map, marker);
										infos.push(infowindow);
										break;
									}

								}

							}

							/* OpenWindow = window.open("", "newwin",
									"height=200, width=3000,toolbar=no, menubar=no");

							OpenWindow.document.close() */
						});

		//map.setCenter()
	}
	function addPhoto(obj) {
		document.getElementById('list').innerHTML += ('<div onclick="showdetail(this);" class ="photo" style="width:33%; height:240px;float:left" >'
				+ obj.name
				+ '<br/>'
				+ '<input type="hidden" id="reference" name ="reference" value='+obj.place_id
				+'>'
				+ '<img  src="'
				+ obj.photos[0].getUrl({
					'maxWidth' : 200,
					'maxHeight' : 180
				})
				+ '" style="top: 50px; left:0px; width:200px;height:180px"/><br/>' + '</div>');
	}
	function createMarkers(results, status, pagination) {
		if (status == google.maps.places.PlacesServiceStatus.OK) {

			for (var i = 0; i < results.length; i++) {
				createMarker(results[i]);
				//addList(results[i]);
			}

			if (pagination.hasNextPage) {
				sleep: 2;
				pagination.nextPage();
			}
		} else if (status == google.maps.places.PlacesServiceStatus.ZERO_RESULTS) {
			alert('Sorry, nothing is found');
		}
	}

	// creare single marker function
	function createMarker(obj) {
		/* var address;
		
		geocoder.geocode({'latLng':obj.geometry.location }, function(results, status) {
			    if (status == google.maps.GeocoderStatus.OK) {
			      if (results[0]) {
			        address = result[0].formatted_address;
			      } else {
			        alert('No results found');
			      }
			    } else {
			      alert('Geocoder failed due to: ' + status);
			    }
			  });
		 */
		// prepare new Marker object
		var mark = new google.maps.Marker({
			position : obj.geometry.location,
			map : map,
			title : obj.name
		});
		markers.push(mark);

		google.maps.event.addListener(mark, 'click', function() {
			var address;
			geocoder.geocode({
				'latLng' : obj.geometry.location
			}, function(results, status) {

				if (status == google.maps.GeocoderStatus.OK) {
					if (results[0]) {

						address = results[0].formatted_address;
						addInfoWindow(address, mark, obj);
					} else {
						alert('No results found');
					}
				} else {
					alert('Geocoder failed due to: ' + status);
				}
			});

		});
	}

	function addInfoWindow(address, mark, obj) {
		var infowindow = new google.maps.InfoWindow(
				{
					content : '<div class="infowin"> <h2><a href="planForm.jsp?address='
							+ address
							+ '&title='
							+ obj.name
							+ '&planName='
							+ getParam('planName')
							+ '&date='
							+ getParam('date')
							+ '" target="_blank">Add To Plan</a></h2>'

							+ '<img src="' + obj.icon + '" /><font style="font-size: 20px; color:black;">'
							+ '<font style="font-size: 30px">'
							+ obj.name
							+ '</font>'
							+ '<br />Type   : '
							+ obj.types
							+ '<br />Rating : '
							+ obj.rating
							+ '<br />Address: '
							+ '<font style="font-size: 15px">'
							+ address
							+ '</font>' + '</font> </div>'
				});
		clearInfos();
		infowindow.open(map, mark);
		infos.push(infowindow);
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
									radius : '2000',
									types : [ 'amusement_park', 'aquarium',
											'art_gallery', 'church',
											'city_hall', 'mosque', 'museum',
											'park', 'zoo', 'movie_theater' ]
								};
								/* var request = {
										location : addrLocation,
										radius : '30',
										query : 'point of interests in  '+address,
										types : [ 'amusement_park', 'aquarium', 'art_gallery', 'church',
												'city_hall', 'mosque', 'museum', 'park', 'zoo',
												'movie_theater' ]
									}; */

								// send request
								service = new google.maps.places.PlacesService(
										map);
								service.search(request, addList);
								service.search(request, createMarkers);
								/* service.textSearch(request, addList);
								service.textSearch(request, createMarkers); */

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
		<div id="infor"></div>

		<div class="leftbody">
			<div id="list" style="height: 600px; overflow-y: scroll"></div>
		</div>
		<div class="rightbody">
			<input type="hidden" id="lat" name="lat" value="40.7143528" /> <input
				type="hidden" id="lng" name="lng" value="-74.0059731" />
			<div id="gmap_canvas"></div>
		</div>
	</div>

</body>
</html>