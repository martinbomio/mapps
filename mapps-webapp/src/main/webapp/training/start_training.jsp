<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link rel="shortcut icon" href="../favicon.ico" />
	<title>Mapps</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
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
}else {
	String trainingStarted = String.valueOf(session.getAttribute("trainingStarted"));
	if (trainingStarted.equals("null"))
	trainingStarted = "";
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
		set_tab_child_length();
		window.related = 0;
		$("#relate_div").hide();
		
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
		$("#players_list").jqxListBox({ selectedIndex: 0, source: athletesAdapter, width: '100%', height: 250, displayMember: "name", valueMember: "idDocument",
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
		$("#devices_list").jqxListBox({ selectedIndex: 0, source: dataAdapter, width: '100%', height: 250, displayMember: "dirLow", valueMember: "dirLow"});
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
				window.related--;
			}
			$("#dataTable").jqxDataTable('refresh');
			if (window.related == 0){
				$("#relate_div").hide();
			}
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
			if (window.related == 0){
				$("#relate_div").show();
			}
			var athlete = $("#players_list").jqxListBox('getSelectedItem');
			var device = $("#devices_list").jqxListBox('getSelectedItem');
			if(!athlete.disabled && !device.disabled){
				$("#players_list").jqxListBox('disableItem', athlete ); 
				$("#devices_list").jqxListBox('disableItem', device ); 
				$("#dataTable").jqxDataTable('addRow', athlete.value,{
					athlete: athlete.label,
					device: device.label
				});
				window.related++;
			}
	    });
		$('#submit').on('validationSuccess', function (event) {
			var array = $("#dataTable").jqxDataTable('getRows');
            var json = JSON.stringify(array);
            $("#athlete-device").val(json);
			$("#submit").submit();
	    });
		$("#tabs").jqxMenu({ width: '100%', height: '50px',theme:'metro'});
        
        var centerItems = function () {
            var firstItem = $($("#jqxMenu ul:first").children()[0]);
            firstItem.css('margin-left', 0);
            var width = 0;
            var borderOffset = 2;
            $.each($("#jqxMenu ul:first").children(), function () {
                width += $(this).outerWidth(true) + borderOffset;
            });
            var menuWidth = $("#jqxMenu").outerWidth();
            firstItem.css('margin-left', (menuWidth / 2 ) - (width / 2));
        }
        set_tab_child_length();
        centerItems();
        $(window).resize(function () {
      	  set_tab_child_length();
            centerItems();
        });
});
function set_tab_child_length(){
	var size = $('#ref_tab').width();
	for (var i=0; i<3; i++){
		$('#ul_'+i+'').width(size + 12);
	}
}
	
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
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central">
		
    </div>
    <div id="header_der">
        <div id="logout" class="up_tab"><a href="../configuration/my_account.jsp">MI CUENTA</a></div>
		<%if(trainingStarted.equals("trainingStarted")){%>
		<div id="logout" class="up_tab"><a href="../index.jsp?logout=1" >CERRAR SESI&Oacute;N</a></div>
		<%}else{ %>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
		<%} %>
    </div>
</div>
<div id="contenedor">

