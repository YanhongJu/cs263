<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.google.appengine.api.blobstore.BlobKey"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.images.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
											"context/json/test",
											function(data) {

												for (var i = 0; i < data.results.length; i++) {
													var albumName = data.results[i].albumName;
													$("#list")
															.append(
																	//'<div onclick="showdetail(albumName);"'
																	'<div onclick="showdetail('
																			+albumName
																			+');"'
																			+ ' class ="photo" style="width:23%; height:240px;float:left" >'
																			+ '<h4 align="center">'
																			+ data.results[i].albumName
																			+ '</h4>'
																			+'<a href="onealbum.jsp?albumName='
																			+ data.results[i].albumName
																			+'">'
																			+ '<img align="center" src="'
																			+data.results[i].imageUrl
																			+'" style="width:200px;height:180px"/><br/>'
																			+'</a>'
																			+ '<p>'
																			+ data.results[i].notes
																			+ '</p>'
																			+ '</div>');
													alert("UserName:"
															+ i
															+ data.results[i].notes);
													alert("albumName:"
															+ i
															+ data.results[i].albumName);

												}

												$("#list")
														.append(
																'<div onclick="" class ="photo" style="width:23%; height:240px;float:left" >'
																		+ '<h4> <a href="newalbum.html"> New Album </a>'
																		+ '</h4>'
																		+ '</div>');

											});

						});
		function showdetail(x) {

			alert("in show detail"+x);

		}

		/* function showdetail(albumName) {
			
			alert("in show detail"+albumName);
			$
			.getJSON(
					"context/json/testone/"+albumName,
					function(data) {
						
						alert("UserName:"
								+ 0
								+ data.results[0].imageUrl);
						
					});


		} */
	</script>

	<div id="list">

		<%
			ImagesService imagesService = ImagesServiceFactory
					.getImagesService();
			BlobKey blobKey = new BlobKey("5W9mK-CDMYU0FRK-KD9_2w");
			String imageUrl = imagesService.getServingUrl(blobKey);
			pageContext.setAttribute("imageUrl", imageUrl);
		%>

	</div>
	<div>
		<%-- <a href="context/json/testget?key=5W9mK-CDMYU0FRK-KD9_2w">xxxxxxxx</a> 
		<img
			src="http://127.0.0.1:8080/_ah/img/5W9mK-CDMYU0FRK-KD9_2w" height="220"
			width="200" />
		
		<img
			src="context/json/testget/5W9mK-CDMYU0FRK-KD9_2w" height="220"
			width="200" />
		<p>${fn:escapeXml(imageUrl)}</p> --%>
	</div>
</body>

</html>