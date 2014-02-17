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
	<script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../scripts/demos.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxpasswordinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmaskedinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxnumberinput.js"></script>
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

String info = String.valueOf(request.getAttribute("info"));
if (info.equals("null"))
	info = "";
String error = String.valueOf(request.getAttribute("error"));
if (error.equals("null"))
	error = "";

%>
<body>

<script type="text/javascript">

	$(document).ready(function () {
		 set_tab_child_length();
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: '80%', minLength: 1, theme: 'metro'  });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: '80%', minLength: 1, theme: 'metro'  });
		$("#weight").jqxInput({placeHolder: "Peso (kg)", height: 30, width: '80%', minLength: 1, theme: 'metro'  });
		$("#height").jqxMaskedInput({ height: 30, width: '80%', mask: '#.##', theme: 'metro'  });
		$("#email").jqxInput({placeHolder: "jose@gmail.com", height: 30, width: '80%', minLength: 1, theme: 'metro'  });
		$("#document").jqxMaskedInput({height: 30, width: '80%', mask: '#.###.###-#', theme: 'metro'  });
		
		$("#addAthlete_button").jqxButton({ width: '150', height: '35', theme: 'metro'});
	
		//getAllInstitutions
		var url = "/mapps/getAllInstitutions";
		$.ajax({
			url: url,
			type: "GET",
			success: function (response){
				var names = response;
				$("#institution").jqxDropDownList(
						{
							source: names,
							displayMember: "name",
							valueMember:"name",
							selectedIndex: 0,
							width: '40%',
							height: '30',
							dropDownHeight: '100',
							theme: 'metro'
							}
						);
				}
			});

		//Drop list
		$("#gender").jqxDropDownList({ source: ["Hombre", "Mujer", "Desconocido"], selectedIndex: 2, width: '40%', height: '25', dropDownHeight: '100', theme: 'metro'});
		//Date
		$("#date").jqxDateTimeInput({width: '40%', height: '30px', theme: 'metro'});
	
		
		//addAthlete
		$("#addAthlete_button").jqxButton({ width: '200', height: 35});
		$("#addAthlete_button").on('click', function (){ 
			$('#addAthlete_form').jqxValidator('validate');
		});
	
		$("#addAthlete_form").jqxValidator({
			rules: [
					{
						input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'
					},
					{
						input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'
					},
					{ input: "#weight", message: "El peso del atleta es obligatorio!", action: 'keyup, blur', rule: 'required'},
					{ input: "#weight", message: "El debe ser un numero del 0-999!", action: 'keyup, blur', rule: function(){
						var value = $("#weight").val();
						return ($.isNumeric(value) && value>=0 && value<=999);
					}},
					{ input: "#height", message: "La altura del atleta es obligatoria!", action: 'keyup, blur', rule: 'required'},
					{ input: "#height", message: "La altura debe ser un numero!", action: 'keyup, blur', rule: function(){
						var value = $("#height").val();
						return $.isNumeric(value);
					}},
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
						input: "#institution", message: "La institución es obligatoria!", action: 'blur', rule: function (input, commit) {
							var index = $("#institution").jqxDropDownList('getSelectedIndex');
							return index != -1;
						}
					}
			], theme: 'metro'
    	});
	$('#addAthlete_form').on('validationSuccess', function (event) {
    	$('#addAthlete_form').submit();
	});
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
</script>


<div id="header">
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central">
		
    </div>
    <div id="header_der">
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
                    <li id="ref_tab" style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;">JUGADORES
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
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">CONFIGURACI&Oacute;N
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
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        	
        </div>
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./athletes.jsp">JUGADORES</a> >> Agregar
            </div>
            <div id="add_div">
            <div id="title" style="margin:15px;">
                <label> Complete el siguiente formulario </label>
            </div>     	
            <div style="margin-left:15%; margin-right:15%;">
        		<form action="/mapps/addAthletes" method="post" id="addAthlete_form">
                	<div id="nombre">
                        <div class="tag_form"> Nombre:  </div>
                        <div class="input"><input type="text" name="name" id="name"  /></div>
                    </div>
                    <div id="apellido">
                        <div class="tag_form"> Apellido: </div>
                        <div class="input"><input type="text" name="lastName" id="lastName" /></div>
                    </div>
                    <div id="birth">
                        <div class="tag_form_list">Nacimiento: </div>
                        <div id="date" class="input list_box">
                        </div>
                    </div>
                    <div id='gender_field'>
                      	<div class="tag_form_list"> Sexo: </div>
                        <div id="gender" class="input list_box"></div>
                    </div>
                    <div id="e_mail">
                        <div class="tag_form"> Email: </div>
                        <div class="input"><input type="text" name="email" id="email"  /></div>
                    </div>
                    <div id="peso">
                        <div class="tag_form"> Peso: </div>
                        <div class="input"><input type="text" name="weight" id="weight"  /></div>
                    </div>
                    <div id="altura">
                        <div class="tag_form"> Altura: </div>
                        <div class="input"><input type="text" name="height" id="height"  /></div>
                    </div>
                    <div id="ci">
                        <div class="tag_form"> C.I.: </div>
                        <div class="input"><input type="text" id="document" /></div>
                    </div>
                    <div id="institution_field">
                        <div class="tag_form"> Instituci&oacute;n: </div>
                        <div id="institution" class="input">
                        
                        </div>
                    </div>
                   	<div style=" margin-top:10px;">
                    	<center><input type="button" id="addAthlete_button" value="CONFIRMAR"/></center>
                 	</div>
                </form>  
                </div>
        	</div>        
        </div>
        <div id="sidebar_right">
        	
        </div>
    </div>
</div>
<div id="pie">
</div>
<%} %>
</body>
</html>
