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
	response.sendRedirect("index_login.jsp");	
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
	});
	
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
		document.getElementById('name').innerHTML = response.athlete.name+' '+response.athlete.lastName;
	  	// prepare chart data as an array
        pulseData(response);
        getTrainingZones(response);
		
        document.getElementById('pulse_data').innerHTML = parseFloat(response.meanBPM).toFixed(1) +' '+'bpm';
		document.getElementById('calories_data').innerHTML = get_double_as_String(response.kCal,3)+' '+'kCal';
		document.getElementById('pulse_data_min').innerHTML = window.pulse_min;
		document.getElementById('pulse_data_max').innerHTML = window.pulse_max;
        
		var pulse_time_chart = new AmCharts.AmSerialChart();
		pulse_time_chart.dataProvider = window.pulse_data;
		pulse_time_chart.validateData();
		pulse_time_chart.categoryField = "time";
			
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
			
		pulseGauge(parseFloat(response.meanBPM).toFixed(1));
		pieChart();
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
            width: '33%',
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
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
    
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab"><a href="../configuration/my_account.jsp">MI CUENTA</a></div>
        <%if(trainingStarted.equals("trainingStarted")){%>
		<div id="logout" class="up_tab"><a href="../index.jsp?logout=1" >CERRAR SESI&Oacute;N</a></div>
		<%}else{ %>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
		<%} %>
    </div>
</div>
<div id="contenedor">

    <div id="tabs">
	  	<div id="tab_1" class="tab active" onclick="location.href='../index.jsp'" style="margin-left:13%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo" style="height:1520px;">
		<div id="sidebar_left" style="width:10%;">
        
        </div>
        <div id="main_div" style="width:80%;">
        	<div id="training" style="width:100%; height:40px;"> 
            
            </div>
            <div id="main_div_up" style="float:left; height:265px; margin-top:30px; width:100%;">
                <div id="img" style="float:left; height:100px; width:15%; display:inline-block; padding-top:10px; padding-bottom:10px;">
                    	<img src="../images/athletes/default.png" height="80px" />
                </div>
                <div id="data"  style="float:left; height:200px; width:85%; display:inline-block; padding-top:10px; padding-bottom:10px;">
                 	<div id="name" class="data_info_index">
                       	
                    </div>
                    <div id="gaugeContainer" style="height:160px; width:50%; float:left; margin-left:5%; margin-right:5%;">                
                	
               		</div>
               		<div id="pulse_min" class="data_info_index_min" style="margin-top:30px;">
	                  	<div style="height:40px; text-align:center;">
	            	        min
	                    </div>
	                    <div id="pulse_data_min" class="data_index_min">
	                        	
	                    </div>
	                </div>
	                <div id="pulse" class="data_info_index" style="margin-top:30px;">
	                  	<div style="height:40px; text-align:center; font-size:18px;">
	                        PULSO MEDIO
	                    </div>
	                    <div id="pulse_data" class="data_index" style="font-size:18px;">
	                          	
	                    </div>
	                </div>
	                <div id="pulse_max" class="data_info_index_min" style="margin-top:30px;">
	                  	<div style="height:40px; text-align:center;">
	                        max
	                    </div>
	                    <div id="pulse_data_max" class="data_index_min">
	                          	
	                    </div>
	                </div>
               		<div id="calories" class="data_info_index" style="margin-top:30px; margin-left:7%">
	                  	<div style="height:40px; text-align:center;">
	                	    CALORIAS
	                    </div>
	                    <div id="calories_data" class="data_index">
	                          	
	                    </div>
	                </div>
	            </div>          
            </div>
            <div id="main_div_down" style="float:left; height:350px; margin-top:30px; width:100%;">
            	<div style="float:left; display:inline-block; width:65%">
	            	<div>Pulsaciones</div>
	                <div id="graphicPulse" style="height:280px; width:100%; display:inline-block; margin-left:20%;">
	                            
	                </div>
	            </div>	            
	        </div>
	        <div style="float:left; display:inline-block; width:90%; height:280px;">
	            <div style="margin-bottom:10px;">Zonas de entrenamiento</div>
	            <div id="graphic_pie" style="float:right; display:inline-block; height:280px; width:100%;">
	            
	            </div>
	        </div>
	        <div style="float:left; display:inline-block; margin-top:30px;">
		        <div id="very_soft" class="trainings_player_report">
		           	<div style="text-align: center; margin-top: 10px;">MUY SUAVE</div>	
		           	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		           	En este rango no hay adaptaciones a menos que el nivel físico de la persona sea muy bajo. El metabolismo energético más utilizado es el de los ácidos grasos y la intensidad de trabajo es baja.
	Puede servir para gente con poco nivel físico o para intercalarlo como trabajo de recuperación de otras sesiones más importantes. Tras una sesión dura, introducir trabajo en este rango hace que la recuperación sea más rápida que si se para completamente.
	<b>Recomendada para acondicionamiento básico o rehabilitación cardíaca.</b>
		           	</div>
		        </div>
		        <div id="soft" class="trainings_player_report">
		           	<div style="text-align: center; margin-top: 10px;">SUAVE</div>	
		           	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		           	En este rango ya se empiezan a producir adaptaciones que serán más importantes en función de la calidad y de la cantidad de trabajo que se realice. El metabolismo energético es el de los ácidos grasos y el de los hidratos de carbono, si el nivel de intensidad es elevado la utilización de los hidratos de carbono es mayor.
