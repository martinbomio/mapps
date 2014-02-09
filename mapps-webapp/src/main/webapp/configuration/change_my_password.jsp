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
    <script type="text/javascript" src="../jqwidgets/jqxpasswordinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
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
boolean show_pop_up = false;
String pop_up_message = "";
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";
String error = String.valueOf(request.getParameter("error"));
if (error.equals("null"))
	error = "";

if(info.equals("2")){
	pop_up_message = "La contraseña anterior no es la correcta, vuelva a intentarlo";
	show_pop_up = true;	
}

%>


<body>

<script type="text/javascript">
	$(document).ready(function () {
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '55%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');


		$("#oldPassword").jqxPasswordInput({placeHolder: "Antigua contraseña", height: 25, width: 200, minLength: 1, theme: 'metro'});
		$("#newPassword").jqxPasswordInput({ placeHolder: "Nueva contraseña", width: 200 , height: 25, showStrength: true, showStrengthPosition: "right" , theme: 'metro'});
		//passowrdConfirm
		$("#newPasswordConfirm").jqxPasswordInput({  placeHolder: 'Repetir contraseña', width: '200px', height: '25px', theme: 'metro' });
		
		
		$("#changePassword_button").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#changePassword_button").on('click', function (){ 
	        $('#changePassword_form').jqxValidator('validate');
	    });
		$("#changePassword_form").jqxValidator({
            rules: [
                    {
                        input: "#oldPassword", message: "La contraseña anterior es obligatoria!", action: 'keyup, blur', rule: 'required'
                    },
                    
                    { input: "#newPassword", message: "La nueva contraseña es obligatoria!", action: 'keyup, blur', rule: 'required'},
					{ input: "#newPasswordConfirm", message: "La nueva contraseña es obligatoria!", action: 'keyup, blur', rule: 'required' },
					{
                        input: "#newPasswordConfirm", message: "Las contraseñas deben coincidir!", action: 'keyup, blur', rule: function (input, commit) {
                            var firstPassword = $("#newPassword").jqxPasswordInput('val');
                            var secondPassword = $("#newPasswordConfirm").jqxPasswordInput('val');
                            return firstPassword == secondPassword;
                        }
                    },
                    
           
            ],  theme: 'metro'
        });
	
		$('#changePassword_form').on('validationSuccess', function (event) {
        	$('#changePassword_form').submit();
   		 });
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
    <div id="area_de_trabajo">
		<div id="sidebar_left">
			<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
                	<%
					if(role.equals(Role.ADMINISTRATOR)){
					%>
	             	    <li style="height:35px;"> Usuarios..
                       		<ul>
                            	<li style="height:35px;"><a href="./register_user.jsp"> Agregar un Usuario </a></li>
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
                       			<li style="height:35px;"><a href=""> Agregar un Deporte </a></li>
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
            	<a href="configuration_main.jsp">CONFIGURACI&Oacute;N</a> >> Modificar contraseña
            </div>
            <div id="title" style="margin:15px;">
                <label> Complete el siguiente formulario </label>
            </div>  
            <div style="margin-left:100px;">  
            	<form action="/mapps/changePassword" method="post" id="changePassword_form">
                	<div id="passVieja">
                        <div class="tag_form"> Antigua contraseña:  </div>
                        <div class="input"><input type="text" name="oldPassword" id="oldPassword" type="password"/></div>
                    </div>
                    <div id="passNueva">
                        <div class="tag_form"> Nueva contraseña:  </div>
                        <div class="input"><input type="text" name="newPassword" id="newPassword" type="password"/></div>
                    </div>
                    <div id="confirmacion">
                        <div class="tag_form"> Confirmar nueva contraseña:  </div>
                        <div class="input"><input type="text" name="newPasswordConfirm" id="newPasswordConfirm" type="password"/></div>
                    </div>
                    <div style="margin-left:25%; margin-top:25px;">
                    	<input type="button" value="Modificar contraseña" id="changePassword_button" />
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