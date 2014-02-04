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
    <link href="../scripts/nv.d3.min.css" rel="stylesheet" type="text/css">
    <script src="../scripts/d3.v3.js"></script>
    <script src="../scripts/nv.d3.min.js"></script>

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
			setInterval(function(){
				athlete_stats();
			}, 5000);
					
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
	
	function pulseData() {
		var data = window.athleteData;
		var series = [];
		for(var i = 0 ; i<data.length; i++){
			var series1 = [];
		    for(var j =0; j < data[i].time.length; j ++) {
		        if((data[i].pulse[j])==null){
		        	series1.push({
			            x: data[i].time[j], y: 0
			        });	
		        }else{
		    	series1.push({
		            x: data[i].time[j], y: data[i].pulse[j]
		        });
		        }
		        
		    }
		    var ret = {
		                   key: data[i].athlete.name,
		                   values: series1,
		                   color: "#0000ff"
		               };
		    series.push(ret);
		}
	    return series;
	}
	
	function myData() {
		var data = window.athleteData;
		var series = [];
		for(var i = 0 ; i<data.length; i++){
			var series1 = [];
		    for(var j =0; j < data[i].posX.length; j ++) {
		        series1.push({
		            x: data[i].posX[j], y: data[i].posY[j]
		        });
		    }
		    var ret = {
		                   key: data[i].athlete.name,
		                   values: series1,
		                   color: "#0000ff"
		               };
		    series.push(ret);
		}
	    return series;
	}
	function velocityData() {
		var data = window.athleteData;
		var series = [];
		for(var i = 0 ; i<data.length; i++){
			var series1 = [];
		    for(var j =0; j < data[i].time.length; j ++) {
		        series1.push({
		            x: data[i].time[j], y: data[i].velocity[j]
		        });
		    }
		    var ret = {
		                   key: data[i].athlete.name,
		                   values: series1,
		                   color: "#0000ff"
		               };
		    series.push(ret);
		}
	    return series;
	}
	function success(){
	    nv.addGraph(function() {
	        var chart = nv.models.lineChart();

	        chart.xAxis
	            .axisLabel("Posicion X");
	        
	       chart.yAxis    
	            .tickFormat(d3.format("d"));

	       d3.select("#position")
	            .datum(myData())
	            .transition().duration(500).call(chart);
	       
	       d3.select("#pulse")
           .datum(pulseData())
           .transition().duration(500).call(chart);
	       
	       d3.select("#velocity")
           .datum(velocityData())
           .transition().duration(500).call(chart);

	        nv.utils.windowResize(
	                function() {
	                    chart.update();
	                }
	            );

	        return chart;
	    });
	}

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
	
</script>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
    
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab">MI CUENTA</div>
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
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="training" style="width:100%; height:40px;"> 
            
            </div>
            <div>
            	<div id="graphicPosition" style="height:400px; width:60%; display:inline-block;">
                	<svg id="position"/>
                </div>
                <div id="graphicPulse" style="height:400px; width:60%; display:inline-block;">
                	<svg id="pulse"/>
                </div>
                <div id="graphicVelocity" style="height:400px; width:60%; display:inline-block;">
                	<svg id="velocity"/>
                </div>
              
                
               
                <div id="list_players">                
                </div>
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