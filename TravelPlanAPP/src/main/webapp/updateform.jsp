<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Trip Plan Update</title>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js">
	
</script>
<script language="JavaScript">
	window.onload = function() {
		strYYYY = document.form1.YYYY.outerHTML;
		strMM = document.form1.MM.outerHTML;
		strDD = document.form1.DD.outerHTML;
		MonHead = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

		var y = new Date().getFullYear();
		var str = strYYYY.substring(0, strYYYY.length - 9);
		for (var i = (y - 30); i < (y + 30); i++) {
			str += "<option value='" + i + "'> " + i + "</option>\r\n";
		}
		document.form1.YYYY.outerHTML = str + "</select>";

		var str = strMM.substring(0, strMM.length - 9);
		for (var i = 1; i < 13; i++) {
			str += "<option value='" + i + "'> " + i + "</option>\r\n";
		}
		document.form1.MM.outerHTML = str + "</select>";

		document.form1.YYYY.value = y;
		document.form1.MM.value = new Date().getMonth() + 1;
		var n = MonHead[new Date().getMonth()];
		if (new Date().getMonth() == 1 && IsPinYear(YYYYvalue))
			n++;
		writeDay(n);
		document.form1.DD.value = new Date().getDate();
	}
	function YYYYMM(str) {
		var MMvalue = document.form1.MM.options[document.form1.MM.selectedIndex].value;
		if (MMvalue == "") {
			DD.outerHTML = strDD;
			return;
		}
		var n = MonHead[MMvalue - 1];
		if (MMvalue == 2 && IsPinYear(str))
			n++;
		writeDay(n)
	}
	function MMDD(str) {
		var YYYYvalue = document.form1.YYYY.options[document.form1.YYYY.selectedIndex].value;
		if (str == "") {
			DD.outerHTML = strDD;
			return;
		}
		var n = MonHead[str - 1];
		if (str == 2 && IsPinYear(YYYYvalue))
			n++;
		writeDay(n)
	}
	function writeDay(n) {
		var s = strDD.substring(0, strDD.length - 9);
		for (var i = 1; i < (n + 1); i++)
			s += "<option value='" + i + "'> " + i + "</option>\r\n";
		document.form1.DD.outerHTML = s + "</select>";
	}
	function IsPinYear(year) {
		return (0 == year % 4 && (year % 100 != 0 || year % 400 == 0))
	}
//-->
</script>
</head>
<body>
	<%
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		pageContext.setAttribute("userName", userName);
		String planName = request.getParameter("planName");
		pageContext.setAttribute("planName", planName);
		String activityTitle = request.getParameter("title");
		pageContext.setAttribute("activityTitle", activityTitle);
		String address = request.getParameter("address");
		pageContext.setAttribute("address", address);
		String notes = request.getParameter("notes");
		pageContext.setAttribute("notes", notes);
		String day = request.getParameter("day");
		pageContext.setAttribute("day", day);
		String startDate = request.getParameter("startDate");
		pageContext.setAttribute("startDate", startDate);
	%>
	<form id="submitform" name="form1"
		action="/context/enqueue/updateactivity/?planName=${fn:escapeXml(planName)}&startDate=${fn:escapeXml(startDate)}"
		method="post">

		<h2>Update information:</h2>
		<p>
			Title:<input type="text" name="activityTitle" style="width: 80%"
				value="${fn:escapeXml(activityTitle)}">
		</p>
		<p>
			Address:<input id="pac-input" name="address" class="controls"
				type="text" style="width: 80%" value="${fn:escapeXml(address)}">
		</p>

		<div>
			<p>Day</p>
			<span> <select name="day"
				onchange="this.parentNode.nextSibling.value=this.value">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
			</select>
		</div>
		<p>
			Notes:<input type="text" name="notes" style="width: 90%"
				value="${fn:escapeXml(notes)}">
		</p>

		<p>
			<input type="submit" value="Submit">
		</p>

	</form>

	<script>
		$("#submitform").submit(function(event) {
			var planName = document.forms["form1"]["activityTitle"].value;

			event.preventDefault();
			if (planName == null || planName == "") {
				alert("Title can not be empty!");
			} else
				$('#submitform').unbind('submit').submit();

		});
	</script>

</body>
</html>