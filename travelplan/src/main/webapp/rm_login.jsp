<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login to MyTravelPlan</title>
<style type="text/css">
body {
	background-color: #f4f4f4;
	color: #5a5656;
	font-family: 'Open Sans', Arial, Helvetica, sans-serif;
	font-size: 16px;
	line-height: 1.5em;
}

a {
	text-decoration: none;
	float: right;
}

h1 {
	font-size: 1em;
}

h1, p {
	margin-bottom: 10px;
}

strong {
	font-size: 20px;
	font-weight: bold;
}

/* ---------- LOGIN ---------- */
#login {
	margin: 50px auto;
	width: 500px;
}

form fieldset input[type="text"], input[type="password"] {
	background-color: #e5e5e5;
	border: none;
	border-radius: 3px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	color: #5a5656;
	font-family: 'Open Sans', Arial, Helvetica, sans-serif;
	font-size: 14px;
	height: 50px;
	outline: none;
	padding: 0px 10px;
	width: 500px;
	-webkit-appearance: none;
}

form fieldset input[type="submit"] {
	background-color: #008dde;
	border: none;
	border-radius: 3px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	color: #f4f4f4;
	cursor: pointer;
	font-family: 'Open Sans', Arial, Helvetica, sans-serif;
	height: 50px;
	text-transform: uppercase;
	width: 500px;
	-webkit-appearance: none;
}

form fieldset a {
	color: #5a5656;
	font-size: 10px;
}

form fieldset a:hover {
	text-decoration: underline;
}
</style>
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript">
    $(function(){

        $("#submit").click(function(){
            var loginName1 = $("input[name='loginName']").val();    //
            var password1 = $("input[name='password']").val();        //
            var jsonUser = {loginName:loginName1, password:password1};    //          
            var strUser = JSON.stringify(jsonUser);    //           
            $.post("", {json: strUser}, callback, "json");
        });

        function callback(json){
            alert(json.msg);    
            if(json.suc == 1){    
                window.location.href = "admin/index.action";    
            }
        }
        
    });
</script>
</head>
<body>
	<div id="login">
		<h1>
			<strong>Welcome. Please Login.</strong> <a href="signup.html">Sign
				Up</a>
		</h1>
		<form action="/login" method="post">

			<fieldset>
				<p>
					UserName:<input type="text" name="userName">
				</p>
				<p>
					Password:<input type="password" name="password">
				</p>
				<p>
					<input type="submit" value="Submit">
				</p>
			</fieldset>
		</form>
	</div>
</body>
</html>