<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trip plan New Album</title>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js">
	
</script>
</head>
<body>
	<form id="submitform" name='form1' action='/context/album/newalbum' method='post'>
		<p>
			Name Your New Album:<input type="text" name="albumName">
		</p>
		<p>
			Notes about this album:<input type="text" name="notes">
		</p>
		<p>
			<input type="submit" value="Submit">
		</p>

	</form>
	<script>
				$("#submitform")
						.submit(
								function(event) {
									var albumName = document.forms["form1"]["albumName"].value;
									var validate;
									event.preventDefault();		
									if (albumName == null || albumName == "") {
										alert("Please enter album name");										
									} else {
										$
												.getJSON(
														"context/checkform/album/"
																+ albumName,
														function(data) {
															//alert(data.result);
															if (data.result == "true") {
																alert("albumName already exists!");
																							
															} else {
																//alert("valid input");
																$('#submitform').unbind('submit').submit();
															}

														});
									}

								});
			</script>
	
	
</body>
</html>