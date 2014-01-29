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
if (info.equals("null"))
	info = "";

%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		
		$("#start_training").jqxButton({ width: '300', height: '50', theme: 'metro'});
	
		
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
                    <div id="player_xx" class="display_player">
                        <div id="up" style="width:100%; height:60%;">
                            <div id="img" style="display:inline-block; width:35%; height:100%;">
                                <img src="images/athletes/default.png" style="height:55px; margin-top:5px; vertical-align:middle"/>
                            </div>
                            <div id="name" style="display:inline-block; font-size:14px; width:60%; height:100%;">
                                Marcel Novick
                            </div>
                        </div>
                        <div id="down" style="width:100%; height:40%;">
                            <div id="info_distance" class="tab_player_login">
                                <div class="tag_info_player_login"> Distancia</div>
                                <div class="tag_data_player_login"> XXX mts </div>
                            </div>
                            <div id="info_speed" class="tab_player_login" style="border-left:solid 1px;">
                                <div class="tag_info_player_login"> Velocidad</div>
                                <div class="tag_data_player_login"> XXX km/h </div>
                            </div>
                            <div id="info_heart" class="tab_player_login" style="border-left:solid 1px;">
                                <div class="tag_info_player_login"> Pulso</div>
                                <div class="tag_data_player_login"> XXX bpm </div>
                            </div>
                        </div>
                    </div>
                    <div id="player_xx" class="display_player">
                        <div id="up" style="width:100%; height:60%;">
                            <div id="img" style="display:inline-block; width:35%; height:100%;">
                                <img src="images/athletes/default.png" style="height:55px; margin-top:5px; vertical-align:middle"/>
                            </div>
                            <div id="name" style="display:inline-block; font-size:14px; width:60%; height:100%;">
                                Emiliano "el mago" Albin
                            </div>
                        </div>
                        <div id="down" style="width:100%; height:40%;">
                            <div id="info_distance" class="tab_player_login">
                                <div class="tag_info_player_login"> Distancia</div>
                                <div class="tag_data_player_login"> XXX mts </div>
                            </div>
                            <div id="info_speed" class="tab_player_login" style="border-left:solid 1px;">
                                <div class="tag_info_player_login"> Velocidad </div>
                                <div class="tag_data_player_login"> XXX km/h </div>
                            </div>
                            <div id="info_heart" class="tab_player_login" style="border-left:solid 1px;">
                                <div class="tag_info_player_login"> Pulso </div>
                                <div class="tag_data_player_login"> XXX bpm </div>
                            </div>
                        </div>
                    </div>
                    <div id="player_xx" class="display_player">
                        <div id="up" style="width:100%; height:60%;">
                            <div id="img" style="display:inline-block; width:35%; height:100%;">
                                <img src="images/athletes/default.png" style="height:55px; margin-top:5px; vertical-align:middle"/>
                            </div>
                            <div id="name" style="display:inline-block; font-size:14px; width:60%; height:100%;">
                                Joe Emerson Bizera
                            </div>
                        </div>
                        <div id="down" style="width:100%; height:40%;">
                            <div id="info_distance" class="tab_player_login">
                                <div class="tag_info_player_login"> Distancia</div>
                                <div class="tag_data_player_login"> XXX mts </div>
                            </div>
                            <div id="info_speed" class="tab_player_login" style="border-left:solid 1px;">
                                <div class="tag_info_player_login"> Velocidad </div>
                                <div class="tag_data_player_login"> XXX km/h </div>
                            </div>
                            <div id="info_heart" class="tab_player_login" style="border-left:solid 1px;">
                                <div class="tag_info_player_login"> Pulso </div>
                                <div class="tag_data_player_login"> XXX bpm </div>
                            </div>
                        </div>
                    </div>
                    <div id="player_xx" class="display_player">
                        <div id="up" style="width:100%; height:60%;">
                            <div id="img" style="display:inline-block; width:35%; height:100%;">
                                <img src="images/athletes/default.png" style="height:55px; margin-top:5px; vertical-align:middle"/>
                            </div>
                            <div id="name" style="display:inline-block; font-size:14px; width:60%; height:100%;">
                                Carlos Valdez
                            </div>
                        </div>
                        <div id="down" style="width:100%; height:40%;">
                            <div id="info_distance" class="tab_player_login">
                                <div class="tag_info_player_login"> Distancia</div>
                                <div class="tag_data_player_login"> XXX mts </div>
                            </div>
                            <div id="info_speed" class="tab_player_login" style="border-left:solid 1px;">
                                <div class="tag_info_player_login"> Velocidad </div>
                                <div class="tag_data_player_login"> XXX km/h </div>
                            </div>
                            <div id="info_heart" class="tab_player_login" style="border-left:solid 1px;">
                                <div class="tag_info_player_login"> Pulso </div>
                                <div class="tag_data_player_login"> XXX bpm </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        	<div id="start_training_div">
            	<input type="button" id="start_training" name="start_training" value="INICIAR ENTRENAMIENTO" style="margin-left:200px;" />
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
