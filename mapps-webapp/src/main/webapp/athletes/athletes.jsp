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
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxsplitter.js"></script>
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
String pop_up_message = "";
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";
String error = String.valueOf(request.getParameter("error"));
if (error.equals("null"))
	error = "";

if(info.equals("1")){
	// El atleta ha sido ingresado con exito
	pop_up_message = "El atleta fue ingresado al sistema con éxito.";
	show_pop_up = true;	
}else if(info.equals("2")){
	// El atleta fue modificado con exito
	pop_up_message = "Los datos del atleta fueron modificados con éxito.";
	show_pop_up = true;	
}else if(info.equals("3")){
	// El atleta fue modificado con exito
	pop_up_message = "El atleta fue eliminado con éxito.";
	show_pop_up = true;	
}
%>
<body>


<script type="text/javascript">

	$(document).ready(function () {
		 set_tab_child_length();
        var url = "/mapps/getAllAthletesOfInstitution";
        $.ajax({
            url: url,
            type: "GET",
            success: function (response){
            	create_list(response);
            }});
			
			
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
		$("#tabs").jqxMenu({ width: '100%', height: '50px', theme:'metro'});
	    
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
	function create_list(response){
		var athletes = response['athletes'];
		$('#list_players').on('select', function (event) {
            updatePanel(athletes[event.args.index]);
        });
		$('#list_players').jqxListBox({ selectedIndex: 0,  source: athletes, displayMember: "firstname", valueMember: "notes", itemHeight: 90, height: '90%', width: '100%', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = athletes[index];
                //var imgurl = '../../images/' + label.toLowerCase() + '.png';
                var img = '<img height="55" width="55" src="' + datarecord.imageURI + '"/>';
                var table = '<table style="min-width: 130px;border-spacing: 20px;"><tr><td style="width: 55px;" rowspan="2">' + img + '</td><td style="font-size:24px">  ' + datarecord.name + " " + datarecord.lastName + '</td></table>';
                return table;
            }
        });
		updatePanel(athletes[0]);
	}
        var updatePanel = function (athlete) {
            var container = $('<div style="margin: 5px;"></div>')
            var datarecord = athlete;
            var name = '<div class="my_account_field"><div class="my_account_tag" >Nombre:</div><div class="my_account_data">'+ datarecord.name +'</div>';
            var lastname = '<div class="my_account_field"><div class="my_account_tag" >Apellido:</div><div class="my_account_data">'+ datarecord.lastName +'</div>';
            var birth = '<div class="my_account_field"><div class="my_account_tag" >Fecha de Nacimiento:</div><div class="my_account_data">'+ datarecord.birth +'</div>';
            var gender = '<div class="my_account_field"><div class="my_account_tag" >Género:</div><div class="my_account_data">'+ get_gender(datarecord.gender) +'</div>';
            $(container).append(name);
            $(container).append(lastname);
            $(container).append(birth);
            $(container).append(gender);
            var email = '<div class="my_account_field"><div class="my_account_tag" >E-Mail:</div><div class="my_account_data">'+ datarecord.email +'</div>';
            var weight = '<div class="my_account_field"><div class="my_account_tag" >Peso:</div><div class="my_account_data">'+ datarecord.weight +' kg.</div>';
            var height = '<div class="my_account_field"><div class="my_account_tag" >Altura:</div><div class="my_account_data">'+ datarecord.height +' m.</div>';
            var document = '<div class="my_account_field"><div class="my_account_tag" >C.I.:</div><div class="my_account_data">'+ datarecord.idDocument +'</div>';
            $(container).append(email);
            $(container).append(weight);
            $(container).append(height);
            $(container).append(document);
            $("#main_div_right").html(container.html());
            $('#main_div_left').height($('#main_div_right').height());
        }
	
	function get_gender(gender){
		var gender = "Desconocido";
		if (gender.localeCompare("MALE")){
			gender = "Hombre";
		}else if (gender.localeCompare("FEMALE")){
			gender = "Mujer";
		}
		return gender;
	}
</script>


<div id="header">
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central">
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
                    <li id="ref_tab" style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;">JUGADORES
                        <ul id="ul_0" style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/athletes.jsp">VER</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/add_athletes.jsp">AGREGAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/edit_athletes.jsp">EDITAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/delete_athletes.jsp">ELIMINAR</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">ENTRENAMIENTOS
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
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <%
					if(role.equals(Role.ADMINISTRATOR)||role.equals(Role.TRAINER)){
					%>
             	   <li style="height:35px;"><a href="add_athletes.jsp"> Agregar </a></li>
             	   <li style="height:35px;"><a href="edit_athletes.jsp"> Editar </a></li>
             	   <li style="height:35px;"><a href="delete_athletes.jsp"> Eliminar </a></li>
             	   <%} %>
        		</ul>
  			</div>
        </div>
        <div id="main_div">
       
        	<div id="title" style="margin:15px;">
           			<label> Todos mis jugadores </label>
            </div>
            <div id="main_div_left">
                <div id="title" style="margin:15px;">
                    <label> 1) Seleccione un jugador </label>
                </div>
                <div id="list_players">
                </div>
            </div>
            <div id="main_div_right">
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
