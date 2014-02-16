<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<%@ page import="com.mapps.model.Gender" %>
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
	<script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script> 
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	response.sendRedirect("../index_login.jsp");	
}else{
	String trainingStarted = String.valueOf(session.getAttribute("trainingStarted"));
	if (trainingStarted.equals("null"))
	trainingStarted = "";
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

if(info.equals("5")){
	// El Usuario fue modificado con exito
	pop_up_message = "Sus datos fueron modificados con éxito.";
	show_pop_up = true;	
}
if(info.equals("1")){
	
	pop_up_message = "La contraseña fue modificada con exito";
	show_pop_up = true;	
}
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
					
		
		
		// Create a jqxMenu
        $("#jqxMenu2").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu2").css('visibility', 'visible');
        $("#edit").jqxButton({ width: '200', height: '35', theme: 'metro'});
        $("#change_password").jqxButton({ width: '200', height: '35', theme: 'metro'});
        
        $("#edit").on('click', function (){ 
        	window.location.assign("edit_my_user.jsp");
	    });
        $("#change_password").on('click', function (){ 
        	window.location.assign("change_my_password.jsp");
	    });
        
        var url = "/mapps/getUserOfToken";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				get_user_data(response);	            	
            }});
		
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
$("#tabs").jqxMenu({ width: '100%', height: '50px', theme:'metro'});
        
        var centerItems = function () {
            var firstItem = $($("#jqxMenu ul:first").children()[0]);
            firstItem.css('margin-left', 0);
            var width = 0;
            var borderOffset = 2;
            $.each($("#jqxMenu ul:first").children(), function () {
                width += $(this).outerWidth(true) + borderOffset;
            });
            var menuWidth = $("#jqxMenu").outerWidth();
            firstItem.css('margin-left', (menuWidth / 2 ) - (width / 2));
        }
        centerItems();
        $(window).resize(function () {
            centerItems();
        });
	});
	function get_user_data(response){
		var user = response;
		$('#img').html('<img src="'+ user.imageURI+'" style="width:100%;"/>');
		document.getElementById('username').innerHTML=user.userName;
		document.getElementById('institution').innerHTML=user.institution.name;
		document.getElementById('email').innerHTML=user.email;
		document.getElementById('role').innerHTML=user.role;
		document.getElementById('idDocument').innerHTML=user.idDocument;
		document.getElementById('name').innerHTML=user.name;
		document.getElementById('lastName').innerHTML=user.lastName;
		document.getElementById('gender').innerHTML=getGender(user.gender);
		document.getElementById('birth').innerHTML=user.birth;
	}		
	function getGender(gender){
		var gender = "Desconocido";
		if(gender == "Male"){
			gender = "Hombre";
		}else if (gender == "FEMALE"){
			gender = "Mujer";
		}
		return gender;
	}
</script>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left; margin-left:5%;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:40%; height:100%; float:left;">
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
    <div id="header_der" style="display:inline-block; width:20%; height:100%; float:left;">
        <div id="logout" class="up_tab"><a href="../configuration/my_account.jsp">MI CUENTA</a></div>
		<%if(trainingStarted.equals("trainingStarted")){%>
		<div id="logout" class="up_tab"><a href="../index.jsp?logout=1" >CERRAR SESI&Oacute;N</a></div>
		<%}else{ %>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
    <%} %>
    </div>
