<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<%@ page import="com.mapps.model.Gender" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link rel="shortcut icon" href="../favicon.ico" />
	<title>Mapps</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
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
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxvalidator.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmaskedinput.js"></script>
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
		set_tab_child_length();
		$("#birth").jqxDateTimeInput({width: '100%', height: '30px', theme: 'metro'});
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#idDocument").jqxMaskedInput({ width: '100%', height: 30, mask: '#.###.###-#', theme: 'metro'});
		$("#email").jqxInput({placeHolder: "E-Mail", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#gender").jqxDropDownList({ source: ["Hombre", "Mujer", "Desconocido"], selectedIndex: 0, width: '50%', height: '30', dropDownHeight: '100', theme: 'metro'});
		$("#image").jqxButton({ height: 30, width: '65%', theme: 'metro'});
		$("#image").on('click', function (){ 
	        $('#file').click();
	    });
		$("#file").change( function() {
			readURL(this);
		});
		$("#edit").jqxButton({ width: '200', height: '35', theme: 'metro'});
        $("#edit").on('click', function (){ 
        	$('#edit_user').jqxValidator('validate');
	    });
        $('#edit_user').on('validationSuccess', function (event) {
	        $('#edit_user').submit();
	    });
        
        $("#edit_user").jqxValidator({
            rules: [
					{
					    input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'
					},
					{
					    input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'
					},
					{ input: "#email", message: "El email es obligatorio!", action: 'keyup, blur', rule: 'required'},
	                { input: '#email', message: 'Invalid e-mail!', action: 'keyup,blur', rule: 'email'},
	                { input: "#idDocument", message: "El documento es obligatorio!", action: 'keyup, blur', rule: 'required'},
	                {
	                  input: "#gender", message: "El Género es obligatorio!", action: 'blur', rule: function (input, commit) {
	                  var index = $("#gender").jqxDropDownList('getSelectedIndex');
	                  return index != -1;
	                  }
	                },
                    
            ],  theme: 'metro'
	        });
        
        var url = "/mapps/getUserOfToken";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				get_user_data(response);	            	
            }});
		
		$("#tabs").jqxMenu({ width: '100%', height: '50px',theme:'metro'});
        
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
        set_tab_child_length();
        centerItems();
        $(window).resize(function () {
      	  set_tab_child_length();
            centerItems();
        });
});
function set_tab_child_length(){
	var size = $('#ref_tab').width();
	for (var i=0; i<3; i++){
		$('#ul_'+i+'').width(size + 12);
	}
}
	
	function get_user_data(response){
		var user = response;
		$('#img').html('<img src="'+ user.imageURI+'" style="width:100%;"/>');
		document.getElementById('username').innerHTML=user.userName;
		document.getElementById('institution').innerHTML=user.institution.name;
		document.getElementById('role').innerHTML=user.role;
		
		$('#email').val(user.email);
		$('#idDocument').val(user.idDocument);
		$('#name').val(user.name);
		$('#lastName').val(user.lastName);
		var split = user.birth.split("/");
		$("#birth").jqxCalendar('val', new Date(split[2], parseInt(split[1]) - 1, split[0]));
		var index = 2;
		if (user['gender'] == "FEMALE"){
			index = 1;
		}else if (user['gender'] == "MALE"){
			index = 0;
		}
		$("#gender").jqxDropDownList({selectedIndex: index });
	}		
	
	function readURL(input) {
	    if (input.files && input.files[0]) {
	        var reader = new FileReader();
	        reader.onload = function (e) {
	        	$('#img').html('<img src="'+ e.target.result +'" style="width:100%;"/>');
	        }
	        reader.readAsDataURL(input.files[0]);
	    }
	}
	
</script>

<div id="header">
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central">
		
    </div>
    <div id="header_der">
        <div id="logout" class="up_tab"><a href="./my_account.jsp">MI CUENTA</a></div>
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
                    <li id="ref_tab" style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">JUGADORES
                        <ul id="ul_0" style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/athletes.jsp">VER</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/add_athletes.jsp">AGREGAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/edit_athletes.jsp">EDITAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/delete_athletes.jsp">ELIMINAR</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">ENTRENAMIENTOS
                        <ul id="ul_1" style="width:296px;">
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
                        <ul id="ul_2" style="width:296px;">
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
                    <div style="float: left;width: 100%; margin-top: 10px;">
                        <center><input type="button" id="image" value="CAMBIAR IMAGEN" /></center>
                    </div>
                 </div>   
                <div id="main_div_right" style="width:70%;">
                <form action="/mapps/modifyMyAccount" method="post" name="edit_user" id="edit_user" enctype="multipart/form-data">
                	<div id="otherName" class="my_account_field">
                    	<div class="my_account_tag" >
                        	Nombre:
                        </div>
                        <div class="my_account_data" >
                        	<input type="text" name="name" id="name" />
                        </div>
                    </div>
                    <div id="otherLastName" class="my_account_field">
                    	<div class="my_account_tag" >
                        	Apellido:
                        </div>
                        <div class="my_account_data">
                        	<input type="text" id="lastName" name="lastName" />
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
                        <div class="my_account_data" >
                        	<input type="text" id="idDocument" name="idDocument" />
                        </div>
                    </div>
                    
                    <div id="otherBirth" class="my_account_field">
                    	<div class="my_account_tag">
                        	Fecha de Nacimiento:
                        </div>
                        <div class="my_account_data">
                        	<div id="birth" class="input list_box"></div>
                        </div>
                    </div>
                    <div id="otherGender" class="my_account_field">
                    	<div class="my_account_tag">
                        	Sexo:
                        </div>
                        <div class="my_account_data">
                        	<div id="gender" class="list_box"></div>
                        </div>
                    </div>
                    
                    <div id="otherEmail" class="my_account_field">
                    	<div class="my_account_tag">
                        	E-mail:
                        </div>
                        <div class="my_account_data" >
                        	<input type="text" id="email" name="email"/>
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
                    <div style="width: 100%; margin-top: 45px;float: left;">
                		<center><input type="button" id="edit" value="CONFIRMAR"/></center>
                	</div>
                	<div style="height:0px;overflow:hidden">
                        		<input name="file"  id="file" type="file" />
                    </div>
                	</form>
                </div>
                <div class="main_div_bottom">
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
