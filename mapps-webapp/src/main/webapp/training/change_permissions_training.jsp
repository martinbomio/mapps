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
    <script type="text/javascript" src="../jqwidgets/jqxnumberinput.js"></script>
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
	//Get athletes

	
    $("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});

    $("#validate").click(function (){ 
        $('#change_permission').submit();
    });
	
    
    
    var url = "/mapps/getAllEditableTrainings";		
	$.ajax({
        url: url,
        type: "GET",
        success: function (response){
        	var trainings = response;
        	$('#trainings').on('select', function (event) {
                updatePanel(trainings[event.args.index]);
            });
        	$("#trainings").jqxDropDownList({ source: trainings, selectedIndex: 0, width: '220', height: '25',displayMember: "date", valueMember: "name", dropDownHeight: '80', theme: 'metro'});
     		
        	updatePanel(trainings[0]);
        
        },
    	   
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
    centerItems();
    $(window).resize(function () {
        centerItems();
    });
    
   
});
function updatePanel(trainings){
	var users = trainings.users;
	$("#users_div").html("");
	for (var i=0; i<users.length; i++){
		var container = $("<div></div>");
		var div = $('<div class="tag_form"> '+ users[i].userName +'</div>');
		var input = $('<div id="permission_list'+i+'" class="input list_box"></div>');
		var hiddenUsername = $('<input type="hidden" id="username-hidden'+i+'" name="username-hidden'+i+'" value="'+users[i].userName +'"></input>');
		
		$(container).append(div);
		$(container).append(input);
		$(container).append(hiddenUsername);
		$("#users_div").append(container.html());
		var permissions = trainings.permissions; 
			if (permissions[i] == "READ"){
				var index = 1;
			}else{
				var index = 0;
			}
		$('#permission_list'+i+'').jqxDropDownList({ source: ['Crear', 'Ver'], selectedIndex: index, width: '220', height: '25', dropDownHeight: '80', theme: 'metro'});
	}
	$('#numberOfUsers').val(users.length);
	$('#name-hidden').val(trainings.name);
	
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
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;">ENTRENAMIENTOS
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
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">CONFIGURACI&Oacute;N
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
    <div id="area_de_trabajo" style="height:550px;">
		<div id="sidebar_left">
        </div>	   
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./training.jsp">ENTRENAMIENTOS</a> >> Editar un entrenamiento
            </div>
	        
	         <div id='trainings_div' style="display:inline-block">
                       	<div class="tag_form" style="vertical-align:top; margin-top:15px;"> Entrenamientos: </div>
                        <div class="input" style="margin-top:10px;">
                        	<div id="trainings" style="display:inline-block;">
                            </div>
                        </div>
             </div>
             <form action="/mapps/changePermission" method="post" name="change_permission" id="change_permission">
	             <div id="users" style="width: 100%; margin-top:20px;display: inline-block;">
	             	<div class="tag_form" style="vertical-align:top; margin-top:15px;width: 20%;"> Permisos: </div>
	             	<div id="users_div" style="width:50%; margin-left:15%;"></div>
                 </div>
	             <input type="hidden" id="numberOfUsers" name="numberOfUsers"></input>
	             <input type="hidden" id="name-hidden" name="name-hidden"></input>
	             <div style="margin-left:25%; margin-top:20px;">
                    	<input type="button" id="validate" value="CONFIRMAR"/>
                    </div>
             </form>
        </div>
        <div id="sidebar_right">
        	
        </div>
    </div>
 
    
</div>
<div id="pie">
<%}%>
</div>
</body>
</html>