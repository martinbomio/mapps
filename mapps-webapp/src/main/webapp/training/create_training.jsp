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
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		$("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		// Create jqxNumberInput
        $("#num_min_bpm").jqxNumberInput({ width: '220px', height: '25px', decimalDigits: 0, digits: 2, theme: 'metro', spinButtons: true});
		$("#num_max_bpm").jqxNumberInput({ width: '220px', height: '25px', decimalDigits: 0, digits: 3, theme: 'metro', spinButtons: true});
		$("#num_latitude").jqxNumberInput({ width: '220px', height: '25px', decimalDigits: 0, digits: 8, groupSeparator: '', theme: 'metro'});
		$("#num_longitude").jqxNumberInput({ width: '220px', height: '25px', decimalDigits: 0, digits: 8, groupSeparator: '', theme: 'metro'});
		$("#date").jqxDateTimeInput({width: '220px', height: '25px', formatString: 'dd/MM/yyyy HH:mm', theme: 'metro'});

		$("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#create_training").jqxValidator({
            rules: [
        			{input: "#num_max_bpm", message: "El máximo de latidos por minuto debe ser mayor que el mínimo!", action: 'blur', rule: function (input, commit) {
            			var val_max = parseInt($("#num_max_bpm").jqxNumberInput('val'));
            			var val_min = parseInt($("#num_min_bpm").jqxNumberInput('val'));
            			return val_max > val_min;
           				}
        			},
        			{input: "#num_latitude", message: "La latitud debe ser un número de 8 cifras!", action: 'blur', rule: function(input, commit){
        				var val = $("#num_latitude").jqxNumberInput('val');
        				return val.toString().length == 8;
        			}},
        			{input: "#num_longitude", message: "La longitud debe ser un número de 8 cifras!", action: 'blur', rule: function(input, commit){
        				var val = $("#num_longitude").jqxNumberInput('val');
        				return val.toString().length == 8;
        			}},
                    {input: "#sport", message: "El Deporte es obligatorio!", action: 'blur', rule: function (input, commit) {
                        var index = $("#sport").jqxDropDownList('getSelectedIndex');
                        return index != -1;
                       }
                    },
            ],  theme: 'metro'
	        });
		$("#validate").click(function (){ 
	        $('#create_training').jqxValidator('validate');
	    });
		$('#create_training').on('validationSuccess', function (event) {
	        $('#create_training').submit();
	    });
		var source =
        {
            datatype: "json",
            datafields: [
                { name: 'name' },
            ],
            url: "/mapps/getAllSports"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        // Create a jqxInput
        $("#sport").jqxDropDownList({ source: dataAdapter, selectedIndex: 0, width: '220', height: '25',displayMember: "name", valueMember: "name", dropDownHeight: '80', theme: 'metro'});
	});
</script>


<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab">MI CUENTA</div>
		<div id="logout" class="up_tab">CERRAR SESI&Oacute;N</div>
    </div>
</div>
<div id="contenedor">

<div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:12%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab active" onclick="location.href='./trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
  </div>
    <div id="area_de_trabajo" style="height:580px;">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
			<div id="navigation" class="navigation">
            	<a href="./trainings.jsp">ENTRENAMIENTOS</a> >> Programar entrenamiento
            </div>
        	<form action="/mapps/addTraining" method="post" name="create_training" id="create_training">
            	<div id="title" style="margin:15px;">
           			<label> Rellene el siguiente formulario </label>
                </div>
                <div id="campos" class="campos" style="margin-left:100px;">
                	
                    <div id="fecha">
                        <div class="tag_form">Fecha: </div>
                        <div id="date" class="input">
                        </div>
                    </div>
                    <div id="min_bpm">
                        <div class="tag_form" style="vertical-align:top; margin-top:15px;"> Min BPM: </div>
                        <div id="num_min_bpm" class="input" style="margin-top:10px;">
                        </div>
                    </div>
                    <div id="max_bpm">
                        <div class="tag_form" style="vertical-align:top; margin-top:15px;"> Max BPM: </div>
                        <div id="num_max_bpm" class="input" style="margin-top:10px;">
                        </div>
                    </div>
                    <div id="latitude">
                        <div class="tag_form" style="vertical-align:top; margin-top:15px;"> Latitude: </div>
                        <div id="num_latitude" class="input" style="margin-top:10px;">
                        </div>
                    </div>
                    <div id="longitude">
                        <div class="tag_form" style="vertical-align:top; margin-top:15px;"> Longitude: </div>
                        <div id="num_longitude" class="input" style="margin-top:10px;">
                        </div>
                    </div>
                    <div id='sport_div' style="display:inline-block">
                       	<div class="tag_form" style="vertical-align:top; margin-top:15px;"> Deporte: </div>
                        <div class="input" style="margin-top:10px;">
                        	<div id="sport" style="display:inline-block; margin-top:10px"></div>
                        </div>
                    </div>
                    <div style="margin-left:200px; margin-top:20px;">
                    	<input type="button" id="validate" value="CREAR"/>
                    </div>
				</div>
            </form>            
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
