<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<%@ page import="com.mapps.model.Gender" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="shortcut icon" href="../favicon.ico" />
	<title>Mapps</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <script type='text/javascript' src="../scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
	<script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../scripts/demos.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
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
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		set_tab_child_length();
		
		$("#panId").jqxInput({placeHolder: "PAN ID", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#dirHigh").jqxInput({placeHolder: "DIR_HIGH", height: 30, width: '100%', minLength: 1, disabled: 'true', theme: 'metro'  });
		$("#dirLow").jqxInput({placeHolder: "DIR_LOW", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		
		$("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		
		$("#edit_device").jqxValidator({
            rules: [
                    {input: "#panId", message: "El ID del dispositivo es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#panId", message: "El PAN ID debe ser un número!", action: 'keyup, blur', rule: function(){
						var pan = $('#panId').jqxInput('val');
						return $.isNumeric(pan);
					}},
                    {input: "#dirHigh", message: "DIR_HIGH es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#dirLow", message: "DIR_LOW es obligatoria!", action: 'keyup, blur', rule: 'required'},
            ],  theme: 'metro'
	        });
		$("#validate").on('click', function (){ 
	        $('#edit_device').jqxValidator('validate');
	    });
		
		$('#edit_device').on('validationSuccess', function (event) {
	        $('#edit_device').submit();
	    });
		var url = "/mapps/getAllDevices";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				create_list(response);	            	
            },
        	   
		});
		var min_height = $('#main_div_right').height();
        $('#main_div_left').css("min-height", min_height);
		
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
	function create_list(response){
		var devices = response;
		$('#list_devices').on('select', function (event) {
            updatePanel(devices[event.args.index]);
        });
		$('#list_devices').jqxListBox({ selectedIndex: 0, autoHeight:true,  source: devices, displayMember: "name", valueMember: "name", itemHeight: 65, height: '80%', width: '100%', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = devices[index];
               
                var table = '<table style="min-width: 130px;border-spacing: 10px;"><td style="font-size:24px">' + datarecord.dirLow + '</td></table>';
                return table;
            }
        });
		updatePanel(devices[0]);
	}
	function updatePanel(devices){
		$('#panId').jqxInput('val', devices['panId']);
		$('#dirHigh').jqxInput('val', devices['dirHigh']);
		$('#dirLow').jqxInput('val', devices['dirLow']);
		$('#id-hidden').val(devices.id);
	}
</script>

<div id="header">
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central">
		
    </div>
    <div id="header_der">
        <div id="logout" class="up_tab"><a href="./my_account.jsp">MI CUENTA</a></div>
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
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;">CONFIGURACI&Oacute;N
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
			
        </div>	
        <div id="main_div">
	        <div id="navigation" class="navigation">
	            	<a href="configuration_main.jsp">CONFIGURACI&Oacute;N</a> >> Editar un dispositivo
	        </div>   
	        <div id="main_div_left">
            	<div id="title" style="margin:15px;">
                    <label> 1) Seleccione un dispositivo </label>
                </div>
        		<div id="list_devices">
                </div>
            </div>
            <div id="main_div_right">
                <form action="/mapps/modifyDevice" method="post" name="edit_device" id="edit_device">
                    <div id="title" style="margin:15px;">
                        <label> 2) Modifique los datos que desee </label>
                    </div>
                    <div id="campos" style="margin-left:40px;">
                        <div>
                            <div class="tag_form_editar"> PAN ID:  </div>
                            <div class="input"><input type="text" name="panId" id="panId" /></div>
                        </div>
                        <div>
                            <div class="tag_form_editar"> DIR HIGH: </div>
                            <div class="input"><input type="text" name="dirHigh" id="dirHigh" /></div>
                        </div>
                        <div>
                            <div class="tag_form_editar"> DIR LOW: </div>
                            <div class="input"><input type="text" id="dirLow" name="dirLow" /></div>
                        </div>
                    	<div style="margin-top:20px;">
                    		<center><input type="button" id="validate" value="CONFIRMAR"/></center>
                   		</div>
                    </div>
                    <input type="hidden" id="id-hidden" name="id-hidden"></input>
                </form>
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
