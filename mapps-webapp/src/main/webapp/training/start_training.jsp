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
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxnumberinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatatable.js"></script> 
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxvalidator.js"></script>
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
String info = String.valueOf(request.getAttribute("info"));
if (info.equals("null"))
	info = "";
String error = String.valueOf(request.getAttribute("error"));
if (error.equals("null"))
	error = "";
String trainingUID = request.getParameter("uid");
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		$.ajax({
            url: "/mapps/getTraining",
            dataType: "json",
            type: "POST",
            data: {training:'<%=trainingUID%>'},
            success: function (response){
            	var date = response.date.split(" ");
            	$('#training').text(date[0] + ' a las: '+ date[1])
            }});
		//Get athletes
		var url = "/mapps/getAllAthletesOfInstitution";		
		$.ajax({
            url: url,
            type: "GET",
            data: {t:true},
            success: function (response){
            	//$("#players_list").jqxListBox({ source: athletes, multiple: true, displayMember: "name", valueMember: "idDocument", width: 220, height: 150});
            }});
		$("#jqxMenu").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		//obtener array de devices de la institucion 
		var source =
        {
            datatype: "json",
            datafields: [
                { name: '....' },
            ],
            url: "/mapps/getAllDevicesOfInstitution"
        };
		var dataAdapter = new $.jqx.dataAdapter(source);
		
		var devices = [
                    "Affogato",
                    "Americano",
                    "Bicerin",
                    "Breve",
                    "Café Bombón",
                    "Café au lait",
                    "Caffé Corretto",
                    "Café Crema",
                    "Caffé Latte",
                    "Caffé macchiato",
                    "Café mélange",
                    "Coffee milk",
                    "Cafe mocha",
                    "Cappuccino",
                    "Carajillo",
                    "Cortado",
                    "Cuban espresso",
                    "Espresso",
                    "Eiskaffee",
                    "The Flat White",
                    "Frappuccino",
                    "Galao",
                    "Greek frappé coffee",
                    "Iced Coffee﻿",
                    "Indian filter coffee",
                    "Instant coffee",
                    "Irish coffee",
                    "Liqueur coffee"
		        ];
		var players;	//arrays para llenar las listas
		
		$("#devices_list").jqxListBox({ selectedIndex: 0, source: devices, width: '85%', height: 250});
		
		$("#players_list").jqxListBox({ selectedIndex: 0, source: devices, width: '85%', height: 250});

		$("#relate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#start_training").jqxButton({ width: '200', height: '35', theme: 'metro'});
		
		$("#dataTable").jqxDataTable(
	        {	
	          	theme: 'metro',
	           	altrows: true,
	            sortable: true,
	            exportSettings: { fileName: null },
	            source: dataAdapter,
	            columnsResize: true,
	            columns: [
	                { text: 'Atleta', dataField: 'name', width: '60%' },
	                { text: 'Dispositivo', dataField: 'lastName', width: '40%' }
	           ]
	    });
	
        
	});
</script>


<div id="header">
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:15px; margin-left:20px;" /></a>
    </div>
    <div id="header_central">

    </div>
    <div id="header_der">
	
    </div>
</div>
<div id="contenedor">

<div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:12%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab active" onclick="location.href='./trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration.jsp'">CONFIGURACI&Oacute;N</div>
  </div>
    <div id="area_de_trabajo" style="height:580px;">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
			<div id="navigation" class="navigation">
            	<a href="./trainings.jsp">ENTRENAMIENTOS</a> >> Iniciar entrenamiento
            </div>
            <div id="title" style="margin:15px;">
                <label> Relacione los atletas con su dispositivo correspondiente </label> 
            </div>
            <div>
            	<label> Entrenamiento: XXXX-XX-XX-XX </label>
            </div>
            <div>
                <div id="main_div_left" style="float:left; width:50%; display:inline-block;">
                    <div id="players_list">
                    
                    </div>
                </div>
                <div id="main_div_right" style="float:right; width:50%; display:inline-block;">
                    <div id="devices_list">
                    
                    </div>
                </div>
            </div>
            <div style="margin-left:45%; margin-top:20px;">
            	<input type="button" id="relate" value="RELACIONAR"/>
            </div>
            <div id="dataTable" style="margin-top:25px; margin-left:50px;">
            
            </div>
            <div style="margin-left:45%; margin-top:20px;">
            	<input type="button" id="start_training" value="COMENZAR"/>
            </div>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="#"> Ver entrenamientos anteriores </a></li>
             	   <li style="height:35px;"><a href="#"> Programar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./edit_training.jsp"> Editar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="#">  </a></li>
        		</ul>
  			</div>
        </div>
    </div>
 
</div>
<div id="pie">

</div>
</body>
</html>
