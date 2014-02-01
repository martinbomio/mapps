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
    <script type='text/javascript' src="./scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxchart.js"></script>
    <link href="./scripts/nv.d3.min.css" rel="stylesheet" type="text/css">
    <script src="./scripts/d3.v3.js"></script>
    <script src="./scripts/nv.d3.min.js"></script>
    <script src="./scripts/mychart.js"></script>

	<link rel="stylesheet" href="./jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="./jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/main_style.css"> 
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	response.sendRedirect("index_login.jsp");	
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

<script type="text/javascript">
	$(document).ready(function () {
		window.created = false;
		call_ajax();
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
			setInterval(function(){
				call_ajax();
			}, 5000);
	});
	
	function call_ajax(){
		var url = "/mapps/getStartedTraining";
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
            	var training = response;
            	if(training=="not started"){
					
            	}else{
            		var training=JSON.parse(training);
            		create_stop_training(training.name);
            		var split = training.date.split(" ");
            		var display_name = "Entreneamiento iniciado el: " + split[0] + " a las " + split[1] + "horas";
            		$('#training').text( display_name);
            		draw_chart(training);
            	}
            },
		});
	}
	
	function create_stop_training(training_name){
		var button = $('<input type="button" id="stop_training" name="stop_training" value="TERMINAR ENTRENAMIENTO" style="margin-left:200px;" />');
		$('#stop_training_div').html(button);
		$("#stop_training").jqxButton({ width: '300', height: '50', theme: 'metro'});
		$("#stop_training").on('click', function () { window.location.assign('/mapps/stopTraining?name='+training_name+'')}); 
	}

	
</script>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="index.jsp"></href><img src="./images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
    	<div id="pop_up">
            <div>
                <img width="14" height="14" src="./images/ok.png" alt="" />
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
	  	<div id="tab_1" class="tab active" onclick="location.href='index.jsp'" style="margin-left:13%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='configuration/configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="training" style="width:100%; height:40px;"> 
            
            </div>
            <div>
            	<div id="graphic" style="height:400px; width:60%; display:inline-block;">
                	<svg />
                </div>
                <div id="list_players">
                </div>
            </div>
        	<div id="stop_training_div">
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
