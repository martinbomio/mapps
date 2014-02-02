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
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxchart.js"></script>
    <link href="../scripts/nv.d3.min.css" rel="stylesheet" type="text/css">
    <script src="../scripts/d3.v3.js"></script>
    <script src="../scripts/nv.d3.min.js"></script>
    <script src="../scripts/mychart.js"></script>

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
boolean show_pop_up = false;
boolean training_started=false;
String pop_up_message = "";
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null")){
	info = "";
}else if (info.equals("10")){
	pop_up_message = "El entrenamiento se a finalizado con éxito";
}
String error = String.valueOf(request.getParameter("error"));
if (error.equals(10)){
	pop_up_message = "Error de auteticación o no se tiene los permisos necesarios para realizar esta operación";
}
else if(error.equals(11)){
	pop_up_message = "El entrenamiento que desae parar no es válido";
}
%>
<body>

<style media="screen" type="text/css">
.tab_player_login{
	height:50px;
	margin-bottom:10px;
	display:inline-block;
	width:15%;
}</style>
<script type="text/javascript">
	$(document).ready(function () {
		$("#jqxMenu").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
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
			var url = "/mapps/getFinishedTrainings";		
			$.ajax({
	            url: url,
	            type: "GET",
	            success: function (response){
					create_lists(response);	            	
	            },
	        	   
			});
			
	});
	
	function create_lists(response){
		var trainings = response;
		$('#list_trainings').on('select', function (event) {
			var indexTrain = $("#jqxListBox").jqxListBox('getSelectedIndex'); 
			call_reports_ajax(trainings[indexTrain]);
        });
		
		$('#list_trainings').jqxListBox({ selectedIndex: 0,  source: trainings, displayMember: "date", valueMember: "name", itemHeight: 35, height: '100%', width: '300', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = trainings[index];
                var split = datarecord.date.split(" ");
                var display = "Entrenamiento iniciado en: " + split[0] + " a las: " + split[1];
                var table = '<table style="min-width: 130px;"><td>' + display + '</td></table>';
                return table;
            }
        });
		call_reports_ajax(trainings[0]);
	}
	
	function call_reports_ajax(training){
		$.ajax({
            url: "/mapps/getReportsOfTraining",
            type: "POST",
            data: {t: training.name},
            success: function (response){
            	create_athlete_list(response);	            	
            },
		});
	}
	
	function create_athlete_list(reports){
		$('#list_athletes').jqxListBox({ selectedIndex: 0, source: reports, displayMember: "athlete.name", valueMember: "athlete.idDocument", itemHeight: 35, height: '100%', width: '100%', theme: 'metro',
            renderer: function (index, label, value) {
                var data = reports[index];
                var athlete = data.athlete;
            	var distance = get_double_as_String(data.traveledDistance,1);
            	var speed = get_double_as_String(data.averageSpeed,1);
            	var max_bpm = Math.max.apply(Math, data.pulse);
            	var min_bpm = Math.min.apply(Math, data.pulse);
            	var max_speed = get_double_as_String(data.maxVelocity,1);
            	var max_acceleration = get_double_as_String(data.acceleration,3);
            	var first_div = $('<div id="'+athlete.idDocument+'" class="display_player"></div');
            	var div_up = $('<a href="athletes/player_view_training.jsp?a='+athlete.idDocument+'&t='+data.trainingName+'"><div id="up" style="width:100%; height:60%;"><div id="img" style="display:inline-block; width:15%; height:100%;"><img src="'+athlete.imageURI+'" style="height:55px; margin-top:5px; vertical-align:middle"/></div><div id="name" style="display:inline-block; font-size:14px; width:45%; height:100%;">'+athlete.name+' '+athlete.lastName+'</div></a> Duración del entrenamiento: <div id="time" style="display:inline-block; font-size:14px; width:40%; height:100%;">'+ data.elapsedTime/1000.0+' sg</div></div>');
            	var div_down = $('<div id="down" style="width:100%; height:40%;"><div id="info_distance" class="tab_player_login"><div class="tag_info_player_login"> Distancia recorrida:</div><div id="distance'+athlete.idDocument+'" class="tag_data_player_login"> '+ distance +' mts </div></div><div id="info_acceleration" class="tab_player_login" style="border-left:solid 1px;"><div class="tag_info_player_login"> Acceleración max:</div><div id="max_acceleration'+athlete.idDocument+'" class="tag_data_player_login"> '+ max_acceleration +' m/(s)2 </div></div><div id="info_speed" class="tab_player_login" style="border-left:solid 1px;"><div class="tag_info_player_login"> Velocidad Promedio</div><div id="speed'+athlete.idDocument+'" class="tag_data_player_login"> '+speed+' km/h </div></div><div id="info_speed" class="tab_player_login" style="border-left:solid 1px;"><div class="tag_info_player_login"> Velocidad Max</div><div id="speed_max'+athlete.idDocument+'" class="tag_data_player_login"> '+max_speed+' km/h </div></div><div id="info_heart" class="tab_player_login" style="border-left:solid 1px;"><div class="tag_info_player_login"> Pulso Max:</div><div id="pulse'+athlete.idDocument+'" class="tag_data_player_login"> '+max_bpm+' bpm </div> </div><div id="info_heart" class="tab_player_login" style="border-left:solid 1px;"><div class="tag_info_player_login"> Pulso Min:</div><div id="pulse'+athlete.idDocument+'" class="tag_data_player_login"> '+min_bpm+' bpm </div></div></div></div>');
                first_div.append(div_up);
            	first_div.append(div_down);
                return first_div.html();
            }
        });
	}
	
	function get_double_as_String(doub, decimals){
		var val = new String(doub);
    	var split = val.split('.');
    	return split[0] + '.' + split[1].substr(0,decimals);
	}
	
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
        <div id="logout" class="up_tab">MI CUENTA</div>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
    </div>
</div>
<div id="contenedor">

    <div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:13%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab active" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
		
		<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="./training_reports.jsp"> Ver entrenamientos anteriores </a></li>
             	   <li style="height:35px;"><a href="./create_training.jsp"> Programar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./edit_training.jsp"> Editar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./change_permissions_training.jsp"> Editar Permisos </a></li>
             	   <li style="height:35px;"><a href="#">  </a></li>
        		</ul>
  			</div>
        
        </div>
        <div id="main_div" style="width:75%;">
        	<div id="main_div_left" style="float:left; width:30%; display:inline-block;">
        		<div id="list_trainings"></div>
        	</div>
        	<div id="main_div_right" style="float:left; width:70%; display:inline-block;">
        		<div id="list_athletes"></div>
        	</div>
        </div>
        <div id="sidebar_right" style="width:5%;">
        
        </div>
    </div>
 
</div>
<div id="pie">

</div>
</body>
</html>