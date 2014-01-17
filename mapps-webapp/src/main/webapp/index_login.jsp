<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxpasswordinput.js"></script>
    <link rel="stylesheet" href="./jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/main_style.css"> 
</head>
<%
String error = String.valueOf(request.getAttribute("error"));
if (error.equals("null"))
	error = "";
%>
<script type="text/javascript">
	$(document).ready(function () {
    	$("#username").jqxInput({placeHolder: "Usuario", height: 35, width: 220, minLength: 1  });
		$("#password").jqxPasswordInput({placeHolder: "Contraseña", height: 35, width: 220, minLength: 1 });
		$("#loginButton").jqxButton({ width: '100', height: '30'});
    });
</script>

<body>
<div id="header">
	<div id="header_izq">
    
    </div>
    <div id="header_central">
    
    </div>
    <div id="header_der">
    
    </div>

</div>
<div id="container" style="border-top:solid 1px; border-bottom:solid 1px;">
    <div id="login_container" >
        <form action="login" method="post">
        	<center><span class="error"><%= error %></span></center>
            <div id="usernameField" class="loginForm" > Nombre de usuario: </div>
            	<input type="text" class="loginField" name="username" id="username" style="margin-left:20%;" required="required" />
            <div id="passwordField" class="loginForm" > Contrase&ntilde;a: </div>
            	<input type="password" class="loginField" name="password" id="password" style="margin-left:20%; margin-bottom:30px;" required="required" />
            <div id="submit" align="center" >
                <input id="loginButton" type="submit" name="ingresar" value="INGRESAR" />
            </div>
        </form>
    </div>
    <div class="footer">

	</div>
</div>
<div id="pie">

</div>
</body>
</html>
<!--
Nombre del action: "login" method: "post"
username
password
usar require
-->