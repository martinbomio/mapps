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
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" href="../jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	response.sendRedirect("../index_login.jsp");	
}else {
	
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
	
	if(info.equals("1")){
		
		pop_up_message = "El entrenamiento fue programado con éxito.";
		show_pop_up = true;	
	}
	if(info.equals("2")){
		
		pop_up_message = "El entrenamiento fue editado con éxito.";
		show_pop_up = true;	
	}
	if(info.equals("3")){
		
		pop_up_message = "Los permisos han sido modificados con éxito.";
		show_pop_up = true;	
	}

%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		set_tab_child_length();
		<%
		if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
		%>
		<%if(trainingStarted.equals("trainingStopped")){ %>
		$("#start_training").jqxButton({ width: '300', height: '50', theme: 'metro'});
		<%}%>
		<%}%>
	
        <%
		if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
		%>
		<%if(trainingStarted.equals("trainingStopped")){ %>
		$("#start_training").on('click', function () {
			if($("#start_training").val() == "PROGRAMAR ENTRENAMIENTO"){
				window.location.replace("create_training.jsp");
			}else{
				var selected = $('#trainings').jqxListBox('getSelectedItem');
				var uid = selected.value;
				window.location.replace("start_training.jsp?uid="+uid);
			}
		});
		<%}%>
		<%}%>
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
		$.ajax({
            url: "/mapps/getTrainingsToStart",
            type: "GET",
            success: function (response){
            	<%if(trainingStarted.equals("trainingStopped")){ %>
            	load_list(JSON.parse(response));
            	<%}%>
            }
		});
		
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
	
	function load_list(records){
		if (records.length == 0){
			$("#title").text('No hay entrenamiento programados. Pulse "Programar Entrenamiento" para programar uno');
			$("#start_training").jqxButton('val', "PROGRAMAR ENTRENAMIENTO");
		}else{
			$('#trainings').jqxListBox({ source: records, displayMember: "date", valueMember: "name", itemHeight: 55, height: '250px', width: '100%', theme: 'metro',
	        	renderer: function (index, label, value) {
	                var datarecord = records[index];
	                var split = datarecord.date.split(" ");
	                var display = "Entrenamiento programado para el: " + split[0];
	                var table = '<table style="min-width: 130px; width:100%;font-size: 14px;"><tr><td style="text-align: center;">' + display + '</td></tr><tr><td style="text-align: center;"> a las:'+ split[1]; + '</td></tr></table>';
	                return table;
	            }	
	        });
		}
	}
</script>


<div id="header">
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central">
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
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;">ENTRENAMIENTOS
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
            	<a href="./training.jsp">ENTRENAMIENTOS</a> >> Comenzar
            </div>
        	<div id="add_div">
        	<div id="title_div" style="margin:15px;">
        	<%
					if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
					%>
				<%if(trainingStarted.equals("trainingStarted")){ %>
				<center><label id="title"> Ya existe un entrenamiento en curso. Si desea programar o iniciar otro, termine el entrenamiento actual. </label></center>
				<%}else{ %>	
           		<label id="title"> Seleccione el entrenamiento que desee comenzar: </label>
           		<%} %>
           		<%}else{ %>
           		<center><label> Usted no tiene permisos para comenzar un entrenamiento </label></center>
           		<%} %>
           		
            </div>
            <div style="margin-left:20%;margin-right:20%;width: 60%">
	        	<div id="trainings" >
	            
	            </div>
            </div>
            <%
					if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
					%>
			<%if(trainingStarted.equals("trainingStopped")){ %>		
			<div id="start_training_div">
            	<center><input type="button" id="start_training" name="start_training" value="COMENZAR ENTRENAMIENTO" /></center>
            </div>
            <%}%>
            <%}%>
            <%}%> 
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
