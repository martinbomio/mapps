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
    <script type="text/javascript" src="../scripts/demos.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxpasswordinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmaskedinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
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
		//Get Institutions
		var url = "/mapps/getAllInstitutions";
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
            	$("#institution").jqxDropDownList(
                		{
                			source: response,
                			selectedIndex: 0,
                			displayMember: "name",
                			valueMember:"name",
                			width: '200',
                			height: '25',
                			dropDownHeight: '100',
							theme: 'metro',
                			}
                		);
            	}
            });
			
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '55%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		//name
		$("#name").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 1, theme: 'metro'});
		//lastname
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 25, width: 200, minLength: 1, theme: 'metro'});
		//username
		$("#username").jqxInput({placeHolder: "Nombre de Usuario", height: 25, width: 200, minLength: 1, theme: 'metro'});
		//password
		$("#password").jqxPasswordInput({ placeHolder: "Contraseña", width: 200 , height: 25, showStrength: true, showStrengthPosition: "right" , theme: 'metro'});
		//passowrdConfirm
		$("#passwordConfirm").jqxPasswordInput({  placeHolder: 'Repetir contraseña', width: '200px', height: '25px', theme: 'metro' });
        //email
		$("#email").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 3, theme: 'metro'});
		//Drop list
		$("#gender").jqxDropDownList({ source: ["Hombre", "Mujer", "Desconocido"], selectedIndex: 0, width: '200', height: '25', dropDownHeight: '100', theme: 'metro'});
		//Date
		$("#date").jqxDateTimeInput({width: '200px', height: '25px', theme: 'metro'});
		//document
		$("#document").jqxMaskedInput({ width: 200, height: 25, mask: '#.###.###-#', theme: 'metro'});
		//rol
		$("#role").jqxDropDownList({ source: ["Usuario", "Entrenador", "Administrador"], selectedIndex: 0, width: '200', height: '25', dropDownHeight: '75', theme: 'metro'});
		//register
		$("#register_button").jqxButton({ width: '150', height: '35', theme: 'metro'});
		
		$("#register_button").on('click', function (){ 
	        $('#register_form').jqxValidator('validate');
	    });
		
		$('#register_form').on('validationSuccess', function (event) {
	        $('#register_form').submit();
	    });
		
		$("#register_form").jqxValidator({
            rules: [
                    {
                        input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'
                    },
                    {
                        input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'
                    },
                    { input: "#username", message: "El nombre de usuario es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: "#password", message: "La contraseña es obligatoria!", action: 'keyup, blur', rule: 'required'},
					{ input: "#passwordConfirm", message: "La contraseña es obligatoria!", action: 'keyup, blur', rule: 'required' },
					{
                        input: "#passwordConfirm", message: "Las contraseñas deben coincidir!", action: 'keyup, blur', rule: function (input, commit) {
                            var firstPassword = $("#password").jqxPasswordInput('val');
                            var secondPassword = $("#passwordConfirm").jqxPasswordInput('val');
                            return firstPassword == secondPassword;
                        }
                    },
                    { input: "#email", message: "El email es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: '#email', message: 'Invalid e-mail!', action: 'keyup,blur', rule: 'email'},
                    { input: "#document", message: "El documento es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {
                        input: "#gender", message: "El Género es obligatorio!", action: 'blur', rule: function (input, commit) {
                            var index = $("#gender").jqxDropDownList('getSelectedIndex');
                            return index != -1;
                        }
                    },
                    {
                        input: "#role", message: "El rol es obligatorio!", action: 'blur', rule: function (input, commit) {
                            var index = $("#role").jqxDropDownList('getSelectedIndex');
                            return index != -1;
                        }
                    },
                    {
                        input: "#institution", message: "La institución es obligatoria!", action: 'blur', rule: function (input, commit) {
                            var index = $("#institution").jqxDropDownList('getSelectedIndex');
                            return index != -1;
                        }
                    }
            ],  theme: 'metro'
        });
	});
	
	
