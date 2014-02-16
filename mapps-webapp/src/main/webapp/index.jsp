	<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <link href='http://fonts.googleapis.com/css?family=Roboto:400,300,100,100italic,300italic,400italic,500,700' rel='stylesheet' type='text/css'>
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type='text/javascript' src="./scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxchart.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxscrollbar.js"></script>
	<link rel="stylesheet" href="./jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="./jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/main_style.css"> 
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	response.sendRedirect("index_login.jsp");	
}else{
	
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
boolean training_started=false;
String pop_up_message = "";
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null")){
	info = "";
}else if (info.equals("10")){
	pop_up_message = "El entrenamiento se ha finalizado con éxito";
	show_pop_up = true;
}else if(info.equals("1")){
	// La Institucion ha sido ingresada con exito
	pop_up_message = "La institucion ha sido ingresada con éxito al sistema.";
	show_pop_up = true;	
}else if(info.equals("2")){
	// El dispositivo ha sido ingresada con exito
	pop_up_message = "El dispositivo ha sido ingresado al sistema con éxito.";
	show_pop_up = true;	
}else if(info.equals("3")){
	pop_up_message = "El usuario ha sido ingresado al sistema con éxito.";
	show_pop_up = true;	
}else if(info.equals("4")){
	pop_up_message = "El deporte ha sido ingresado al sistema con éxito.";
	show_pop_up = true;	
}else if(info.equals("5")){
	pop_up_message = "El usuario ha sido modificado con éxito.";
	show_pop_up = true;	
}else if(info.equals("6")){
	pop_up_message = "La institución ha sido modificado con éxito.";
	show_pop_up = true;	
}else if(info.equals("7")){
	pop_up_message = "El dispositivo ha sido modificado con éxito.";
	show_pop_up = true;	
}else if(info.equals("11")){
	pop_up_message = "El entrenamiento ha comenzado.";
	show_pop_up = true;	
}

String logout = String.valueOf(request.getParameter("logout"));
if (logout.equals("null")){
	logout = "";
}else if (logout.equals("1")){
	pop_up_message = "Por favor termine el entrenamiento en curso antes de cerrar sesión";
	show_pop_up = true;
}

