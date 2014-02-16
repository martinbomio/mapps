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
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxvalidator.js"></script>
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
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
					
		
		
		
		$("#name").jqxInput({placeHolder: "Pepe", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#email").jqxInput({placeHolder: "pepe@gmail", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		
		
		$("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#validate").on('click', function (){ 
	        $('#edit_user').jqxValidator('validate');
	    });
		
		$("#edit_user").jqxValidator({
            rules: [
                    {input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: "#email", message: "El email es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: '#email', message: 'Invalid e-mail!', action: 'keyup,blur', rule: 'email'},
                  
            ],  theme: 'metro'
	        });
		$('#edit_user').on('validationSuccess', function (event) {
	        $('#edit_user').submit();
	    });
		
		var url = "/mapps/getUserOfToken";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				get_user_data(response);	            	
            }});
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
		document.getElementById('institution').innerHTML=user.institution.name;
		document.getElementById('username').innerHTML=user.userName;
		document.getElementById('idDocument').innerHTML=user.idDocument;
		document.getElementById('role').innerHTML=user.role;
		$('#email').jqxInput('val', user.email);
		$('#name').jqxInput('val', user['name']);
		$('#lastName').jqxInput('val', user['lastName']);
		
		
		
	}
</script>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left; margin-left:5%;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:40%; height:100%; float:left;">
    	
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
            <div style="width:100%; height:100%; font-size:12px;">
            	<form  action="/mapps/modifyMyAccount" method="post" name="edit_user" id="edit_user" >
                    <div id="main_div_left" style="width:32%; height:100%; display:inline-block;">
                        <div id="document" class="my_account_field">
                            <div class="my_account_tag">
                                Documento
                            </div>
                            <div class="my_account_data" id="idDocument" name="idDocument">
                                
                            </div>
                        </div>
                        <div id="email_form" class="my_account_field">
                            <div class="my_account_tag">
                                E-mail
                            </div>
                            <div class="my_account_data">
                                <div class="input"><input type="text" name="email" id="email" /></div>
                            </div>
                        </div>
                        <div id="otherRole" class="my_account_field">
                            <div class="my_account_tag">
                                Rol
                            </div>
                            <div class="my_account_data" id="role" name="role">
                                
                            </div>
                        </div>
                    </div>
                    <div id="main_div_center" style="width:25%; height:100%; display:inline-block;">
                        <div id="img" style="float:left; width:80%; margin-top:35px;">	
                            <img src="../images/users/default.png" style="width:150px;"/>
                        </div>
                        
                        <div id="name_form" style="float:left; margin-top:15px; width:65%; text-align:center; font-size:14px; color:#000;">
                            <div style="margin-top:10px;"> Nombre:  </div>
                            <div style="margin-top:10px;"><input type="text" name="name" id="name" /></div>
                            <div style="margin-top:10px;"> Apellido:  </div>
                            <div style="margin-top:10px;"><input type="text" name="lastName" id="lastName" /></div>
                        </div>
                        
                        <div style="margin-left:-10%; margin-top:35px;">
                    		<input type="button" id="validate" value="CONFIRMAR" style="margin-top:40px; margin-left:5%;"/>
                   		</div>
                    </div>
                    <div id="main_div_right" style="width:32%; height:100%; display:inline-block; margin-left:8%;">
                        
                        <div id="othherInstitution" class="my_account_field">
                            <div class="my_account_tag">
                                Instituci&oacute;n
                            </div>
                            <div class="my_account_data" id="institution" name="institution">
                                
                            </div>
                        </div>
                        
                        <div id="otherUsername" class="my_account_field">
                    		<div class="my_account_tag" >
                        		Nombre de usuario
                        	</div>
                        	<div class="my_account_data" name="username" id="username">
                        	
                        	</div>
                    	</div>
                    	
                        <div id="otherPassword" class="my_account_field">
                            <div class="my_account_tag">
                                Contrase&ntilde;a
                            </div>
                            <div class="my_account_data" id="password" name="password">
                              ****  
                            </div>
                        </div>
                    </div>
                 </form>
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
