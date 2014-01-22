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
            	var date = response.date.split(" ");
            	$('#training').text(date[0] + ' a las: '+ date[1])
            	//$("#players_list").jqxListBox({ source: athletes, multiple: true, displayMember: "name", valueMember: "idDocument", width: 220, height: 150});
            }});
		$("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		//obtener array de devices de la institucion 
		var source =
        {
            datatype: "json",
            datafields: [
                { name: 'dirLow' },
            ],
            url: "/mapps/getAllDevicesOfInstitution"
        };
		var dataAdapter = new $.jqx.dataAdapter(source);
		// Create a jqxInput
		$("#devices_list").jqxDropDownList({ source: dataAdapter, selectedIndex: 1, width: '220', height: '25', theme: 'metro'});

		$("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#validate").on('click', function (){ 
	        $('#start_training').jqxValidator('validate');
	    });
		$("#start_training").jqxValidator({
            rules: [

            ],  theme: 'metro'
	        });
		$('#start_training').on('validationSuccess', function (event) {
	        $('#start_training').submit();
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
        	<form action="/mapps/..." method="post" name="start_training" id="start_training">
            	<div id="title" style="margin:15px;">
           			<label> Rellene el siguiente formulario </label>
                </div>
                <div id="campos" class="campos" style="margin-left:100px;">
                    <div>
                        <div class="tag_form" style="display:inline-block; vertical-align:top;"> Entrenamiento programado para: </div>
                        <div id='training' style="display:inline-block; margin-top:10px;">
                        	<!-- Aca va el nombre del training que se selecciono en la pag anterior.
                            	 Habria que agrerle algo q lo describa (e.g. dia y hora) -->
				        </div>
                    </div>
                    <div id="player_device_list" style="height:150px; overflow:scroll;">
                    	<!--ESTA DIV TIENE QUE APARECER TANTAS VECES COMO PLAYERS HAYA EN EL TRAINING, por eso hay una div padre que es scrollable 
                        	hay que ponerla en el javascript y hacerle un append al padre por cada player-->
                        <div id="player_device">
                            <div class="tag_form" style="vertical-align:top; margin-top:15px;"> NOMBRE JUGADOR: </div>
                            <div id="devices_list" class="input" style="margin-top:10px;">
                            </div>
                        </div>
                    </div>
                    <div style="margin-left:200px; margin-top:20px;">
                    	<input type="button" id="validate" value="INICIAR"/>
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
