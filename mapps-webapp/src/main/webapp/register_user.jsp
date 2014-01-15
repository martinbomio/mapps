<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<%@ page import="com.mapps.model.Gender" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/configuration_template.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxcore.js"></script>
    <!-- InstanceBeginEditable name="EditRegion3" -->
    <script type="text/javascript" src="./jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxpasswordinput.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="./jqwidgets/globalization/globalize.js"></script>
        <script type="text/javascript" src="./scripts/demos.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxmaskedinput.js"></script>
    <link rel="stylesheet" href="./jqwidgets/styles/jqx.office.css" type="text/css" />
    <title>Untitled Document</title>
    
	<!-- InstanceEndEditable -->
	<link rel="stylesheet" href="./jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/main_style.css"> 
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	request.getRequestDispatcher("index_login.jsp");	
}
Role role;
if ( session.getAttribute("role") == null){
	role = null;	
}else{
	role = (Role) session.getAttribute("role");
}
%>
<body>
<!-- InstanceBeginEditable name="EditRegion4" -->
<script type="text/javascript">
	$(document).ready(function () {
	// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '150', mode: 'vertical'});
        $("#jqxMenu").css('visibility', 'visible');
		//name
		$("#name").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 1});
		//lastname
		$("#lastname").jqxInput({placeHolder: "Apellido", height: 25, width: 200, minLength: 1});
		//username
		$("#username").jqxInput({placeHolder: "Nombre de Usuario", height: 25, width: 200, minLength: 1});
		//password
		$("#password").jqxPasswordInput({ placeHolder: "Contraseña", width: 300 , height: 20 , showStrength: true, showStrengthPosition: "right"});
		//email
		$("#email").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 3});
		//Drop list
		$("#gender").jqxDropDownList({ source: ["Male", "Female", "Unknown"], selectedIndex: 1, width: '200', height: '25'});
		//Date
		$("#date").jqxDateTimeInput({width: '250px', height: '25px'});
		//document
		$("#document").jqxMaskedInput({ width: 250, height: 25, mask: '#.###.###-#'});
		//rol
		$("#role").jqxDropDownList({ source: ["User", "Trainer", "Administrator"], selectedIndex: 1, width: '200', height: '25'});
	});
</script>
<!-- InstanceEndEditable -->

<div id="header">
	<div id="header_izq">
    
    </div>
    <div id="header_central">
	<!-- InstanceBeginEditable name="EditRegion1" -->
	
	<!-- InstanceEndEditable -->
    </div>
    <div id="header_der">
	
    </div>
</div>
<div id="contenedor">

<div id="tabs">
	  <div id="tab_1" class="tab active" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab">JUGADORES</div>
        <div id="tab_3" class="tab">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab">MI CLUB</div>
        <div id="tab_5" class="tab" style="margin-right:180px;">CONFIGURACI&Oacute;N</div>
  </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        	<ul>
        		<li><a href="register_user.jsp">Registrar Usuario</a></li>
        	</ul>
        	</div>
        </div>
		<!-- InstanceBeginEditable name="EditRegion7" -->EditRegion7
        
        <div id="main_div">
        	<div id="start_training_div">
            	<form action="/registerUser" method="post">
                	<table width="200" border="0">
                          <tr>
                            <td>Nombre: </td>
                            <td><input name="name" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Apellido: </td>
                            <td><input name="lastName" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Nombre de Usuario: </td>
                            <td><input name="username" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Contraseña: </td>
                            <td><input name="password" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Mail: </td>
                            <td><input name="email" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Género: </td>
                            <td><div id='gender'></div></td>
                          </tr>
                          <tr>
                            <td>Fecha de Nacimiento:</td>
                            <td><div id='date'></div></td>
                          </tr>
                          <tr>
                            <td>Documento: </td>
                            <td><input name="document" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Rol: </td>
                            <td><div id='gender'></div></td>
                          </tr>
                          <tr>
                            <td>Institución: </td>
                            <td>&nbsp;</td>
                          </tr>
                        </table>
                </form>
            </div>
        </div>
        <div id="sidebar_right">
        
        </div>
    </div>
    <!-- InstanceEndEditable -->
    
</div>
<div id="pie">

</div>
</body>
<!-- InstanceEnd --></html>
