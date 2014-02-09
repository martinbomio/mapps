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
    <script type="text/javascript" src="./jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxscrollbar.js"></script>
	<link rel="stylesheet" href="./jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="./jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/main_style.css"> 
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	response.sendRedirect("index_login.jsp");	
}else{
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
	pop_up_message = "El entrenamiento se ha finalizado con éxito";
	show_pop_up = true;
}
String error = String.valueOf(request.getParameter("error"));
if (error.equals(10)){
	pop_up_message = "Error de autenticación o no se tiene los permisos necesarios para realizar esta operación";
	show_pop_up = true;
}
else if(error.equals(11)){
	pop_up_message = "El entrenamiento que desae parar no es válido";
	show_pop_up = true;
}
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		window.created = false;
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
	            		var display_name = "Entrenamiento iniciado el: " + split[0] + " a las " + split[1] + "horas";
	            		$('#training').text( display_name);
	            		window.training = training;
	            		create_list();
	            	}
	            },
			});
			setInterval(function(){
				create_list();
			}, 3000);
			$('#pop_up').jqxWindow({ maxHeight: 150, maxWidth: 280, minHeight: 30, minWidth: 250, height: 145, width: 270,
	            resizable: false, draggable: false, 
	            okButton: $('#ok'), 
	            initContent: function () {
	                $('#ok').jqxButton({  width: '65px' });
	                $('#ok').focus();
	            }
	        });	
	});
	function create_list(){
		training = window.training;
		$.ajax({
            url: "/mapps/getTrainingPulseData",
            type: "POST",
            data: {t:training.name},
            success: function (response){
            	var reports = response;
            	if(reports.length != 0){
                	create_label(reports);
            	}else{
            		$('#list_athletes').text("No hay datos de los atletas aun");
            	}
            },
		});
	}
	
	function create_label(reports){
		var list = $("#list_athletes");
		list.html("");
		for (var index = 0; index< reports.length;index++){
			var data = reports[index];
            var athlete = data.athleteWrapper;
        	var bpm = data.lastPulse;
        	var kCal = get_double_as_String(data.kCal,3);
        	var training_zone = get_zone(data.trainingType);
        	var first_div = $('<div id="'+athlete.idDocument+'" class="athlete_index"></div>');
        	var div_up = $('<div id="img'+athlete.idDocument+'" style="float:left; height:100px; width:20%; display:inline-block; padding-top:10px; padding-bottom:10px;"><img src="'+athlete.imageURI+'" height="80px" /></div>'); 
        	var div_down = $('<div id="data '+athlete.idDocument+'"  style="float:left; height:100px; width:80%; display:inline-block; padding-top:10px; padding-bottom:10px;"><div style="width: 25%;height: 100%;float: left;display: inline-block" ><a href="./athletes/player_view_training.jsp?a='+athlete.idDocument+'&t='+data.trainingName+'"><div id="name'+athlete.idDocument+'" class="data_info_index" style="font-size:22px;">'+athlete.name+' '+athlete.lastName+'</div></a></div><div id="pulse '+athlete.idDocument+'" class="data_info_index" style="margin-top:15px;"><div style="height:40px; text-align:center;">Pulso:</div><div id="pulse_data'+athlete.idDocument+'" class="data_index">'+bpm+' BPM</div></div><div id="zone'+athlete.idDocument+'" class="data_info_index" style="margin-top:15px;"><div style="height:40px; text-align:center;">Zona de Entrenamiento:</div><div id="training_zone'+athlete.idDocument+'" class="data_index">'+training_zone+'</div></div><div id="calories'+athlete.idDocument+'" class="data_info_index" style="margin-top:15px;"><div style="height:40px; text-align:center;">Calorias Quemadas:</div><div id="calories_data '+athlete.idDocument+'" class="data_index">'+kCal+' KCal</div></div></div>');
        	first_div.append(div_up);
        	first_div.append(div_down);
        	list.append(first_div);
		}
		 /* $('#list_athletes').jqxListBox({ selectedIndex: 0, source: reports, displayMember: "athleteWrapper.name", valueMember: "athleteWrapper.idDocument", itemHeight: 35, height: '450px', width: '100%', theme: 'metro',
            renderer: function (index, label, value) {
                var data = reports[index];
                var athlete = data.athleteWrapper;
            	var bpm = data.lastPulse;
            	var kCal = get_double_as_String(data.kCal,3);
            	var first_div = $('<div id="'+athlete.idDocument+'" class="athlete_index"></div>');
            	var div_up = $('<div id="img'+athlete.idDocument+'" style="float:left; height:100px; width:20%; display:inline-block; padding-top:10px; padding-bottom:10px;"><img src="'+athlete.imageURI+'" height="80px" /></div>'); 
            	var div_down = $('<div id="data '+athlete.idDocument+'"  style="float:left; height:100px; width:80%; display:inline-block; padding-top:10px; padding-bottom:10px;"><a href=".athletes/player_view_training.jsp?a='+athlete.idDocument+'&t='+data.trainingName+'"><div id="name'+athlete.idDocument+'" class="data_info_index">'+athlete.name+' '+athlete.lastName+'</div></a><div id="pulse '+athlete.idDocument+'" class="data_info_index" style="margin-top:15px;"><div style="height:40px; text-align:center;">PULSO:</div><div id="pulse_data'+athlete.idDocument+'" class="data_index">'+bpm+' BPM</div></div><div id="calories'+athlete.idDocument+'" class="data_info_index" style="margin-top:15px;"><div style="height:40px; text-align:center;">CALORIAS QUEMADAS:</div><div id="calories_data '+athlete.idDocument+'" class="data_index">'+kCal+' KCal</div></div></div>');
            	first_div.append(div_up);
            	first_div.append(div_down);
                return first_div.html();
            }
        });  */
	}
	
	function get_double_as_String(doub, decimals){
		var val = new String(doub);
    	var split = val.split('.');
    	return split[0] + '.' + split[1].substr(0,decimals);
	}
	
	function get_zone(type){
		if (type == "VERYSOFT"){
			return "Muy Suave";
		}else if (type == "SOFT"){
			return "Suave";
		}else if (type == "MODERATED"){
			return "Moderado";
		}else if (type == "INTENSE"){
			return "Intenso";
		}else{
			return "Muy Intenso";
		}
	}
	
	function create_stop_training(training_name){
		var button = $('<input type="button" id="stop_training" name="stop_training" value="TERMINAR ENTRENAMIENTO" style="margin-left:30%;" />');
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
        <div id="logout" class="up_tab"><a href="./configuration/my_account.jsp">MI CUENTA</a></div>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
    </div>
</div>
<div id="contenedor">

    <div id="tabs">
	  	<div id="tab_1" class="tab active" onclick="location.href='index.jsp'" style="margin-left:13%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_5" class="tab" onclick="location.href='configuration/configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo" style="height:620px;">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="training" style="width:100%; height:25px; padding-top:15px;"> 
            
            </div>
            <div id="list_athletes" style="width:100%; height:450px; overflow:scroll; margin-top:30px; margin-bottom:30px;">
<!--               	<div id="athlete_1" class="athlete_index">
                	<div id="img" style="float:left; height:100px; width:20%; display:inline-block; padding-top:10px; padding-bottom:10px;">
                    	<img src="images/athletes/default.png" height="80px" />
                    </div>
                    <div id="data"  style="float:left; height:100px; width:80%; display:inline-block; padding-top:10px; padding-bottom:10px;">
                    	<div id="name" class="data_info_index">
                        	Martin
                           	Bomio
                        </div>
                        <div id="pulse" class="data_info_index" style="margin-top:15px;">
                        	<div style="height:40px; text-align:center;">
                            PULSO
                            </div>
                            <div id="pulse_data" class="data_index">
                            	79 bpm
                            </div>
                        </div>
                        <div id="calories" class="data_info_index" style="margin-top:15px;">
                        	<div style="height:40px; text-align:center;">
                            CALORIAS
                            </div>
                            <div id="calories_data" class="data_index">
                            	475
                            </div>
                        </div>
                    </div>
                </div>
-->
               
            </div>
        	<div id="stop_training_div">
            
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
