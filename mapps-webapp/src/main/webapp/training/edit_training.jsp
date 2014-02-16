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
%>
<body>

<script type="text/javascript">
$(document).ready(function () {

	// Create jqxNumberInput
	$("#date").jqxDateTimeInput({width: '50%', height: '25px', formatString: 'dd/MM/yyyy HH:mm',theme: 'metro'});

	$("#validate").jqxButton({ width: '50%', height: '35', theme: 'metro'});
	
	$("#edit_training").jqxValidator({
        rules: [
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
	    centerItems();
	    $(window).resize(function () {
	        centerItems();
	    });
});

	function create_list(response){
		var trainings = response;
		$('#list_trainings').on('select', function (event) {
            updatePanel(trainings[event.args.index]);
        });
		
		$('#list_trainings').jqxListBox({ selectedIndex: 0,  source: trainings, displayMember: trainings.date, valueMember: "name", itemHeight: 28, height: '100%', width: '75%', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = trainings[index];
                var split = datarecord.date.split(" ");
                var display_name = "Entrenamiento iniciado el: " + split[0] + " a las " + split[1] + "horas";
                var table = '<table style="min-width: 130px;"><td>' + display_name + '</td></table>';
                return table;
            }
        });
		updatePanel(trainings[0]);
	}
	function updatePanel(trainings){
		var date=trainings['date'];
		$('#date').jqxDateTimeInput('val', date);
		$('#sport').jqxDropDownList('val', trainings['sport'].name);
		$('#name-hidden').val(trainings.name);
		
		
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
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">JUGADORES
                        <ul style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/athletes.jsp">VER</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/add_athletes.jsp">AGREGAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/edit_athletes.jsp">EDITAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/delete_athletes.jsp">ELIMINAR</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;">ENTRENAMIENTOS
                        <ul style="width:296px;">
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
                        <ul style="width:296px;">
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
    <div id="area_de_trabajo" style="height:550px;">
		<div id="sidebar_left">
			
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
<%}%>
</div>
</body>
</html>
