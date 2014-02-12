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
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
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
	
	boolean show_pop_up = false;
	String pop_up_message = "";
	String info = String.valueOf(request.getParameter("info"));
	if (info.equals("null"))
		info = "";
	
	if(info.equals("1")){
		
		pop_up_message = "El entrenamiento fue programado con éxito.";
		show_pop_up = true;	
	}
	if(info.equals("2")){
		
		pop_up_message = "El entrenamiento fue editado con éxito.";
		show_pop_up = true;	
	}
	if(info.equals("3")){
		
		pop_up_message = "Los permisos han sido modificados con éxito.";
		show_pop_up = true;	
	}

%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		
		<%
		if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
		%>
		<%if(trainingStarted.equals("trainingStopped")){ %>
		$("#start_training").jqxButton({ width: '300', height: '50', theme: 'metro'});
		<%}%>
		<%}%>
		$("#jqxMenu").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
	
        <%
		if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
		%>
		<%if(trainingStarted.equals("trainingStopped")){ %>
		$("#start_training").on('click', function () {
			if($("#start_training").val() == "PROGRAMAR ENTRENAMIENTO"){
				window.location.replace("create_training.jsp");
			}else{
				var selected = $('#trainings').jqxListBox('getSelectedItem');
				var uid = selected.value;
				window.location.replace("start_training.jsp?uid="+uid);
			}
		});
		<%}%>
		<%}%>
		$('#pop_up').jqxWindow({ maxHeight: 150, maxWidth: 280, minHeight: 30, minWidth: 250, height: 145, width: 270,
            resizable: false, draggable: false, 
            okButton: $('#ok'), 
            initContent: function () {
                $('#ok').jqxButton({  width: '65px' });
                $('#ok').focus();
            }
        });		
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
		$.ajax({
            url: "/mapps/getTrainingsToStart",
            type: "GET",
            success: function (response){
            	<%if(trainingStarted.equals("trainingStopped")){ %>
            	load_list(JSON.parse(response));
            	<%}%>
            }
		});
	});
	
	function load_list(records){
		if (records.length == 0){
			$("#title").text('No hay entrenamiento programados. Pulse "Programar Entrenamiento" para programar uno');
			$("#start_training").jqxButton('val', "PROGRAMAR ENTRENAMIENTO");
		}else{
			$('#trainings').jqxListBox({ source: records, displayMember: "date", valueMember: "name", itemHeight: 28, height: '250px', width: '40%',autoHeight:true, theme: 'metro',
	        	renderer: function (index, label, value) {
	                var datarecord = records[index];
	                var split = datarecord.date.split(" ");
	                var table = '<table style="min-width: 130px;"><td><center> Entrenamiento programado para el dia: ' + split[0] +'</center></td><td><center> Hora: ' + split[1] +'</center></td></table>';
	                return table;
	            }	
	        });
		}
	}
</script>


<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		<div id="pop_up">
            <div>
                <img width="14" height="14" src="../images/ok.png" alt="" />
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
        <div id="logout" class="up_tab"><a href="../configuration/my_account.jsp">MI CUENTA</a></div>
        <%if(trainingStarted.equals("trainingStarted")){%>
		<div id="logout" class="up_tab"><a href="../index.jsp?logout=1" >CERRAR SESI&Oacute;N</a></div>
		<%}else{ %>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
		<%} %>
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
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <%
					if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){
					%>
					<li style="height:35px;"><a href="./trainings.jsp"> Iniciar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./training_reports.jsp"> Ver entrenamientos anteriores </a></li>
             	   <li style="height:35px;"><a href="./create_training.jsp"> Programar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./edit_training.jsp"> Editar un entrenamiento </a></li>
             	   <%} %>
             	   <%
					if(role.equals(Role.ADMINISTRATOR)){
					%>
             	   <li style="height:35px;"><a href="./change_permissions_training.jsp"> Editar Permisos </a></li>
             	   <%}%>
        		</ul>
  			</div>
        </div>
        <div id="main_div">
        	<div id="title" style="margin:15px;">
        	<%
					if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
					%>
				<%if(trainingStarted.equals("trainingStarted")){ %>
				<label id="title"> Ya existe un entrenamiento en curso. Si desea programar o iniciar otro, termine el entrenamiento actual. </label>
				<%}else{ %>	
           		<label id="title"> Seleccione el entrenamiento que desee comenzar </label>
           		<%} %>
           		<%}else{ %>
           		<label> Usted no tiene permisos para comenzar un entrenamiento </label>
           		<%} %>
           		
            </div>
        	<div id="trainings" style="margin-left:20%;">
            
            </div>
            <%
					if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
					%>
			<%if(trainingStarted.equals("trainingStopped")){ %>		
			<div id="start_training_div">
            	<input type="button" id="start_training" name="start_training" value="INICIAR ENTRENAMIENTO" style="margin-left:175px;" />
            </div>
            <%}%>
            <%}%>
            <%}%> 
        </div>
        <div id="sidebar_right">
        	
        </div>
    </div>
 
</div>
<div id="pie">

</div>
</body>
</html>
