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

	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
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

String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";

String trainingName = String.valueOf(request.getParameter("t"));
String athleteID = String.valueOf(request.getParameter("a"));
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		window.created = false;
		window.pulse_data = [];
		window.pulse_min = 220;
		window.pulse_max = 0;
		window.chart = '';
	 	athlete_stats(false);
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
						athlete_stats(true);
					}, 
		2000);
		
	});
	
	function athlete_stats(reload){
		window.athleteData = '';
		$.ajax({
            url: "/mapps/getAthleteOnTrainingData",
            type: "POST",
            data: {a:<%="'"+athleteID+"'"%> , t:<%="'"+trainingName+"'"%>, r:reload},
            success: function (response){
            	if (window.created){
            		update_values(response);
            	}else{
            		create_values(response);
            		window.created = true;
            	}
        	},
		});
	}
	

	
	function pulseData(data) {
		for(var i = 0 ; i<data.pulse.length; i++){
			if((data.pulse[i])==null){
				window.pulse_data.push({
					time: data.time[i], pulse: 0
				});	
			}else{
				if(data.pulse[i] > window.pulse_max){
					window.pulse_max = data.pulse[i];
				}else if(data.pulse[i] < window.pulse_min){
					window.pulse_min = data.pulse[i];
				}
				window.pulse_data.push({
					time: data.time[i], pulse: data.pulse[i]
				});
			}				
		}
	}
	
	function create_values(response){
		document.getElementById('name').innerHTML = response.athlete.name+' '+response.athlete.lastName;
	  	// prepare chart data as an array
        pulseData(response);
		
		
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
			
		// aca debe ponerse el gauge (jqx)
		pulseGauge();
		
		window.chart = pulse_time_chart;
	}
	
	function update_values(response){
		pulseData(response);
		document.getElementById('pulse_data').innerHTML = window.pulse_data[window.pulse_data.length-1].pulse+' '+'bpm';
		document.getElementById('calories_data').innerHTML = Math.round(response.kCal)+' '+'kCal';
		document.getElementById('pulse_data_min').innerHTML = window.pulse_min;
		document.getElementById('pulse_data_max').innerHTML = window.pulse_max;
		$('#gaugeContainer').jqxGauge('value', window.pulse_data[window.pulse_data.length-1].pulse);
		window.chart.validateData();
	}
	
	
	function pulseGauge(){
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
            width: '45%',
            height: 200,
            min: 60,
            max: 220
        });
		$('#gaugeContainer').jqxGauge('value', window.pulse_data[window.pulse_data.length-1].pulse);
		
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
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
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
    <div id="area_de_trabajo" style="height:900px;">
		<div id="sidebar_left" style="width:10%;">
        
        </div>
        <div id="main_div" style="width:80%;">
        	<div id="training" style="width:100%; height:40px;"> 
            
            </div>
            <div id="main_div_up" style="float:left; height:200px; margin-top:30px; width:100%;">
                <div id="img" style="float:left; height:100px; width:15%; display:inline-block; padding-top:10px; padding-bottom:10px;">
                    	<img src="../images/athletes/default.png" height="80px" />
                </div>
                <div id="data"  style="float:left; height:100px; width:70%; display:inline-block; padding-top:10px; padding-bottom:10px;">
                 	<div id="name" class="data_info_index">
                       	
                    </div>
                    <div id="gaugeContainer" style="height:160px; width:50%; float:left;">                
                	
               		</div>
               		<div id="pulse_min" class="data_info_index_min" style="margin-top:30px;">
	                  	<div style="height:40px; text-align:center;">
	            	        min
	                    </div>
	                    <div id="pulse_data_min" class="data_index_min">
	                        	
	                    </div>
	                </div>
	                <div id="pulse" class="data_info_index" style="margin-top:30px;">
	                  	<div style="height:40px; text-align:center;">
	                        PULSO
	                    </div>
	                    <div id="pulse_data" class="data_index">
	                          	
	                    </div>
	                </div>
	                <div id="pulse_max" class="data_info_index_min" style="margin-top:30px;">
	                  	<div style="height:40px; text-align:center;">
	                        max
	                    </div>
	                    <div id="pulse_data_max" class="data_index_min">
	                          	
	                    </div>
	                </div>
               		
	            </div>
	            <div style="float:left; height:200px; width:40%;">
	                <div id="calories" class="data_info_index" style="margin-top:30px;">
	                  	<div style="height:40px; text-align:center;">
	                	    CALORIAS
	                    </div>
	                    <div id="calories_data" class="data_index">
	                          	
	                    </div>
	                </div>
	            </div>             
            </div>
            <div id="main_div_down" style="float:left; height:200px; margin-top:30px; width:100%;">
            	<div>Pulsaciones</div>
                <div id="graphicPulse" style="height:280px; width:65%; display:inline-block;">
                            
                </div>
                <div id="graphic_pie" style="float:right; display:inline-block; height:280px; width:30%;">
                
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
