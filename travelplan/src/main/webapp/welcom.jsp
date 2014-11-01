<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<style>
ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
	overflow: hidden;
}

li {
	float: right;
}

/* ul li {
  position: relative; 
}

ul li a:only-child {
	background: none;
}

ul li:hover>ul {
	display: block;
}

ul ul {
	position: absolute;
	top: 100%;
	list-style: none;
	display: none;
} */
a:link, a:visited {
	display: block;
	width: 140px;
	font-size: 160%;
	font-weight: bold;
	color: white;
	background-color:;
	text-align: center;
	padding: 4px;
	text-decoration: none;
}

a:hover, a:active {
	background-color: #CCDDFF;
}
</style>
</head>
<body>
	<%
		boolean isLogin = false;
		String loginName = request.getParameter("userName");
		if (loginName != null && !"".equals(loginName)) {
			isLogin = true;
			System.out.println(loginName);
			pageContext.setAttribute("userName", loginName);
			pageContext.setAttribute("displayLogin", "none");
			pageContext.setAttribute("displayUser", "block");
		}
		else {
			pageContext.setAttribute("displayLogin", "block");
			pageContext.setAttribute("displayUser", "none");
		}

	%>
	
	<div id="Layer1"
	style="position: absolute; width: 100%; height: 100%; z-index: -1">
	<img src="images\back.jpg" height="100%" width="100%" />
</div>
<ul>

	
	<li><a  href="">Welcom! ${fn:escapeXml(userName)}</a></li> 
	<li><a href="">MyBlog</a></li>
	<li><a href="">MyPlans</a></li>
	<li><a href="newplan.jsp?userName= ${fn:escapeXml(userName)}">PlanATrip</a> <!-- <ul>
				<li><a href="">Create a new Plan</a></li>
				<li><a href="">Edit a Plan</a></li>
			</ul> --></li>


</ul>
</body>


</html>