String error = String.valueOf(request.getParameter("error"));
if (error.equals(10)){
	pop_up_message = "Error de autenticación o no se tiene los permisos necesarios para realizar esta operación";
	show_pop_up = true;
}
else if(error.equals(11)){
	pop_up_message = "El entrenamiento que desae parar no es válido";
	show_pop_up = true;
}
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		window.created = false;
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
			var url = "/mapps/getStartedTraining";
			$.ajax({
	            url: url,
	            type: "GET",
	            success: function (response){
	            	var training = response;
	            	if(training=="not started"){
	            		create_static_labels();
	            	}else{
	            		hide_static_labels();
	            		var training = JSON.parse(training);
	            		create_stop_training(training.name);
	            		var split = training.date.split(" ");
	            		var display_name = "Entrenamiento iniciado el: " + split[0] + " a las " + split[1] + "horas";
	            		$('#training').text( display_name);
	            		window.training = training;
	            		create_list();

	        			setInterval(function(){
	        				create_list();
	        			}, 3000);
	            	}
	            },
			});
			$('#pop_up').jqxWindow({ maxHeight: 150, maxWidth: 280, minHeight: 30, minWidth: 250, height: 145, width: 270,
	            resizable: false, draggable: false, 
	            okButton: $('#ok'), 
	            initContent: function () {
	                $('#ok').jqxButton({  width: '65px' });
	                $('#ok').focus();
	            }
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
	          centerItems();
	          $(window).resize(function () {
	              centerItems();
	          });
	});
	function create_list(){
		training = window.training;
		$.ajax({
            url: "/mapps/getTrainingPulseData",
            type: "POST",
            data: {t:training.name},
            success: function (response){
            	var reports = response;
            	if(reports.length != 0){
                	create_label(reports);
            	}else{
            		 $('#list_athletes').text("No hay datos de los atletas aun");
            	}
            },
		});
	}
	
	function create_label(reports){
		var list = $("#list_athletes");
		list.html("");
		for (var index = 0; index< reports.length;index++){
			var data = reports[index];
            var athlete = data.athleteWrapper;
        	var bpm = data.lastPulse;
        	var kCal = get_double_as_String(data.kCal,3);
        	var training_zone = get_zone(data.trainingType);
        	var trainingClass = "data_index_alert_soft";
        	if(training_zone=="Suave"||training_zone=="Muy Suave"){
        		trainingClass="data_index_alert_soft";
        	}else if(training_zone=="Moderado"){
        		trainingClass="data_index_alert_moderated";
        	}else if(training_zone=="Muy Intenso"||training_zone=="Intenso"){
        		trainingClass="data_index_alert_intense";
        	}
        	var first_div = $('<div id="'+athlete.idDocument+'" class="athlete_index"></div>');
        	var div_up = $('<div id="img'+athlete.idDocument+'" style="float:left; height:100px; width:20%; display:inline-block; padding-top:10px; padding-bottom:10px;"><img src="'+athlete.imageURI+'" height="80px" /></div>'); 
        	var div_down = $('<div id="data '+athlete.idDocument+'"  style="float:left; height:100px; width:80%; display:inline-block; padding-top:10px; padding-bottom:10px;"><div style="width: 25%;height: 100%;float: left;display: inline-block" ><a href="./athletes/player_view_training.jsp?a='+athlete.idDocument+'&t='+data.trainingName+'"><div id="name'+athlete.idDocument+'" class="data_info_index_inicio" style="font-size:22px;">'+athlete.name+' '+athlete.lastName+'</div></a></div><div id="pulse '+athlete.idDocument+'" class="data_info_index_inicio" style="margin-top:15px;"><div style="height:40px; text-align:center;">Pulso:</div><div id="pulse_data'+athlete.idDocument+'" class="'+trainingClass+'">'+bpm+' BPM</div></div><div id="zone'+athlete.idDocument+'" class="data_info_index_inicio" style="margin-top:15px;"><div style="height:40px; text-align:center;">Zona de Entrenamiento:</div><div id="training_zone'+athlete.idDocument+' " class="'+trainingClass+'">'+training_zone+'</div></div><div id="calories'+athlete.idDocument+'" class="data_info_index_inicio" style="margin-top:15px;"><div style="height:40px; text-align:center;">Calorias Quemadas:</div><div id="calories_data '+athlete.idDocument+'" class="data_index">'+kCal+' KCal</div></div></div>');
        	first_div.append(div_up);
        	first_div.append(div_down);
        	list.append(first_div);
		}
	}
	
	function create_static_labels(){
		document.getElementById("list_athletes_left").style.display = 'block';
		document.getElementById("list_athletes_right").style.display = 'block';
		// document.getElementById("list_athletes").document.getElementsByTagName('a').style.color = '#4DC230';
	}
	
	function hide_static_labels(){
		document.getElementById("list_athletes_left").style.display = 'none';
		document.getElementById("list_athletes_right").style.display = 'none';
		// document.getElementById("list_athletes").document.getElementsByTagName('a').style.color = '#FFFFFF';
	}
	
	function get_double_as_String(doub, decimals){
		var val = new String(doub);
    	var split = val.split('.');
    	return split[0] + '.' + split[1].substr(0,decimals);
	}
	
	function get_zone(type){
		if (type == "VERYSOFT"){
			return "Muy Suave";
		}else if (type == "SOFT"){
			return "Suave";
		}else if (type == "MODERATED"){
			return "Moderado";
		}else if (type == "INTENSE"){
			return "Intenso";
		}else{
			return "Muy Intenso";
		}
	}
	
	function create_stop_training(training_name){
		var button = $('<input type="button" id="stop_training" name="stop_training" value="TERMINAR ENTRENAMIENTO" style="margin-left:30%;" />');
		$('#stop_training_div').html(button);
		$("#stop_training").jqxButton({ width: '300', height: '50', theme: 'metro'});
		$("#stop_training").on('click', function () { window.location.assign('/mapps/stopTraining?name='+training_name+'')}); 
	}
	
	

	
</script>

<div id="header">
	<div id="header_izq">
    	<a href="index.jsp"></href><img src="./images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central">
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
    <div id="header_der">
        <div id="logout" class="up_tab"><a href="./configuration/my_account.jsp">MI CUENTA</a></div>
		<%if(trainingStarted.equals("trainingStarted")){%>
		<div id="logout" class="up_tab"><a href="./index.jsp?logout=1" >CERRAR SESI&Oacute;N</a></div>
		<%}else{ %>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
    <%} %>
    </div>
