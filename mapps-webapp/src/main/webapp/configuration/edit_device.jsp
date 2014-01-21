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
	
			
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$("#panId").jqxInput({placeHolder: "Device ID", height: 30, width: 200, minLength: 1, theme: 'metro' });
		$("#dirHigh").jqxInput({placeHolder: "DIR_HIGH", height: 30, width: 200, minLength: 1, disabled: 'true', theme: 'metro'  });
		$("#dirLow").jqxInput({placeHolder: "DIR_LOW", height: 30, width: 200, minLength: 1, theme: 'metro'  });
		
		$("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#validate").on('click', function (){ 
	        $('#edit_device').jqxValidator('validate');
	    });
		$("#edit_device").jqxValidator({
            rules: [
                    {input: "#panId", message: "El ID del dispositivo es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#dirHigh", message: "DIR_HIGH es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#dirLow", message: "DIR_LOW es obligatoria!", action: 'keyup, blur', rule: 'required'},
            ],  theme: 'metro'
	        });
		$('#edit_device').on('validationSuccess', function (event) {
	        $('#validate').submit();
	    });
		var url = "/mapps/getAllDevices";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				create_list(response);	            	
            },
        	   
		});
	});
	function create_list(response){
		var devices = response;
		$('#list_devices').on('select', function (event) {
            updatePanel(devices[event.args.index]);
        });
		$('#list_devices').jqxListBox({ selectedIndex: 0,  source: devices, displayMember: "name", valueMember: "name", itemHeight: 70, height: '100%', width: '300', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = devices[index];
               
                var table = '<table style="min-width: 130px;"><tr><td style="width: 40px;" rowspan="2">' + '</td><td>' + datarecord.dirLow + '</td></table>';
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
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:15px; margin-left:20px;" /></a>
    </div>
    <div id="header_central">
	
	</div>
    <div id="header_der">
	
    </div>
</div>
<div id="contenedor">

	<div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab active" onclick="location.href='./configuration.jsp">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">

        </div>	   
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./configuration.jsp">CONFIGURACI&Oacute;N</a> >> Editar un dispositivo
            </div>
	        <div id="main_div_left" style="float:left; width:50%; display:inline-block;">
            	<div id="title" style="margin:15px;">
                    <label> 1) Seleccione un dispositivo </label>
                </div>
        		<div id="list_devices">
                </div>
            </div>
            <div id="main_div_right" style="float:right; width:50%; display:inline-block;">
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
                    	<div style="margin-left:70px; margin-top:20px;">
                    		<input type="submit" id="validate" value="CONFIRMAR"/>
                   		</div>
                    </div>
                    <input type="hidden" id="id-hidden" name="id-hidden"></input>
                </form>
            </div>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="./register_user.jsp"> Agregar un Usuario </a></li>
             	   <li style="height:35px;"><a href="./edit_user.jsp"> Editar un Usuario </a></li>
                   <li style="height:35px;"><a href="./delete_user.jsp"> Eliminar un Usuario </a></li>
             	   <li style="height:35px;"><a href="./add_sport.jsp"> Agregar un Deporte </a></li>
                   <li style="height:35px;"><a href="./add_institution.jsp"> Agregar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="./edit_institution.jsp"> Editar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="./delete_institution.jsp"> Eliminar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="./add_device.jsp"> Agregar un Dispositivo </a></li>
                   <li style="height:35px;"><a href="#"> Editar un Dispositivo </a></li>
        		</ul>
  			</div>
        </div>
    </div>
 
    
</div>
<div id="pie">

</div>
</body>
</html>