</script>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab"><a href="./my_account.jsp">MI CUENTA</a></div>
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
    <div id="area_de_trabajo" style="height:580px;">
		<div id="sidebar_left">
			<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
                	<%
					if(role.equals(Role.ADMINISTRATOR)){
					%>
	             	    <li style="height:35px;"> Usuarios..
                       		<ul>
                            	<li style="height:35px;"><a href=""> Agregar un Usuario </a></li>
	             	   			<li style="height:35px;"><a href="./edit_user.jsp"> Editar un Usuario </a></li>
	                   			<li style="height:35px;"><a href="./delete_user.jsp"> Eliminar un Usuario </a></li>
                            </ul>
                        </li>
                        <li style="height:35px;"> Instituciones..
	             	   		<ul>
                                <li style="height:35px;"><a href="./add_institution.jsp"> Agregar una Instituci&oacute;n </a></li>
                                <li style="height:35px;"><a href="./edit_institution.jsp"> Editar una Instituci&oacute;n </a></li>
                                <li style="height:35px;"><a href="./delete_institution.jsp"> Eliminar una Instituci&oacute;n </a></li>
                            </ul>
                        </li>
                        <li style="height:35px;"> Deportes..
                        	<ul>
                       			<li style="height:35px;"><a href="./add_sport.jsp"> Agregar un Deporte </a></li>
                            </ul>
                        </li>
                        <li style="height:35px;"> Dispositivos..
                        	<ul>
                                <li style="height:35px;"><a href="./add_device.jsp"> Agregar un Dispositivo </a></li>
                                <li style="height:35px;"><a href="./edit_device.jsp"> Editar un Dispositivo </a></li>
                            </ul>
                        </li>
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
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="configuration_main.jsp">CONFIGURACI&Oacute;N</a> >> Agregar un Usuario
            </div>
            <div id="title" style="margin:15px;">
                <label> Complete el siguiente formulario </label>
            </div>     	
            <div style="margin-left:100px;">
            	<form action="/mapps/registerUser" method="post" id="register_form">
                	<div id="nombre">
                        <div class="tag_form"> Nombre:  </div>
                        <div class="input"><input type="text" name="name" id="name" /></div>
                    </div>
                    <div id="apellido">
                        <div class="tag_form"> Apellido: </div>
                        <div class="input"><input type="text" name="lastName" id="lastName" /></div>
                    </div>
                    <div>
                    	<div class="tag_form"> Nombre de usuario: </div>
                        <div class="input"><input name="username"  id="username" type="text" /></div>
                    </div>
                    <div>
                    	<div class="tag_form"> Contrase&ntilde;a: </div>
                        <div class="input"><input name="password" id="password" type="password"/></div>
                    </div>
                    <div>
                    	<div class="tag_form"> Repetir contrase&ntilde;a: </div>
                        <div class="input"><input name="passwordConfirm" id="passwordConfirm" type="password"/></div>
                    </div>
                    <div id="e_mail">
                        <div class="tag_form"> Email: </div>
                        <div class="input"><input type="text" name="email" id="email" /></div>
                    </div>
                    <div id='gender_field'>
                      	<div class="tag_form"> Sexo: </div>
                        <div id="gender" style="display:inline-block; margin-top:10px">
                        </div>
                    </div>
                    <div id="birth">
                        <div class="tag_form">Nacimiento: </div>
                        <div id="date" class="input">
                        </div>
                    </div>
                    <div id="ci">
                        <div class="tag_form"> C.I.: </div>
                        <div class="input"><input type="text" id="document" /></div>
                    </div>
                    <div>
                        <div class="tag_form"> Rol: </div>
                        <div id="role" class="input">
                        </div>
                    </div>
                    <div id="institution_field">
                        <div class="tag_form"> Instituci&oacute;n: </div>
                        <div id="institution" class="input">
                        
                        </div>
                    </div>
                   	<div style="margin-left:25%; margin-top:10px;">
                    	<input type="button" value="Registrar" id="register_button" />
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
