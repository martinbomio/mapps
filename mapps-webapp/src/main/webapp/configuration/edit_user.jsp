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
	
			
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '55%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$("#document").jqxMaskedInput({ width: '100%', height: 30, mask: '#.###.###-#', theme: 'metro'});
		$("#username").jqxInput({placeHolder: "Nombre de Usuario", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$('#username').jqxInput({disabled: true });
		$("#date").jqxDateTimeInput({width: '50%', height: '30px', theme: 'metro'});
		$("#email").jqxInput({placeHolder: "e.g: mapps@mapps.com", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$("#gender_list").jqxDropDownList({ source: ["Hombre", "Mujer", "Desconocido"], selectedIndex: 0, width: '50%', height: '30', dropDownHeight: '100', theme: 'metro'});
		$("#role_list").jqxDropDownList({ source: ["Usuario", "Entrenador", "Administrador"], selectedIndex: 0, width: '50%', height: '30', dropDownHeight: '75', theme: 'metro'});
		$("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#validate").on('click', function (){ 
	        $('#edit_user').jqxValidator('validate');
	    });
		$("#file").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 1, theme: 'metro'});
		$("#edit_user").jqxValidator({
            rules: [
                    {input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: "#email", message: "El email es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: '#email', message: 'Invalid e-mail!', action: 'keyup,blur', rule: 'email'},
                    { input: "#document", message: "El documento es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#gender_list", message: "El Género es obligatorio!", action: 'blur', rule: function (input, commit) {
                        var index = $("#gender_list").jqxDropDownList('getSelectedIndex');
                        return index != -1;
                       }
                    },
                    {
                        input: "#role_list", message: "El rol es obligatorio!", action: 'blur', rule: function (input, commit) {
                            var index = $("#role_list").jqxDropDownList('getSelectedIndex');
                            return index != -1;
                        }
                    },
            ],  theme: 'metro'
	        });
		$('#edit_user').on('validationSuccess', function (event) {
	        $('#edit_user').submit();
	    });
		//Get users
		var url = "/mapps/getAllUsers";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				create_list(response);	            	
            }});
		});
	
	function create_list(response){
		var users = response;
		$('#list_users').on('select', function (event) {
            updatePanel(users[event.args.index]);
        });
		$('#list_users').jqxListBox({ selectedIndex: 0,  source: users, displayMember: "firstname", valueMember: "notes", itemHeight: 70, height: '100%', width: '90%', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = users[index];
                var img = '<img height="50" width="50" src="' + datarecord.imageURI + '"/>';
                var table = '<table style="min-width: 130px;"><tr><td style="width: 40px;" rowspan="2">' + img + '</td><td>  ' + datarecord.name + " " + datarecord.lastName + '</td></table>';
                return table;
            }
        });
		updatePanel(users[0]);
	}
	
	function updatePanel(user){
		$('#name').jqxInput('val', user['name']);
		$('#lastName').jqxInput('val', user['lastName']);
		$('#document').jqxMaskedInput('val', user['idDocument']);
		$('#username').jqxInput('val', user['userName']);
		$('#email').jqxInput('val', user['email']);
		var index = 2;
		if (user['gender'] == "FEMALE"){
			index = 1;
		}else if (user['gender'] == "MALE"){
			index = 0;
		}
		$("#gender_list").jqxDropDownList({selectedIndex: get_gender_index(user) });
		$("#role_list").jqxDropDownList({selectedIndex: get_role_index(user) });
		$("#username-hidden").val(user.userName);
		var split = user.birth.split('/');
		$('#date').jqxDateTimeInput('setDate', new Date(split[2], split[1], split[0]));
	}
	
	function get_gender_index(user){
		var index = 2;
		if (user['gender'] == "FEMALE"){
			index = 1;
		}else if (user['gender'] == "MALE"){
			index = 0;
		}
		return index;
	}
	
	function get_role_index(user){
		var index = 0;
		if(user.role == "ADMINISTRATOR"){
			index = 2;
		}else if (user.role == "TRAINER"){
			index = 1;
		}
		return index;
	}
</script>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab"><a href="./configuration/my_account.jsp">MI CUENTA</a></div>
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
    <div id="area_de_trabajo" style="height:560px;">
		<div id="sidebar_left">
			<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
                	<%
					if(role.equals(Role.ADMINISTRATOR)){
					%>
	             	    <li style="height:35px;"> Usuarios..
                       		<ul>
                            	<li style="height:35px;"><a href="./register_user.jsp"> Agregar un Usuario </a></li>
	             	   			<li style="height:35px;"><a href=""> Editar un Usuario </a></li>
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
            	<a href="configuration_main.jsp">CONFIGURACI&Oacute;N</a> >> Editar un usuario
        	</div>
	        <div id="main_div_left" style="float:left; width:40%; display:inline-block;">
            	<div id="title" style="margin:15px;">
                    <label> 1) Seleccione un Usuario </label>
                </div>
        		<div id="list_users">
                </div>
            </div>
            <div id="main_div_right" style="float:right; width:60%; display:inline-block;">
                <form action="/mapps/modifyUser" method="post" name="edit_user" id="edit_user" enctype="multipart/form-data">
                    <div id="title" style="margin:15px;">
                        <label> 2) Modifique los datos que desee </label>
                    </div>
                    <div id="campos" style="margin-left:40px;">
                        <div id="nombre">
                            <div class="tag_form_editar"> Nombre:  </div>
                            <div class="input"><input type="text" name="name" id="name" /></div>
                        </div>
                        <div id="apellido">
                            <div class="tag_form_editar"> Apellido: </div>
                            <div class="input"><input type="text" name="lastName" id="lastName" /></div>
                        </div>
                        <div id="usuario">
                            <div class="tag_form_editar"> Nombre de Usuario: </div>
                            <div class="input"><input type="text" name="username" id="username" /></div>
                        </div>
                        <div id="ci">
                            <div class="tag_form_editar"> C.I.: </div>
                            <div class="input"><input type="text" id="document" /></div>
                        </div>
                        <div id="birth">
                            <div class="tag_form_editar_list">Nacimiento: </div>
                            <div id="date" class="input list_box">
                            </div>
                        </div>
                        <div id='gender'>
                        	<div class="tag_form_editar_list"> Sexo: </div>
                            <div id="gender_list" class="list_box"></div>
                        </div>
                        <div id="e_mail">
                            <div class="tag_form_editar"> Email: </div>
                            <div class="input"><input type="text" name="email" id="email" /></div>
                        </div>
                        <div id='rol'>
                        	<div class="tag_form_editar_list"> Rol: </div>
                            <div id="role_list" class="list_box"></div>
                        </div>
                        <div>
                    		<div class="tag_form"> Imagen: </div>
                        	<div class="input"><input name="file"  id="file" type="file" /></div>
                    	</div>
                    	<div style="margin-left:25%; margin-top:15px;">
                    		<input type="button" id="validate" value="CONFIRMAR"/>
                   		</div>
                    </div>
                    <input type="hidden" id="username-hidden" name="username-hidden"></input>
                </form>
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
