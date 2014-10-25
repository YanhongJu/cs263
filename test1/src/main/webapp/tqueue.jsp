<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
<title>task data</title>
</head>
<body>

<%
    String key = request.getParameter("key"); 
	pageContext.setAttribute("key", key);
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Key taskKey = KeyFactory.createKey("TaskData", key);
	Entity task = datastore.get(taskKey);
	pageContext.setAttribute("value", task.getProperty("value"));	
%>
<p>The value in keyname '${fn:escapeXml(key)}' is '${fn:escapeXml(value)}' !</p>

<%-- <%
    String listName = request.getParameter("listName");  
    pageContext.setAttribute("listName", listName);
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Key taskListKey = KeyFactory.createKey("TaskData", listName);
	%>
	<%
	Query query = new Query("datas", taskListKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> datas = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
    if (datas.isEmpty()) {
    %>
    	<p>taskDataList '${fn:escapeXml(listName)}' has no messages.</p>
    	<%
    	} else {
    	%>
    	<p>datas in '${fn:escapeXml(listName)}'.</p>
    	<%
    	    for (Entity d : datas) { 
    	    	pageContext.setAttribute("key_",
    	                d.getProperty("key"));
    	    	pageContext.setAttribute("value_",
    	                d.getProperty("value"));    	    	
    	%>
    	<p><b>KeyName:</b> ${fn:escapeXml(key_)}                        <b>Value:</b> ${fn:escapeXml(value_)}</p>    	
    	<%
    	    }
    	%>
    	
    	<%
    	        }    	    
    	%> --%>


</body>
</html>