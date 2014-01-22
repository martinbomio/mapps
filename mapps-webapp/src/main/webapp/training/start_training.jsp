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
		$("#jqxMenu").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
        $("#hidden-name").val('<%=trainingUID%>');
		$.ajax({
            url: "/mapps/getTraining",
            dataType: "json",
            type: "POST",
            data: {training:'<%=trainingUID%>'},
            success: function (response){
            	window.training = response;
            	var date = response.date.split(" ");
            	$('#training').text("Entrenamiento programado para: " + date[0] + ' a las: '+ date[1])
            }});
		//Get athletes
		var source =
        {
            datatype: "json",
            data: {t:true},
            url: "/mapps/getAllAthletesOfInstitution"
        };
		var athletesAdapter = new $.jqx.dataAdapter(source);
		$("#players_list").jqxListBox({ selectedIndex: 0, source: athletesAdapter, width: '85%', height: 250, displayMember: "name", valueMember: "idDocument",
			renderer: function (index, label, value) {
                var datarecord = athletesAdapter.records[index];
                if (dataAdapter.records.length == 0){
                	//PONER UN DIV: NO HAY Atletas
                }
                var table = '<div> '+ datarecord.name +' ' + datarecord.lastName+ '</div>';
                return table;	
			}
		});
		//obtener array de devices de la institucion 
		var source =
        {
            datatype: "json",
            url: "/mapps/getAllDevicesOfInstitution"
        };
		var dataAdapter = new $.jqx.dataAdapter(source);
		$("#devices_list").jqxListBox({ selectedIndex: 0, source: dataAdapter, width: '85%', height: 250, displayMember: "dirLow", valueMember: "dirLow"});
		$("#relate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#start_training").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#delete").jqxButton({ width: '100', height: '35', theme: 'metro'});
		$("#dataTable").jqxDataTable(
	        {	
	          	theme: 'metro',
	           	altrows: true,
	            sortable: true,
	            autoRowHeight: true,
	            exportSettings: { fileName: null },
	            columnsResize: true,
	            width: '50%',
	            columns: [
	                { text: 'Atleta', dataField: 'athlete', width: '60%' },
	                { text: 'Dispositivo', dataField: 'device', width: '40%' }
	           ]
	    });
		$("#relate").on('click', function (){ 
	        $('#startTraining').jqxValidator('validate');
	    });
		$("#start_training").on('click', function (){ 
	        $('#submit').jqxValidator('validate');
	    });
		$("#delete").on('click', function (){ 
			var selection = $("#dataTable").jqxDataTable('getSelection');
			for (var i = 0; i < selection.length; i++) {
			    // get a selected row.
				var rowData = selection[i];
				var athlete = $("#players_list").jqxListBox('getItemByValue', rowData.uid);
				var device = $("#devices_list").jqxListBox('getItemByValue', rowData.device);
				$("#players_list").jqxListBox('enableItem', athlete ); 
				$("#devices_list").jqxListBox('enableItem', device ); 
				var index = getIndexInTable(rowData.uid);
				$("#dataTable").jqxDataTable('deleteRow', index);
			}
			$("#dataTable").jqxDataTable('refresh');
	    });
		$("#startTraining").jqxValidator({
            rules: [
					{input: "#players_list", message: "Debe seleccionar por lo menos un atleta!", action: 'blur', rule: function (input, commit) {
						var items = $("#players_list").jqxListBox('getSelectedItems');
						return items.length == 1;
							}
					},
					{input: "#devices_list", message: "Debe seleccionar por lo menos un dispositivo!", action: 'blur', rule: function (input, commit) {
						var items = $("#devices_list").jqxListBox('getSelectedItems');
						return items.length == 1;
							}
					}
            ],  theme: 'metro'
    	});
		$("#submit").jqxValidator({
            rules: [
					{input: "#dataTable", message: "Debe vincular por lo menos un atleta con un dispositivo!", action: 'blur', rule: function (input, commit) {
							var rows = $("#dataTable").jqxDataTable('getRows');
							return rows.length > 0;
						}
					}
            ],  theme: 'metro'
    	});
		$('#startTraining').on('validationSuccess', function (event) {
			var athlete = $("#players_list").jqxListBox('getSelectedItem');
			var device = $("#devices_list").jqxListBox('getSelectedItem');
			if(!athlete.disabled && !device.disabled){
				$("#players_list").jqxListBox('disableItem', athlete ); 
				$("#devices_list").jqxListBox('disableItem', device ); 
				$("#dataTable").jqxDataTable('addRow', athlete.value,{
					athlete: athlete.label,
					device: device.label
				});
			}
	    });
		$('#submit').on('validationSuccess', function (event) {
			var array = $("#dataTable").jqxDataTable('getRows');
            var json = JSON.stringify(array);
            $("#athlete-device").val(json);
			$("#submit").submit();
	    });
	});
	
	function getIndexInTable(uid){
		var rows = $("#dataTable").jqxDataTable('getRows');
		var index = -1;
		for (var i = 0; i < rows.length; i++) {
		    // get a row.
			var rowData = rows[i];
		    if (rowData.uid == uid){
		    	index = i;
		    }
		}
		return index;
	}
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
            	<a href="./trainings.jsp">ENTRENAMIENTOS</a> >> Iniciar entrenamiento
            </div>
            <div id="title" style="margin:15px;">
                <label> Relacione los atletas con su dispositivo correspondiente </label> 
            </div>
            <div>
            	<label id="training"> Entrenamiento: XXXX-XX-XX-XX </label>
            </div>
            <form action="/mapps/startTraining" method="post" name="startTraining" id="startTraining">
	            <div id="selector">
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
	        </form>
	        <form id="submit" action="/mapps/startTraining" name="submit" method="post">
	            <div id="dataTable" style="margin-top:25px; margin-left:50px;">
	            </div>
	            <input type="button" id="delete" name="delete" value="ELIMINAR"></input>
	            <div style="margin-left:45%; margin-top:20px;">
	            	<input type="button" id="start_training" value="COMENZAR"/>
	            </div>
	            <input type="hidden" id="hidden-name" name="hidden-name"/>
	            <input type="hidden" id="athlete-device" name="athlete-device"/>
	        </form>
	    </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="#"> Ver entrenamientos anteriores </a></li>
             	   <li style="height:35px;"><a href="#"> Programar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./edit_training.jsp"> Editar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./change_permissions_training.jsp"> Editar Permisos </a></li>
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
