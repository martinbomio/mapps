<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type='text/javascript' src="../scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
	
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" href="../jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	response.sendRedirect("../index_login.jsp");	
}
Role role;
if ( session.getAttribute("role") == null){
	role = null;	
}else{
	role = (Role) session.getAttribute("role");	
}
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";
String error = String.valueOf(request.getParameter("error"));
if (error.equals("null"))
	error = "";
%>
<body>

<script type="text/javascript">

	$(document).ready(function () {
		$("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
	
	});

</script>


<div id="header">
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:15px; margin-left:20px;" /></a>
    </div>
    <div id="header_central">
	
    </div>
    <div id="header_der">
	
    </div>
</div>
<div id="contenedor">
	<div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab active" onclick="location.href='./configuration.jsp">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">

        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
                	<%
					if(role.equals(Role.ADMINISTRATOR)){
					%>
	             	   <li style="height:35px;"><a href="./register_user.jsp"> Agregar un Usuario </a></li>
	             	   <li style="height:35px;"><a href="./edit_user.jsp"> Editar un Usuario </a></li>
	                   <li style="height:35px;"><a href="./delete_user.jsp"> Eliminar un Usuario </a></li>
	             	   <li style="height:35px;"><a href="./add_sport.jsp"> Agregar un Deporte </a></li>
	                   <li style="height:35px;"><a href="./add_institution.jsp"> Agregar una Instituci&oacute;n </a></li>
	                   <li style="height:35px;"><a href="./edit_institution.jsp"> Editar una Instituci&oacute;n </a></li>
	                   <li style="height:35px;"><a href="./delete_institution.jsp"> Eliminar una Instituci&oacute;n </a></li>
	                   <li style="height:35px;"><a href="./add_device.jsp"> Agregar un Dispositivo </a></li>
	                   <li style="height:35px;"><a href="./edit_device.jsp"> Editar un Dispositivo </a></li>
                   <%
					}else if(role.equals(Role.TRAINER)){
                   %>
                   		<li style="height:35px;"><a href="./my_account.jsp"> Mi cuenta </a></li>
                   		<li style="height:35px;"><a href="./add_device.jsp"> Agregar un Dispositivo </a></li>
                   <%
					}else if(role.equals(Role.USER)){
                   %>
                   		<li style="height:35px;"><a href="./my_account.jsp"> Mi cuenta </a></li>
                   <%
					}
                   %>
        		</ul>
  			</div>
        </div>
    </div>   
</div>
<div id="pie">

</div>
</body>
</html>
