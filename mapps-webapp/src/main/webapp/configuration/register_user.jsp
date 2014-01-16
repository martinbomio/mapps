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
    <script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
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
}
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
            	var names = response['name']
            	$("#institution").jqxDropDownList(
                		{
                			source: names,
                			selectedIndex: 0,
                			width: '200',
                			height: '25',
                			dropDownHeight: '100'
                			}
                		);
            	}
            });
	// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		//name
		$("#name").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 1, theme: 'metro'});
		//lastname
		$("#lastname").jqxInput({placeHolder: "Apellido", height: 25, width: 200, minLength: 1, theme: 'metro'});
		//username
		$("#username").jqxInput({placeHolder: "Nombre de Usuario", height: 25, width: 200, minLength: 1, theme: 'metro'});
		//password
		$("#password").jqxPasswordInput({ placeHolder: "Contraseña", width: 200 , height: 25, minLength: 1, theme: 'metro'});
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
		$("#register_button").jqxButton({ width: '150', theme: 'metro'});
		$("#register_button").on('click', function (){ 
	        $('#register_form').jqxValidator('validate');
	    });
		$("#register_form").jqxValidator({
            rules: [
                    {
                        input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'
                    },
                    {
                        input: "#lastname", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'
                    },
                    { input: "#username", message: "El nombre de usuario es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: "#password", message: "La contraseña es obligatoria!", action: 'keyup, blur', rule: 'required'},
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
                    	input: "#date", message: "La Fecha de Nacimiento es obligatoria!", action: 'keyup, blur', rule: 'required' 
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
            ],  hintType: "label"
        });
	});
	
	$('#register_form').on('validationSuccess', function (event) {
        $('#register_button').submit();
    });
</script>

<div id="header">
	<div id="header_izq">
    
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
        <div id="tab_5" class="tab active" onclick="location.href='./configuration.jsp" style="margin-right:180px;">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">

        </div>	   
        <div id="main_div">
        	<div id="start_training_div">
            	<form action="/mapps/registerUser" method="post" id="register_form">
                	<table width="200" border="0">
                          <tr>
                            <td>Nombre: </td>
                            <td><input name="name" id="name" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Apellido: </td>
                            <td><input name="lastName" id="lastname" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Nombre de Usuario: </td>
                            <td><input name="username"  id="username" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Contraseña: </td>
                            <td><input name="password" id="password" type="password" requiered/></td>
                          </tr>
                          <tr>
                            <td>Mail: </td>
                            <td><input name="email" id="email" type="text" required /></td>
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
                            <td><input name="document" id="document" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Rol: </td>
                            <td><div id='role'></div></td>
                          </tr>
                          <tr>
                            <td>Institución: </td>
                            <td><div id='institution'></div></td>
                          </tr>
                          <tr>
                            <td><center></center><input type="submit" value="Registrar" id="register_button" /></center></td>
                          </tr>
                        </table>
                </form>
            </div>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="#"> Agregar un Usuario </a></li>
             	   <li style="height:35px;"><a href="#"> Editar / Eliminar un Usuario </a></li>
             	   <li style="height:35px;"><a href="#"> Agregar un Deporte </a></li>
                   <li style="height:35px;"><a href="#"> Agregar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="#"> Editar / Eliminar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="#"> Agregar un Dispositivo </a></li>
        		</ul>
  			</div>
        </div>
    </div>
 
    
</div>
<div id="pie">

</div>
</body>
</html>
