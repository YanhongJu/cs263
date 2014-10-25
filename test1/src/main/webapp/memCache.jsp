<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheService" %>
<%@ page import = "java.util.logging.Level" %>
<%@ page import ="com.google.appengine.api.memcache.ErrorHandlers" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
<title>task data</title>
</head>
<body>

<%
    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
    String key = request.getParameter("key"); 
	pageContext.setAttribute("key", key);
	String value = (String) syncCache.get(key);
    if (value == null) 	
		pageContext.setAttribute("value", "null");
    else 
    	pageContext.setAttribute("value", value);
%>
<p>The value in key '${fn:escapeXml(key)}' is '${fn:escapeXml(value)}' !</p>

</body>
</html>