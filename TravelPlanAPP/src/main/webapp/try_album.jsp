<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobKey"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.images.*"%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link type="text/css" rel="stylesheet" href="/stylesheets/header.css" />
</head>
<body>
	<%
		UserService userService = UserServiceFactory.getUserService();
		String userName = userService.getCurrentUser().toString();
		if (userName != null) {
			pageContext.setAttribute("userName", userName);
	%>
	<div class="headernav">
		<h3 float="right">Welcom! ${fn:escapeXml(userName)}</h3>
		<ul>
			<li><a href="<%=userService.createLogoutURL("welcom.jsp")%>">Sign
					out</a></li>
			<li><a href="albums.html">MyAlbum</a></li>
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
			ImagesService imagesService = ImagesServiceFactory
					.getImagesService();
			DatastoreService datastore = DatastoreServiceFactory
					.getDatastoreService();
			Filter propertyFilter = new FilterPredicate("UserName",
					FilterOperator.EQUAL, userName);
			Query q = new Query("Album").setFilter(propertyFilter);
			PreparedQuery pq = datastore.prepare(q);

			for (Entity result : pq.asIterable()) {
				String albumName = (String) result.getProperty("albumName");
				pageContext.setAttribute("albumName", albumName);
				String notes = (String) result.getProperty("notes");
				pageContext.setAttribute("notes", notes);
				List<String> list = (List<String>) result.getProperty("list");
				String linkKey = userName+albumName;
				pageContext.setAttribute("linkKey", linkKey);
				String imageUrl;
				if (list.get(0) != null) {
					BlobKey blobKey = new BlobKey(list.get(0));
					imageUrl = imagesService.getServingUrl(blobKey);
				} else
					imageUrl = "images/no_image.png";

				pageContext.setAttribute("imageUrl", imageUrl);
		%>

		<div onclick="location.href='onealbum.jsp?linkKey=${fn:escapeXml(linkKey)}'" class="photo" style="width: 23%; height: 240px; float: left">
			<h4 align="center">${fn:escapeXml(albumName)}</h4>
			<img src="${fn:escapeXml(imageUrl)}" align="center"
				style="width: 220px; height: 200px" />
			<p align="center">${fn:escapeXml(notes)}</p>
		</div>

		<%
			}
		%>


		<div class="photo" style="width: 23%; height: 240px; float: left">
			<h4><a href="newalbum.html"> New Album </a> </h4>
		</div>


	</div>
</body>
</html>