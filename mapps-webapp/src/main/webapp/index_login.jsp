<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link rel="shortcut icon" href="favicon.ico" />
	<title>Mapps</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <script type='text/javascript' src="./scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxpasswordinput.js"></script>
    <link rel="stylesheet" href="./jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="./jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/main_style.css"> 
</head>
<%
String error = String.valueOf(request.getParameter("error"));
if (error.equals("null"))
	error = "";
	
%>
<script type="text/javascript">
	$(document).ready(function () {
    	$("#username").jqxInput({placeHolder: "Usuario", height: 35, width: 220, minLength: 1, theme: 'metro'  });
		$("#password").jqxPasswordInput({placeHolder: "Contrasena", height: 35, width: 220, minLength: 1, theme: 'metro' });
		$("#loginButton").jqxButton({ width: '100', height: '30', theme: 'metro'});
    });
</script>

<body>
<div id="header">
	<div id="header_izq" style="display:none;">
    
    </div>
    <div id="header_central" style="margin-left:27%;">
    	<img src="./images/logo_mapps.png" style="height:80px; margin-top:15px; margin-left:30%;" />    
    </div>
    <div id="header_der" style="display:none;">
    
    </div>

</div>
<div id="container" style="border-top:solid 1px; border-bottom:solid 1px; min-width:0px;">
    <div id="login_container" >
        <form action="login" method="post">
            <div id="usernameField" class="loginForm" > Nombre de usuario: </div>
            	<input type="text" class="loginField" name="username" id="username" style="margin-left:20%;" />
            <div id="passwordField" class="loginForm" > Contrase&ntilde;a: </div>
            	<input type="password" class="loginField" name="password" id="password" style="margin-left:20%; margin-bottom:30px;" />
            <div id="submit" align="center" >
                <input id="loginButton" type="submit" name="ingresar" value="INGRESAR" />
            </div>
        </form>
        <div id="error_message" style="color:#E00; margin-left:18%; margin-top:10px;">
        	<% if(error.equals("1")){ %>
            Usuario y/o contrase&ntilde;a inv&aacute;lidos
            <% } %>
        </div>
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