<div id='tabs' style="background-color:#4DC230; color:#FFF;text-align: center;">
                <ul>
                    <li style="width:18%; text-align:center; margin-left:11%; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;"><a href="../index.jsp">INICIO</a></li>
                    <li id="ref_tab" style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">JUGADORES
                        <ul id="ul_0" style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/athletes.jsp">VER</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/add_athletes.jsp">AGREGAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/edit_athletes.jsp">EDITAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/delete_athletes.jsp">ELIMINAR</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;">ENTRENAMIENTOS
                        <ul id="ul_1" style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="../training/training_reports.jsp">VER ANTERIORES</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/trainings.jsp">COMENZAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/create_training.jsp">PROGRAMAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/edit_training.jsp">EDITAR</a></li>
                            <%}%>
             	   		<%if(role.equals(Role.ADMINISTRATOR)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/change_permissions_training.jsp">EDITAR PERMISOS</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">CONFIGURACI&Oacute;N
                        <ul id="ul_2" style="width:296px;">
                            <li style="text-align:center;font-size:16px;height:30px;">CUENTA
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/my_account.jsp">MI CUENTA</a></li>
                                </ul>
                            </li>
                            <%if(role.equals(Role.ADMINISTRATOR)){%>
                            <li style="text-align:center;font-size:16px;height:30px;">USUARIOS
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/register_user.jsp">AGREGAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/edit_user.jsp">EDITAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/delete_user.jsp">ELIMINAR</a></li>
                                </ul>
                            </li>
                            <li style="text-align:center;font-size:16px;height:30px;">INSTITUCIONES
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/add_institution.jsp">AGREGAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/edit_institution.jsp">EDITAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/delete_institution.jsp">ELIMINAR</a></li>
                                </ul>
                            </li>
                            <%}%>
                            <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;">DEPORTES
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/add_sport.jsp">AGREGAR</a></li>
                                </ul>
                            </li>
                            <li style="text-align:center;font-size:16px;height:30px;">DISPOSITIVOS
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/add_device.jsp">AGREGAR</a></li>
                                    <%if(role.equals(Role.ADMINISTRATOR)){%>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/edit_device.jsp">EDITAR</a></li>
                                    <%}%>
                                </ul>
                            </li>
                            <%}%>
                        </ul>
                    </li>
                </ul>
            </div>
    <div id="area_de_trabajo" style="height:610px;">
		<div id="sidebar_left">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <%
					if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
					%>
				   <li style="height:35px;"><a href="./trainings.jsp"> Iniciar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./training_reports.jsp"> Ver entrenamientos anteriores </a></li>
             	   <li style="height:35px;"><a href="#"> Programar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./edit_training.jsp"> Editar un entrenamiento </a></li>
             	   <%} %>
             	   <%
					if(role.equals(Role.ADMINISTRATOR)){
					%>
             	   <li style="height:35px;"><a href="./change_permissions_training.jsp"> Editar Permisos </a></li>
             	   <%
					}
}
					%>
        		</ul>
  			</div>
        </div>
        <div id="main_div">
			<div id="navigation" class="navigation">
            	<a href="./trainings.jsp">ENTRENAMIENTOS</a> >> Iniciar entrenamiento
            </div>
            <div id="title" style="margin-top:20px;margin-bottom:10px">
                <label> Relacione los atletas con su dispositivo correspondiente </label> 
            </div>
            <div>
            	<label id="training" style="margin-left:10px;margin-bottom:5px;"> Entrenamiento: XXXX-XX-XX-XX </label>
            </div>
            <form action="/mapps/startTraining" method="post" name="startTraining" id="startTraining">
	            <div id="selector" style="display:inline-block;width: 80%;margin-right: 10%;margin-top:20px;margin-left: 10%;">
	            	<div style="width: 30%;margin-left: 2%;margin-right: 2%;display: inline-block;float: left;">
	            	<center><label>Jugadores:</label></center>
	                <div id="main_div_left" style="float:left; width: 90%; display:inline-block; margin:2%;padding-left: 3%;padding-right: 2%;padding-top: 2%;">
	                    <div id="players_list">
	                    
	                    </div>
	                </div>
	                </div>
	                <div style="width: 30%;margin-left: 2%;margin-right: 2%;display: inline-block;float: left;">
	                <center><label>Dispositivos:</label></center>
	                <div id="main_div_right" style="float:left; width: 90%; display:inline-block; margin:2%;padding-left: 3%;padding-right: 2%;padding-top: 2%;">
	                    <div id="devices_list">
	                    
	                    </div>
	                </div>
	                </div>
	                <div style="margin-left:15px; margin-top:15px;float:left;">
	            		<input type="button" id="relate" value="RELACIONAR"/>
	            	</div>
	            </div>
	        </form>
	        <form id="submit" action="/mapps/startTraining" name="submit" method="post" style="display: inline-block;width: 100%;">
	        	<div id="relate_div" style="display: inline-block;width: 100%;">
		            <div id="dataTable" style="margin-top: 25px; margin-left: 130px; margin-right: 15px;float: left;">
		            </div>
		            <div id="delete_div" style="height: 35px;margin-top: 40px;">
		            	<input type="button" id="delete" name="delete" value="ELIMINAR"></input>
		            </div>
	            </div>
	            <div style="margin-left: 28%; margin-top: 40px;">
	            	<input type="button" id="start_training" value="COMENZAR"/>
	            </div>
	            <input type="hidden" id="hidden-name" name="hidden-name"/>
	            <input type="hidden" id="athlete-device" name="athlete-device"/>
	        </form>
	    </div>
        <div id="sidebar_right">
        	
        </div>
    </div>
 
</div>
<div id="pie">

</div>
</body>
</html>
