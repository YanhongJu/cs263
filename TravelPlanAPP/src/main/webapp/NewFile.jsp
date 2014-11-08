<%@ page import="com.google.appengine.api.users.User"%> <%@ page
import="com.google.appengine.api.users.UserService"%> <%@ page
import="com.google.appengine.api.users.UserServiceFactory"%> <%@ taglib
prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> <%@ page
import="java.util.List"%> <%@ page
import="com.google.appengine.api.datastore.FetchOptions"%> <%@ page
import="com.google.appengine.api.datastore.Key"%> <%@ page
import="com.google.appengine.api.datastore.KeyFactory"%> <%@ page
language="java" contentType="text/html; charset=ISO-8859-1"
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

.subpageframe {
	width: 100%;
	height: 100%;
}

iframe {
	width: 100%;
	height: 100%;
}
</style>
</head>
<frameset rows="50%,50%">
	<frame src="frame_a.htm">
	<frameset cols="25%,75%">
		<frame src="frame_b.htm">
		<frame src="frame_c.htm">
	</frameset>
</frameset>

</html>