</div>
<div id="contenedor">

    <div id='tabs' style="background-color:#4DC230; color:#FFF;text-align: center;">
                <ul>
                    <li style="width:18%; text-align:center; margin-left:11%; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;"><a href="./index.jsp">INICIO</a></li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">JUGADORES
                        <ul style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="./athletes/athletes.jsp">VER</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="./athletes/add_athletes.jsp">AGREGAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="./athletes/edit_athletes.jsp">EDITAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="./athletes/delete_athletes.jsp">ELIMINAR</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">ENTRENAMIENTOS
                        <ul style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="./training/training_reports.jsp">VER ANTERIORES</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="./training/trainings.jsp">COMENZAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="./training/create_training.jsp">PROGRAMAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="./training/edit_training.jsp">EDITAR</a></li>
                            <%}%>
             	   		<%if(role.equals(Role.ADMINISTRATOR)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="./training/change_permissions_training.jsp">EDITAR PERMISOS</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">CONFIGURACI&Oacute;N
                        <ul style="width:296px;">
                            <li style="text-align:center;font-size:16px;height:30px;">CUENTA
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/my_account.jsp">MI CUENTA</a></li>
                                </ul>
                            </li>
                            <%if(role.equals(Role.ADMINISTRATOR)){%>
                            <li style="text-align:center;font-size:16px;height:30px;">USUARIOS
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/register_user.jsp">AGREGAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/edit_user.jsp">EDITAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/delete_user.jsp">ELIMINAR</a></li>
                                </ul>
                            </li>
                            <li style="text-align:center;font-size:16px;height:30px;">INSTITUCIONES
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/add_institution.jsp">AGREGAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/edit_institution.jsp">EDITAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/delete_institution.jsp">ELIMINAR</a></li>
                                </ul>
                            </li>
                            <%}%>
                            <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;">DEPORTES
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/add_sport.jsp">AGREGAR</a></li>
                                </ul>
                            </li>
                            <li style="text-align:center;font-size:16px;height:30px;">DISPOSITIVOS
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/add_device.jsp">AGREGAR</a></li>
                                    <%if(role.equals(Role.ADMINISTRATOR)){%>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="./configuration/edit_device.jsp">EDITAR</a></li>
                                    <%}%>
                                </ul>
                            </li>
                            <%}%>
                        </ul>
                    </li>
                </ul>
            </div>
    <div id="area_de_trabajo" style="height:620px;">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="training" style="width:100%; height:25px; padding-top:15px;"> 
            
            </div>
            <div id="list_athletes" style="width:100%; height:450px; overflow:scroll; margin-top:30px; margin-bottom:30px;display: block;">
                <div id="list_athletes_left" style="display:none; width:70%; height:80%; float:left; display:inline-block; margin-top:60px;">
               		<div id="buttons_up">
	               	    <a href="./training/training_reports.jsp">
	               	    	<img id="button1" class="index_button" src="./images/boton1.png" width="200px;" />
	               	   	</a>
	               	    <a href="./training/create_training.jsp">
	               	    	<img id="button2" class="index_button" src="./images/boton1 3.png" width="200px;" />
	               	    </a>
	               	    <a href="./athletes/athletes.jsp">
	               	    	<img id="button3" class="index_button" src="./images/boton1 2.png" width="200px;" />
	               	    </a>
               		</div>
               		<div id="buttons_down">
               			<a href="./training/trainings.jsp">
               				<img id="button4" class="index_button" src="./images/boton 2.png" width="613px;" />
               			</a>
               		</div>
               	</div>
               	<div id="list_athletes_right"  style="display:none; width:30%; height:100%; float:left; display:block;">
               		<a class="twitter-timeline" href="https://twitter.com/MAPPSuy/feed-de-noticias" data-widget-id="434799977672372224">Tweets de https://twitter.com/MAPPSuy/feed-de-noticias</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>               		
               	</div>
            </div>
        	<div id="stop_training_div">
            
            </div>
        </div>
        <div id="sidebar_right">
        
        </div>
    </div>
 
</div>
<div id="pie">
<%} %>
</div>
</body>
</html>
