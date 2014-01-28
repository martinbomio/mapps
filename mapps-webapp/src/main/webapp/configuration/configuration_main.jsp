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
	<script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" href="../jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css">
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script> 
    
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

boolean show_pop_up = false;
String pop_up_message = "";
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";

String error = String.valueOf(request.getParameter("error"));
if (error.equals("null"))
	error = "";

if(info.equals("1")){
	// La Institucion ha sido ingresada con exito
	pop_up_message = "La institucion ha sido ingresada con éxito al sistema.";
	show_pop_up = true;	
}
if(info.equals("2")){
	// El dispositivo ha sido ingresada con exito
	pop_up_message = "El dispositivo ha sido ingresado al sistema con éxito.";
	show_pop_up = true;	
}
if(info.equals("3")){
	pop_up_message = "El usuario ha sido ingresado al sistema con éxito.";
	show_pop_up = true;	
}
if(info.equals("4")){
	pop_up_message = "El deporte ha sido ingresado al sistema con éxito.";
	show_pop_up = true;	
}
if(info.equals("5")){
	pop_up_message = "El usuario ha sido modificado con éxito.";
	show_pop_up = true;	
}
if(info.equals("6")){
	pop_up_message = "La institución ha sido modificado con éxito.";
	show_pop_up = true;	
}
if(info.equals("7")){
	pop_up_message = "El dispositivo ha sido modificado con éxito.";
	show_pop_up = true;	
}
%>
<body>

<script type="text/javascript">

	$(document).ready(function () {
		$("#jqxMenu").jqxMenu({ width: '25%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
        
        
    	$('#pop_up').jqxWindow({ maxHeight: 150, maxWidth: 280, minHeight: 30, minWidth: 250, height: 145, width: 270,
            resizable: false, draggable: false, 
            okButton: $('#ok'), 
            initContent: function () {
                $('#ok').jqxButton({  width: '65px' });
                $('#ok').focus();
            }
        });		
		<%
		if(show_pop_up){	
		%>
			$("#pop_up").css('visibility', 'visible');
		<%
		}else{
		%>
			$("#pop_up").css('visibility', 'hidden');
			$("#pop_up").css('display', 'none');
		<%
		}
		%>
        
	
	});

</script>


<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		<div id="pop_up">
            <div>
                <img width="14" height="14" src="../images/ok.png" alt="" />
                Informaci&oacute;n
            </div>
            <div>
            	<div style="height:60px;">
                	<%=pop_up_message
					%>
                </div>
                <div>
            		<div style="float: right; margin-top: 15px; vertical-align:bottom;">
           		        <input type="button" id="ok" value="OK" style="margin-right: 10px" />
        	        </div>
                </div>
            </div>
        </div>
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab">MI CUENTA</div>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
    </div>
</div>
<div id="contenedor">
	<div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:12%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab active" onclick="location.href='./configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
			<div id="jqxMenu" style="visibility:hidden; margin-left:38%; margin-top:35px;">
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
        <div id="sidebar_right">
        	
        </div>
    </div>   
</div>
<div id="pie">

</div>
</body>
</html>
