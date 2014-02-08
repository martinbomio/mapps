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
}
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
		// athlete_stats();
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
			
			/*
			setInterval(function(){
				athlete_stats();
			}, 5000);
			*/	
			
		success();
		
	});
	
	function athlete_stats(){
		window.athleteData = [];
		window.athleteIndex = 0;
		$.ajax({
            url: "/mapps/getAthleteOnTrainingData",
            type: "POST",
            data: {a:<%="'"+athleteID+"'"%> , t:<%="'"+trainingName+"'"%>},
            success: function (response){
            	if (window.created){
            		update_values(response);
            	}else{
            		create_label(response);
            		window.created = true;
            	}
            	window.athleteData.push(response);
                window.athleteIndex+=1;
            	success();
                
        	},
		});
	}
	
	function update_stats(){
		window.athleteData = [];
		window.athleteIndex = 0;
		$.ajax({
            url: "/mapps/getAthleteOnTrainingData",
            type: "POST",
            data: {a:<%="'"+athleteID+"'"%> , t:<%="'"+trainingName+"'"%>},
            success: function (response){
            	if (window.created){
            		update_values(response);
            	}else{
            		create_label(response);
            		window.created = true;
            	}
            	window.athleteData.push(response);
                window.athleteIndex+=1;
            	success();
                
        	},
		});
	}
	
	function pulseData() {
		var data = window.athleteData;
		var series = [];
		for(var i = 0 ; i<data.length; i++){
			if( data[i].time.length > 300 ){
				for(var j = data[i].time.length - 300; j < data[i].time.length ; j = j + 10) {
					if((data[i].pulse[j])==null){
						series.push({
							time: data[i].time[j], pulse: 0
						});	
					}else{
						series1.push({
							time: data[i].time[j], pulse: data[i].pulse[j]
						});
					}				
				}
			}else {
				for(var j = 0 ; j < data[i].time.length ; j = j + 10) {
					if((data[i].pulse[j])==null){
						series.push({
							time: data[i].time[j], pulse: 0
						});	
					}else{
						series1.push({
							time: data[i].time[j], pulse: data[i].pulse[j]
						});
					}				
				}
			}
		}
	    return series;
	}
	
	function success(){
	  	// prepare chart data as an array
        //var pulse_data = pulseData();
				
			
		var pulse_time_chart = new AmCharts.AmSerialChart();
		//pulse_time_chart.dataProvider = pulse_data;
		pulse_time_chart.categoryField = "x";
		/*
		var speed_category_axis = speed_chart.categoryAxis;
		speed_category_axis.parseDates = true;
		speed_category_axis.minPeriod = 'fff';
		speed_chart.dataDateFormat = "NN-SS";
		*/
			
		var pulse_time_graph = new AmCharts.AmGraph();
		pulse_time_graph.valueField = "y";
		pulse_time_graph.type = "line";
		pulse_time_graph.title = "Pulso (bpm)";
		pulse_time_graph.balloonText = "[[value]] bpm";
		pulse_time_graph.fillAlphas = 0.5;
		pulse_time_chart.addGraph(pulse_time_chart);
			
		var chartScrollbar = new AmCharts.ChartScrollbar();
		pulse_time_chart.addChartScrollbar(chartScrollbar);
			
		var chartCursor = new AmCharts.ChartCursor();
		chartCursor.cursorPosition = "mouse";
		pulse_time_chart.addChartCursor(chartCursor);
			
		pulse_time_chart.write('graphicPulse');
			
		// aca debe ponerse el gauge (jqx)
		pulseGauge();
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
            width: '30%',
            min: 60,
            max: 220
        });
        $('#gaugeContainer').on('valueChanging', function (e) {
            $('#gaugeValue').text(Math.round(e.args.value) + ' bpm');
        });
        $('#gaugeContainer').jqxGauge('value', 140);
		
	}
	
	
