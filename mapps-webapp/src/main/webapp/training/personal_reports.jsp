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
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxchart.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxgauge.js"></script>
    <script src="../amcharts/amcharts.js" type="text/javascript"></script>
	<script src="../amcharts/serial.js" type="text/javascript"></script>
	<script src="../amcharts/xy.js" type="text/javascript"></script>
	<script src="../amcharts/pie.js" type="text/javascript"></script>

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
boolean show_pop_up = false;
boolean training_started=false;

String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";

String trainingName = String.valueOf(request.getParameter("t"));
String athleteID = String.valueOf(request.getParameter("a"));
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		set_tab_child_length();
		window.pulse_data = [];
		window.pulse_min = 220;
		window.pulse_max = 0;
		window.time_chart = '';
		window.pie_chart = '';
		window.training_zones_data = [];
	 	athlete_stats();
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
	
	function athlete_stats(){
		window.athleteData = '';
		$.ajax({
            url: "/mapps/getReport",
            type: "GET",
            data: {a:<%="'"+athleteID+"'"%> , t:<%="'"+trainingName+"'"%>},
            success: function (response){
            	create_values(response);
        	},
		});
	}
	
	function create_values(response){
	  	// prepare chart data as an array
        pulseData(response);
        getTrainingZones(response);
        updateCurrentTraining(response.trainingType);
        update_values(response);
		
		var pulse_time_chart = new AmCharts.AmSerialChart();
		pulse_time_chart.dataProvider = window.pulse_data;
		pulse_time_chart.validateData();
		pulse_time_chart.categoryField = "time";
		/*
		var speed_category_axis = speed_chart.categoryAxis;
		speed_category_axis.parseDates = true;
		speed_category_axis.minPeriod = 'fff';
		speed_chart.dataDateFormat = "NN-SS";
		*/
			
		var pulse_time_graph = new AmCharts.AmGraph();
		pulse_time_graph.valueField = "pulse";
		pulse_time_graph.type = "line";
		pulse_time_graph.title = "Pulso (bpm)";
		pulse_time_graph.balloonText = "[[value]] bpm";
		pulse_time_graph.fillAlphas = 0.5;
		pulse_time_chart.addGraph(pulse_time_graph);
			
		var chartScrollbar = new AmCharts.ChartScrollbar();
		pulse_time_chart.addChartScrollbar(chartScrollbar);
			
		var chartCursor = new AmCharts.ChartCursor();
		chartCursor.cursorPosition = "mouse";
		pulse_time_chart.addChartCursor(chartCursor);
			
		pulse_time_chart.write('graphicPulse');
			
		pulseGauge(Math.round(response.meanBPM));
		pieChart();
		
		window.time_chart = pulse_time_chart;
	}
	function pulseData(data) {
		for(var i = 0 ; i<data.pulse.length; i++){
			if((data.pulse[i])==null){
				window.pulse_data.push({
					time: parseTimeStamp(data.time[i]), pulse: 0
				});	
			}else{
				if(data.pulse[i] > window.pulse_max){
					window.pulse_max = data.pulse[i];
				}else if(data.pulse[i] < window.pulse_min){
					window.pulse_min = data.pulse[i];
				}
				window.pulse_data.push({
					time: parseTimeStamp(data.time[i]), pulse: data.pulse[i]
				});
			}				
		}
	}
	
	function parseTimeStamp(milliseconds){
		var seconds = Math.floor( milliseconds / 1000 );
		var time = '';
		if (seconds < 10){
			time = '00:0'+seconds;
		}else if(seconds < 60){
			time = '00:'+seconds;
		}else{
			var minutes = Math.floor( seconds / 60 );
			var stringMinutes = minutes;
			var newSeconds = seconds - minutes * 60;
			var stringNewSeconds = newSeconds;
			if(minutes < 10){
				stringMinutes = '0'+minutes;
			}
			if(newSeconds < 10){
				stringNewSeconds = '0'+newSeconds;
			}
			if(minutes < 60){
				time = stringMinutes+':'+stringNewSeconds;
			}else{
				var hours = Math.floor( minutes / 60 );
				var stringHours = hours;
				var newMinutes = minutes - hours * 60;
				var stringNewMinutes = newMinutes;
				if(hours < 10){
					stringHours = '0:'+hours;
				}
				if(newMinutes < 10){
					stringNewMinutes = '0'+newMinutes;
				}
				time = stringHours+':'+stringMinutes+StringHours;
			}
		}
		return time;
	}
	
	function update_values(response){
		document.getElementById('pulse_data').innerHTML = Math.round(response.meanBPM)+' '+'bpm';
		document.getElementById('calories_data').innerHTML = get_double_as_String(response.kCal,3)+' '+'kCal';
		document.getElementById('pulse_data_min').innerHTML = window.pulse_min;
		document.getElementById('pulse_data_max').innerHTML = window.pulse_max;
	}
	
	function getTrainingZones(response){
		window.training_zones_data = [];
		if(response.trainingTypePercentage.VERYSOFT != null){
			var verySoft = response.trainingTypePercentage.VERYSOFT;
			window.training_zones_data.push({ type: "Muy suave", value: verySoft });
		}
		if(response.trainingTypePercentage.SOFT != null){
			var soft = response.trainingTypePercentage.SOFT;
			window.training_zones_data.push({ type: "Suave", value: soft });
		}
		if(response.trainingTypePercentage.MODERATED != null){
			var moderated = response.trainingTypePercentage.MODERATED;
			window.training_zones_data.push({ type: "Moderado", value: moderated });
		}
		if(response.trainingTypePercentage.INTENSE != null){
			var intense = response.trainingTypePercentage.INTENSE;
			window.training_zones_data.push({ type: "Intenso", value: intense });
		}
		if(response.trainingTypePercentage.VERYINTENSE != null){
			var veryIntense = response.trainingTypePercentage.VERYINTENSE;
			window.training_zones_data.push({ type: "Muy intenso", value: veryIntense });
		}
	}
	
	function updateCurrentTraining(trainingType){
		document.getElementById('very_soft').style.display = 'none';
		document.getElementById('soft').style.display = 'none';
		document.getElementById('moderate').style.display = 'none';
		document.getElementById('intense').style.display = 'none';
		document.getElementById('very_intense').style.display = 'none';
		switch(trainingType){
			case 'VERYSOFT':
				document.getElementById('very_soft').style.display = 'block';
				break;
			case 'SOFT':
				document.getElementById('soft').style.display = 'block';
				break;
			case 'MODERATE':
				document.getElementById('moderate').style.display = 'block';
				break;
			case 'INTENSE':
				document.getElementById('intense').style.display = 'block';
				break;
			case 'VERYINTENSE':
				document.getElementById('very_intense').style.display = 'block';
				break;
				default:
					break;
		}
	}
	
	
	function pulseGauge(mean){
		$('#gaugeContainer').jqxGauge({
            ranges: [{ startValue: 60, endValue: 100, style: { fill: '#4bb648', stroke: '#4bb648' }, endWidth: 5, startWidth: 1 },
                     { startValue: 100, endValue: 150, style: { fill: '#fbd109', stroke: '#fbd109' }, endWidth: 10, startWidth: 5 },
                     { startValue: 150, endValue: 180, style: { fill: '#ff8000', stroke: '#ff8000' }, endWidth: 13, startWidth: 10 },
                     { startValue: 180, endValue: 220, style: { fill: '#e02629', stroke: '#e02629' }, endWidth: 16, startWidth: 13 }],
            ticksMinor: { interval: 5, size: '5%' },
            ticksMajor: { interval: 10, size: '9%' },
            style: { stroke: '#ffffff', 'stroke-width': '1px', fill: '#ffffff' },
            value: 0,
            border: { visible: false },
            colorScheme: 'scheme05',
            animationDuration: 1200,
            width: '90%',
            height: 175,
            min: 60,
            max: 220
        });
		$('#gaugeContainer').jqxGauge('value', mean);	
	}
	
	
	function pieChart(){
		var chart = AmCharts.makeChart("graphic_pie", {
		    "type": "pie",
			"theme": "none",
		    "dataProvider": window.training_zones_data,
		    "valueField": "value",
		    "titleField": "type",
		    "startEffect": "elastic",
		    "startDuration": 2,
		    "labelRadius": 15,
		    "innerRadius": "50%",
		    "depth3D": 10,
		    "balloonText": "<span style='font-size:14px'><b>[[type]]</b> [[percents]]%</span>",
		    "angle": 15
		});
		chart.labelsEnabled = false;
		chart.autoMargins = false;
		chart.marginTop = 25;
		chart.marginBottom = 25;
		chart.marginLeft = 25;
		chart.marginRight = 25;
		chart.pullOutRadius = 0;
		chart.labelsEnabled = true;
		chart.validateData();
		window.pie_chart = chart;
	}
	
	function get_double_as_String(doub, decimals){
		var val = new String(doub);
    	var split = val.split('.');
    	return split[0] + '.' + split[1].substr(0,decimals);
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
            	<a href="./athletes.jsp">JUGADORES</a> >> Jugador en Entrenamiento
        	</div>
            <div id="main_div_up">
                <div id="athlete_data_div">
                    	<img src="../images/athletes/default.png" height="110px" style="float: left;margin-top: 25px;margin-left: 10px" />
                    	<div id='athlete_data'>
                    		<div class="my_account_field" style="width:35%"><div class="my_account_tag" >Nombre:</div><div id="name" class="my_account_data"> Martin</div></div>
                    		<div class="my_account_field" style="width:35%"><div class="my_account_tag" >Apellido:</div><div id="lastName" class="my_account_data"> Bomio</div></div>
                    		<div class="my_account_field" style="width:35%"><div class="my_account_tag" >Edad:</div><div id="age" class="my_account_data"> 24</div></div>
                    		<div class="my_account_field" style="width:35%"><div class="my_account_tag" >Altura:</div><div id="height" class="my_account_data"> 1.75 m.</div></div>
                    		<div class="my_account_field" style="width:40%"><div class="my_account_tag" >Peso:</div><div id="weight" class="my_account_data"> 95 kg.</div></div>
                    	</div>
                </div>
                <div id="athlete_data_div" >
	                <div id="gaugeContainer" style="margin-left: 25px"> 
	                </div>
                </div>
                
                <div id="athlete_data_div"  style="margin-right:0px;">
               		<div id="pulse_min" class="data_info_index_min" style="margin-top:30px;">
	                  	<div  class="data_index_min">
	            	        min
	                    </div>
	                    <div id="pulse_data_min" style="text-align:center;" >
	                        	
	                    </div>
	                </div>
	                <div id="pulse" class="data_info_index" style="margin-top:15px;border-left: solid 2px #e5e5e5;border-right: solid 2px #e5e5e5;">
	                  	<div style="font-size:25px;" class="data_index">
	                        PULSO <div class="data_index_min">prom</div>
	                    </div>
	                    <div id="pulse_data" style="text-align:center;font-sizee18px;margin-top:12px;">
	                          	
	                    </div>
	                </div>
	                <div id="pulse_max" class="data_info_index_min" style="margin-top:30px;">
	                  	<div class="data_index_min">
	                        max
	                    </div>
	                    <div id="pulse_data_max" style="text-align:center;">
	                          	
	                    </div>
	                </div>
               		<div id="calories" class="data_info_index" style="margin-top:30px; width: 100%">
	                  	<div class="data_index">
	                	    CALORIAS
	                    </div>
	                    <div id="calories_data" style="text-align:center;">
	                          	
	                    </div>
	                </div>
	            </div>          
            </div>
            <div id="main_div_down">
            	<div style="float:left; display:inline-block; width:90%;margin:3%;">
	            	<div>Pulsaciones</div>
	                <div id="graphicPulse" style="height:280px; width:100%; display:inline-block;margin-left: 10px;">
	                            
	                </div>
	            </div>
	            
	        </div>
	        <div id="training_zones">
	        	<div style="float:left; display:inline-block; width:94%;margin:3%;">
	            <div>Zonas de entrenamiento<br></br></div>
	            <div style="float:left; display:inline-block; width:45%; margin-left:5%;">
	            	<div>Entrenamiento actual:</div>
		            <div id="very_soft" style="display:none;">
		            	<div style="text-align: center; margin-top: 10px;">MUY SUAVE</div>	
		            	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		            	En este rango no hay adaptaciones a menos que el nivel físico de la persona sea muy bajo. El metabolismo energético más utilizado es el de los ácidos grasos y la intensidad de trabajo es baja.
	Puede servir para gente con poco nivel físico o para intercalarlo como trabajo de recuperación de otras sesiones más importantes. Tras una sesión dura, introducir trabajo en este rango hace que la recuperación sea más rápida que si se para completamente.
	<b>Recomendada para acondicionamiento básico o rehabilitación cardíaca.</b>
		            	</div>
		            </div>
		            <div id="soft" style="display:none;">
		            	<div style="text-align: center; margin-top: 10px;">SUAVE</div>	
		            	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		            	En este rango ya se empiezan a producir adaptaciones que serán más importantes en función de la calidad y de la cantidad de trabajo que se realice. El metabolismo energético es el de los ácidos grasos y el de los hidratos de carbono, si el nivel de intensidad es elevado la utilización de los hidratos de carbono es mayor.
Se puede utilizar en cualquier grupo que tenga un mínimo de condición física.
<b>Recomendada para mantenimiento físico y salud.</b>
		            	</div>
		            </div>
		            <div id="moderate" style="display:none;">
		            	<div style="text-align: center; margin-top: 10px;">MODERADO</div>	
		            	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		            	Tiene las mismas características que el anterior pero con más intensidad, por tanto la degradación de los hidratos de carbono será mayor en esta zona que en la anterior. Es un trabajo de más calidad y en donde se pueden obtener unas adaptaciones muy interesantes para la mejora de la condición física. De hecho esta zona es ideal para el entrenamiento de la capacidad aeróbica. Diríamos que es la zona deseada de ritmo cardíaco.
<b>Recomendada sólo para deportistas comprometidos y con buena condición física. </b>
		            	</div>
		            </div>
		            <div id="intense" style="display:none;">
		            	<div style="text-align: center; margin-top: 10px;">INTENSO</div>	
		            	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		            	A este nivel se puede trabajar en o muy cerca del umbral anaeróbico, un poco por encima y un poco por debajo. Cuando se entrena dentro de este rango empieza a ser necesario metabolizar el ácido láctico, ya que se genera este compuesto por la alta intensidad.
Se puede entrenar más duro y en muchos momentos con ausencia de oxígeno. Sólo se debe utilizar con gente con un buen nivel de condición física.
<b>Recomendada sólo para deportistas de alto nivel.</b>  
		            	</div>
		            </div>
		            <div id="very_intense" style="display:none;">
		            	<div style="text-align: center; margin-top: 10px;">MUY INTENSO</div>	
		            	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		            	En este rango sólo se puede entrenar si se esta perfectamente en forma, es el caso de los deportistas de élite que están controlados constantemente por profesionales del deporte y de la medicina.
Se trabaja siempre por encima del umbral anaeróbico, o sea con deuda de oxígeno. Esto significa que los músculos están utilizando más oxígeno del que puede proporcionar el cuerpo.
<b>Recomendada sólo para deportistas de alto nivel.</b> 
		            	</div>
		            </div>
	            </div>
	            <div id="graphic_pie" style="float:left; display:inline-block; width:50%; margin-left:0%; height:250px;">
	            
	            </div>
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