</div>
<div id="contenedor">
	<div id='tabs' style="background-color:#4DC230; color:#FFF;text-align: center;">
                <ul>
                    <li style="width:18%; text-align:center; margin-left:11%; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;"><a href="../index.jsp">INICIO</a></li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">JUGADORES
                        <ul style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/athletes.jsp">VER</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/add_athletes.jsp">AGREGAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/edit_athletes.jsp">EDITAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/delete_athletes.jsp">ELIMINAR</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">ENTRENAMIENTOS
                        <ul style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="../training/training_reports.jsp">VER ANTERIORES</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/trainings.jsp">COMENZAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/create_training.jsp">PROGRAMAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/edit_training.jsp">EDITAR</a></li>
                            <%}%>
             	   		<%if(role.equals(Role.ADMINISTRATOR)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/change_permissions_training.jsp">EDITAR PERMISOS</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;">CONFIGURACI&Oacute;N
                        <ul style="width:296px;">
                            <li style="text-align:center;font-size:16px;height:30px;">CUENTA
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/my_account.jsp">MI CUENTA</a></li>
                                </ul>
                            </li>
                            <%if(role.equals(Role.ADMINISTRATOR)){%>
                            <li style="text-align:center;font-size:16px;height:30px;">USUARIOS
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/register_user.jsp">AGREGAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/edit_user.jsp">EDITAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/delete_user.jsp">ELIMINAR</a></li>
                                </ul>
                            </li>
                            <li style="text-align:center;font-size:16px;height:30px;">INSTITUCIONES
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/add_institution.jsp">AGREGAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/edit_institution.jsp">EDITAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/delete_institution.jsp">ELIMINAR</a></li>
                                </ul>
                            </li>
                            <%}%>
                            <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;">DEPORTES
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/add_sport.jsp">AGREGAR</a></li>
                                </ul>
                            </li>
                            <li style="text-align:center;font-size:16px;height:30px;">DISPOSITIVOS
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/add_device.jsp">AGREGAR</a></li>
                                    <%if(role.equals(Role.ADMINISTRATOR)){%>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/edit_device.jsp">EDITAR</a></li>
                                    <%}%>
                                </ul>
                            </li>
                            <%}%>
                        </ul>
                    </li>
                </ul>
            </div>
    <div id="area_de_trabajo" style="height:580px;">
		<div id="sidebar_left">
			
        </div>	   
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="configuration_main.jsp">CONFIGURACI&Oacute;N</a> > > >  Mi cuenta
            </div>
            <div id="title" style="margin:15px;">
                
            </div>     	
            <div style="width:100%;display: inline-block;">
                <div id="main_div_left" style="width: 20%;padding-top: 25px">
                	<div id="img" style="float:left; width:100%;">	
                        
                    </div>
                 </div>   
                <div id="main_div_right" style="width:70%;">
                	<div id="otherName" class="my_account_field">
                    	<div class="my_account_tag" >
                        	Nombre:
                        </div>
                        <div class="my_account_data" name="name" id="name">
                        	
                        </div>
                    </div>
                    <div id="otherLastName" class="my_account_field">
                    	<div class="my_account_tag" >
                        	Apellido:
                        </div>
                        <div class="my_account_data" name="lastName" id="lastName">
                        	
                        </div>
                    </div>
                	<div id="otherUsername" class="my_account_field">
                    	<div class="my_account_tag" >
                        	Nombre de usuario:
                        </div>
                        <div class="my_account_data" name="username" id="username">
                        	
                        </div>
                    </div>
                    
                	<div id="document" class="my_account_field">
                    	<div class="my_account_tag">
                        	Documento:
                        </div>
                        <div class="my_account_data" id="idDocument" name="idDocument">
                        	
                        </div>
                    </div>
                    <div id="otherBirth" class="my_account_field">
                    	<div class="my_account_tag">
                        	Fecha de Nacimiento:
                        </div>
                        <div class="my_account_data" id="birth" name="birth">
                        	
                        </div>
                    </div>
                    <div id="otherGender" class="my_account_field">
                    	<div class="my_account_tag">
                        	Sexo:
                        </div>
                        <div class="my_account_data" id="gender" name="gender">
                        	
                        </div>
                    </div>
                    
                    <div id="otherEmail" class="my_account_field">
                    	<div class="my_account_tag">
                        	E-mail:
                        </div>
                        <div class="my_account_data" id="email" name="email">
                        	
                        </div>
                    </div>
                    
                    <div id="otherRole" class="my_account_field">
                    	<div class="my_account_tag">
                        	Rol:
                        </div>
                        <div class="my_account_data" id="role" name="role">
                        	
                        </div>
                    </div>
                	<div id="otherInstitution" class="my_account_field">
                    	<div class="my_account_tag">
                        	Instituci&oacute;n:
                        </div>
                        <div class="my_account_data" id="institution" name="institution">
                        	
                        </div>
                    </div>
                    
                    <div id="otherPassword" class="my_account_field">
                    	<div class="my_account_tag">
                        	Contrase&ntilde;a:
                        </div>
                        <div class="my_account_data" id="password" name="password">
                        	****
                        </div>
                    </div>
                    <div class="main_div_bottom">
                    <div style="width: 100%;margin-top: 25px;">
                		<center><input type="button" id="edit" value="EDITAR DATOS"/></center>
                	</div>
                	<div style="width: 100%;margin-top: 15px;">
                		<center><input type="button" id="change_password" value="CAMBIAR CONTRESE&Ntilde;A"/></center>
                	</div>
                    </div>
                </div>
            </div>
        </div>
        <div id="sidebar_right">
        	
        </div>
    </div>
 
    
</div>
<div id="pie">
<%} %>
</div>
</body>
</html>
