<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/header.css" />
<style>
#formpage {clear ="both";
	
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Trip Plan New Plan</title>
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
		BlobstoreService blobstoreService = BlobstoreServiceFactory
				.getBlobstoreService();
	%>
	<div id="container">
		<div id="header" class="headernav">
			<h3 float="right">Welcom! ${fn:escapeXml(userName)}</h3>
			<ul>
				<li><a
					href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
						out</a></li>
				<li><a href="album.jsp">MyAlbum</a></li>
				<li><a href="allplans.jsp">MyPlans</a></li>
				<li><a href="newplan.jsp">PlanATrip</a>
				<li><a href="welcom.jsp">Home</a> <!-- <ul>
				<li><a href="">Create a new Plan</a></li>
				<li><a href="">Edit a Plan</a></li>
			</ul> --></li>
			</ul>
		</div>


		<div class="formpage" style="position: relative; left: 150px;">
			<form name="form1" id="submitform" action="/context/enqueue/newplan"
				method="post">

				<fieldset>
					<h2>Please Enter Your Tip Information</h2>
					<p>
						Name Your New Trip:<input type="text" name="planName">

					</p>
					<p>Enter Your Start Date:</p>
					<select name=YYYY onchange="YYYYMM(this.value)">
						<option value="">Year</option>
					</select> <select name=MM onchange="MMDD(this.value)">
						<option value="">Month</option>
					</select> <select name=DD>
						<option value="">Day</option>
					</select>

					<p>
						<input type="submit" value="Continue to plan details">
					</p>

				</fieldset>


			</form>


			<script>
				$("#submitform")
						.submit(
								function(event) {
									var planName = document.forms["form1"]["planName"].value;
									var validate;
									event.preventDefault();		
									if (planName == null || planName == "") {
										alert("Please enter a planName");										
									} else {
										$
												.getJSON(
														"context/checkform/plan/"
																+ planName,
														function(data) {
															//alert(data.result);
															if (data.result == "true") {
																alert("Plan already exists! Go to MyPlan to update or Create new plan with another name");
																							
															} else {
																//alert("valid input");
																$('#submitform').unbind('submit').submit();
															}

														});
									}

								});
			</script>

			<%-- <h2>You Can Also Upload A Plan File:</h2>
			<form action="<%= blobstoreService.createUploadUrl("/context/enqueue/uploadplan") %>" method="post" enctype="multipart/form-data">
				<fieldset>
					<p>
						Name Of The Trip:<input type="text" name="planName">

					</p>
					<p>
						<input type="file" name="myFile"> <input type="submit"
							value="Upload">

					</p>

				</fieldset>
			</form> --%>

		</div>
	</div>


</body>


</html>