Se puede utilizar en cualquier grupo que tenga un mínimo de condición física.
<b>Recomendada para mantenimiento físico y salud.</b>
		           	</div>
		        </div>
		        <div id="moderate" class="trainings_player_report">
		           	<div style="text-align: center; margin-top: 10px;">MODERADO</div>	
		           	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		           	Tiene las mismas características que el anterior pero con más intensidad, por tanto la degradación de los hidratos de carbono será mayor en esta zona que en la anterior. Es un trabajo de más calidad y en donde se pueden obtener unas adaptaciones muy interesantes para la mejora de la condición física. De hecho esta zona es ideal para el entrenamiento de la capacidad aeróbica. Diríamos que es la zona deseada de ritmo cardíaco.
<b>Recomendada sólo para deportistas comprometidos y con buena condición física. </b>
		           	</div>
		        </div>
		        <div id="intense" class="trainings_player_report">
		           	<div style="text-align: center; margin-top: 10px;">INTENSO</div>	
		           	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		           	A este nivel se puede trabajar en o muy cerca del umbral anaeróbico, un poco por encima y un poco por debajo. Cuando se entrena dentro de este rango empieza a ser necesario metabolizar el ácido láctico, ya que se genera este compuesto por la alta intensidad.
Se puede entrenar más duro y en muchos momentos con ausencia de oxígeno. Sólo se debe utilizar con gente con un buen nivel de condición física.
<b>Recomendada sólo para deportistas de alto nivel.</b>  
		           	</div>
		        </div>
		        <div id="very_intense" class="trainings_player_report">
		           	<div style="text-align: center; margin-top: 10px;">MUY INTENSO</div>	
		           	<div style="font-size:12px; line-height:2; margin-top:15px; font-style:italic">
		           	En este rango sólo se puede entrenar si se esta perfectamente en forma, es el caso de los deportistas de élite que están controlados constantemente por profesionales del deporte y de la medicina.
Se trabaja siempre por encima del umbral anaeróbico, o sea con deuda de oxígeno. Esto significa que los músculos están utilizando más oxígeno del que puede proporcionar el cuerpo.
<b>Recomendada sólo para deportistas de alto nivel.</b> 
		           	</div>
		        </div>
	        </div>
        </div>
        <div id="sidebar_right" style="width:10%;">
        
        </div>
    </div>
 
</div>
<div id="pie">
<%} %>
</div>
</body>
</html>
