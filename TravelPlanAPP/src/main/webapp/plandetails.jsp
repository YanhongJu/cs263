<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<style>
<!--
.nav ul{
aligh:center;
width:100%;
margin:0px auto 0px auto;
list-style:none;
}

.nav ul li{
float:left;
}
.nav ul li a{
width:150px;/*设置元素宽为80px*/
height:30px;/*设置高度为28px*/
line-height:28px;/*设置行距为28px，让文字在每行的中间位置*/
background:#01A9DB;/*设置元素的背景为红色*/
color:#FFF;/*文字颜色是白色*/
margin:5px 10px;
font-size:16px;/*用12号字*/
display:block;/*这个比较关键，因为a本身就是联级元素，本身不具有宽高，用这个把它变成块级元素，这样前面设置的宽和高就能起作用了*/
text-align:center;/*让文本居中*/
text-decoration:none; /*去掉下划线*/
}
.nav ul li a:hover{ /*这个大概的意思就是当鼠标放到这个a元素的上面时，这个a元素的样式就按下面的代码执行*/
background:#08298A;
}
p {
display: block;
-webkit-margin-before: 0;
-webkit-margin-after: 0;
-webkit-margin-start: 0px;
-webkit-margin-end: 0px;
}
-->
</style>
</head>
<body>


<%
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		/* String loginName = request.getParameter("userName"); */
		pageContext.setAttribute("userName", userName);
		String planName = request.getParameter("planName");
		pageContext.setAttribute("planName", planName);
		String date = request.getParameter("date");
		pageContext.setAttribute("date", date);
%>
<p align="center"><font size="3">Plan details for your trip(Start From ${fn:escapeXml(date)}):</font></p>
<p align="center"> <font face="verdana" size="8" color="#0B173B"> ${fn:escapeXml(planName)}</font>
</p>
<div class="nav">
 <ul>
   <li><a href="activity.html" target="iframe_a">Activities</a></li>
   <li><a href="fooddrink.html" target="iframe_a">Food & Drinks</a></li>
   <li><a href="hotel.html" target="iframe_a">Hotels</a></li>
   <li><a href="#" target="iframe_a">Flights</a></li>
 </ul>
</div>
<div class="searchframe">
<iframe src="activity.html" name="iframe_a" width=100% height=80% frameborder="0"></iframe>
</div>


</body>
</html>