<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<%@ page import="com.mapps.model.Gender" %>
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
	<script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../scripts/demos.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxnumberinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxpasswordinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmaskedinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
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
%>
<body>

<script type="text/javascript">
$(document).ready(function () {
	//Get athletes

	$("#jqxMenu").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
    $("#jqxMenu").css('visibility', 'visible');
	// Create jqxNumberInput
    $("#num_min_bpm").jqxNumberInput({ width: '50%', height: '25px', decimalDigits: 0, digits: 2, theme: 'metro', spinButtons: true});
	$("#num_max_bpm").jqxNumberInput({ width: '50%', height: '25px', decimalDigits: 0, digits: 3, theme: 'metro', spinButtons: true});
	$("#num_latitude").jqxNumberInput({ width: '50%', height: '25px', decimalDigits: 0, digits: 8, groupSeparator: '', theme: 'metro'});
	$("#num_longitude").jqxNumberInput({ width: '50%', height: '25px', decimalDigits: 0, digits: 8, groupSeparator: '', theme: 'metro'});
	$("#date").jqxDateTimeInput({width: '50%', height: '25px', formatString: 'dd/MM/yyyy HH:mm',theme: 'metro'});

	$("#validate").jqxButton({ width: '50%', height: '35', theme: 'metro'});
	
	$("#edit_training").jqxValidator({
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
        $('#edit_training').jqxValidator('validate');
    });
	$('#edit_training').on('validationSuccess', function (event) {
        $('#edit_training').submit();
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
    $("#sport").jqxDropDownList({ source: dataAdapter, selectedIndex: 0, width: '100%', height: '25',displayMember: "name", valueMember: "name", dropDownHeight: '80', theme: 'metro'});

		//Get institutions
		var url = "/mapps/getAllEditableTrainings";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				create_list(response);	            	
            },
        	   
		});
});

	function create_list(response){
		var trainings = response;
		$('#list_trainings').on('select', function (event) {
            updatePanel(trainings[event.args.index]);
        });
		
		$('#list_trainings').jqxListBox({ selectedIndex: 0,  source: trainings, displayMember: trainings.date, valueMember: "name", itemHeight: 35, height: '100%', width: '300', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = trainings[index];
                var split = datarecord.date.split(" ");
                var display_name = "Entrenamiento iniciado el: " + split[0] + " a las " + split[1] + "horas";
                var table = '<table style="min-width: 130px;"><td>' + datarecord.name + '</td></table>';
                return table;
            }
        });
		updatePanel(trainings[0]);
	}
	function updatePanel(trainings){
		
		$('#date').jqxDateTimeInput('val', trainings['date']);
		$('#num_min_bpm').jqxNumberInput('val', trainings['minBPM']);
		$('#num_max_bpm').jqxNumberInput('val', trainings['maxBPM']);
		$('#num_latitude').jqxNumberInput('val', trainings['latOrigin']);
		$('#num_longitude').jqxNumberInput('val', trainings['longOrigin']);
		$('#sport').jqxDropDownList('val', trainings['sport'].name);
		$('#name-hidden').val(trainings.name);
		
		
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
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab active" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo" style="height:550px;">
		<div id="sidebar_left">
			<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	    <%
					if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
					%>
             	    <li style="height:35px;"><a href="./training_reports.jsp"> Ver entrenamientos anteriores </a></li>
             	    <li style="height:35px;"><a href="./create_training.jsp"> Programar un entrenamiento </a></li>
             	    <li style="height:35px;"><a href="./edit_training.jsp"> Editar un entrenamiento </a></li>
             	    <%} %>
             	    <%
					if(role.equals(Role.ADMINISTRATOR)){
					%>
             	    <li style="height:35px;"><a href="./change_permissions_training.jsp"> Editar Permisos </a></li>
             	    <%} %>
             	    <li style="height:35px;"><a href="#">  </a></li>
        		</ul>
  			</div>
        </div>	   
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./training.jsp">ENTRENAMIENTOS</a> >> Editar un entrenamiento
            </div>
	        <div id="main_div_left" style="float:left; width:50%; display:inline-block;">
            	<div id="title" style="margin:15px;">
                    <label> 1) Seleccione un entrenamiento </label>
                </div>
        		<div id="list_trainings">
                </div>
            </div>
            <div id="main_div_right" style="float:right; width:50%; display:inline-block;">
                <form action="/mapps/modifyTraining" method="post" name="edit_training" id="edit_training">
            	<div id="title" style="margin:15px;">
           			<label> 2) Modifique los datos que desee </label>
                </div>
                <div id="campos" class="campos" style="margin-left:10%;">
                	
                    <div id="fecha">
                        <div class="tag_form_editar" style="vertical-align:top;">Fecha: </div>
                        <div id="date" class="input" style="margin-top:10px;">
                        </div>
                    </div>
                    <div id="min_bpm">
                        <div class="tag_form_editar" style="vertical-align:top; margin-top:15px;"> Min BPM: </div>
                        <div id="num_min_bpm" class="input" style="margin-top:10px;">
                        </div>
                    </div>
                    <div id="max_bpm">
                        <div class="tag_form_editar" style="vertical-align:top; margin-top:15px;"> Max BPM: </div>
                        <div id="num_max_bpm" class="input" style="margin-top:10px;">
                        </div>
                    </div>
                    <div id="latitude">
                        <div class="tag_form_editar" style="vertical-align:top; margin-top:15px;"> Latitude: </div>
                        <div id="num_latitude" class="input" style="margin-top:10px;">
                        </div>
                    </div>
                    <div id="longitude">
                        <div class="tag_form_editar" style="vertical-align:top; margin-top:15px;"> Longitude: </div>
                        <div id="num_longitude" class="input" style="margin-top:10px;">
                        </div>
                    </div>
                    <div id="sport_div">
                       	<div class="tag_form_editar" style="vertical-align:top; margin-top:15px;"> Deporte: </div>
                        <div class="input">
                        	<div id="sport" style="display:inline-block; margin-top:10px"></div>
                        </div>
                    </div>
                    <input type="hidden" id="name-hidden" name="name-hidden"></input>

                    <div style="margin-left:30%; margin-top:20px;">
                    	<input type="button" id="validate" value="CONFIRMAR"/>
                    </div>
				</div>
            </form> 
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