/*
	function create_label(data){
		var athlete = data.athlete;
		var distance = new String(data.traveledDistance);
		var split = distance.split('.');
		var distance = split[0] + '.' + split[1].substr(0,1);
		split = new String(data.averageSpeed).split('.');
		var speed = split[0] + '.' + split[1].substr(0,1);
		var players_div = $("#list_players");
		var first_div = $('<div id="'+athlete.idDocument+'" class="display_player"></div');
		var div_up = $('<a href="player_view_training.jsp?a='+athlete.idDocument+'&t='+data.trainingName+'"><div id="up" style="width:100%; height:60%;"><div id="img" style="display:inline-block; width:35%; height:100%;"><img src="'+athlete.imageURI+'" style="height:55px; margin-top:5px; vertical-align:middle"/></div><div id="name" style="display:inline-block; font-size:14px; width:60%; height:100%;">'+athlete.name+' '+athlete.lastName+'</div></div></a>');
		var div_down = $('<div id="down" style="width:100%; height:40%;"><div id="info_distance" class="tab_player_login"><div class="tag_info_player_login"> Distancia</div><div id="distance'+athlete.idDocument+'" class="tag_data_player_login"> '+ distance +' mts </div></div><div id="info_speed" class="tab_player_login" style="border-left:solid 1px;"><div class="tag_info_player_login"> Velocidad Promedio</div><div id="speed'+athlete.idDocument+'" class="tag_data_player_login"> '+speed+' km/h </div></div><div id="info_heart" class="tab_player_login" style="border-left:solid 1px;"><div class="tag_info_player_login"> Pulso</div><div id="pulse'+athlete.idDocument+'" class="tag_data_player_login"> '+data.pulse[data.pulse.length-1]+' bpm </div></div></div>');
		first_div.append(div_up);
		first_div.append(div_down);
		players_div.append(first_div);
	}

	function update_values(data){
		var athlete = data.athlete;
		var distance = new String(data.traveledDistance);
		var split = distance.split('.');
		var distance = split[0] + '.' + split[1].substr(0,1);
		split = new String(data.averageSpeed).split('.');
		var speed = split[0] + '.' + split[1].substr(0,1);
		$('#distance'+athlete.idDocument+'').text(distance);
		$('#speed'+athlete.idDocument+'').text(speed);
		$('#pulse'+athlete.idDocument+'').text(data.pulse[data.pulse.length-1]);
	}
*/	
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
                <div id="data"  style="float:left; height:100px; width:50%; display:inline-block; padding-top:10px; padding-bottom:10px;">
                 	<div id="name" class="data_info_index">
                       	Martin
                       	Bomio
                    </div>
                    <div id="pulse_min" class="data_info_index_min" style="margin-top:30px;">
                      	<div style="height:40px; text-align:center;">
                        min
                        </div>
                        <div id="pulse_data" class="data_index_min">
                          	71
                        </div>
                    </div>
                    <div id="pulse" class="data_info_index" style="margin-top:30px;">
                      	<div style="height:40px; text-align:center;">
                        PULSO
                        </div>
                        <div id="pulse_data" class="data_index">
                          	79 bpm
                        </div>
                    </div>
                    <div id="pulse_max" class="data_info_index_min" style="margin-top:30px;">
                      	<div style="height:40px; text-align:center;">
                        max
                        </div>
                        <div id="pulse_data" class="data_index_min">
                          	140
                        </div>
                    </div>
                    <div id="calories" class="data_info_index" style="margin-top:30px;">
                      	<div style="height:40px; text-align:center;">
                        CALORIAS
                        </div>
                        <div id="calories_data" class="data_index">
                          	475
                        </div>
                    </div>
                </div>
                <div id="gaugeContainer" style="height:160px; width:40%; float:left;">                
                	
               	</div>
                <!-- <div id="gaugeValue" style="position: absolute; top: 500px; left: 832px; font-family: Sans-Serif; text-align: center; font-size: 17px; width: 70px;">
                    
                </div> -->               
            </div>
            <div id="main_div_down" style="float:left; height:200px; margin-top:30px; width:100%;">
            	Pulsaciones
                <div id="graphicPulse" style="height:280px; width:85%;">
                            
                </div>
                <div id="graphic_pie">
                
                </div>
			</div>
        </div>
        <div id="sidebar_right" style="width:10%;">
        
        </div>
    </div>
 
</div>
<div id="pie">

</div>
</body>
</html>
