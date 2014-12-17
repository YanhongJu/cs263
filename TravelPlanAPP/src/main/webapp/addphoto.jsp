<%@ page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();
%>


<html>
<head>
<title>Trip Plan Upload photos</title>
</head>
<body>
	<%
		String albumName = request.getParameter("albumName");
		pageContext.setAttribute("albumName", albumName);
	%>
	<form
		action="<%=blobstoreService
					.createUploadUrl("/context/album/upload?albumName="+albumName)%>"
		method="post" enctype="multipart/form-data">		
		Please Choose Images(s) To Upload: <input type="file" multiple
			name="myFile"> <input type="submit" value="Submit">
	</form>
</body>
</html>