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
		//Get Institutions
		var url = "/mapps/getAllInstitutions";
		$.ajax({
			url: url,
			type: "GET",
			success: function (response){
				var names = response;
				$("#institution").jqxDropDownList(
						{
							source: names,
							displayMember: "name",
							selectedIndex: 0,
							width: '200',
							height: '25',
							dropDownHeight: '75',
							theme: 'metro'
							}
						);
				}
			});
			
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '55%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		//name
		$("#panId").jqxInput({placeHolder: "PAN ID", height: 25, width: 200, minLength: 1, theme: 'metro'});
		//lastname
		$("#dirLow").jqxInput({placeHolder: "DIR LOW", height: 25, width: 200, minLength: 1, theme: 'metro'});
	
		//register
		$("#validate").jqxButton({ width: '150', height: '35',theme: 'metro'});
		$("#validate").on('click', function (){ 
	        $('#device_form').jqxValidator('validate');
	    });
		$("#device_form").jqxValidator({
            rules: [
					{input: "#panId", message: "El PAN ID es obligatoria!", action: 'keyup, blur', rule: 'required'},
					{input: "#panId", message: "El PAN ID debe ser un número!", action: 'keyup, blur', rule: function(){
						var pan = $('#panId').jqxInput('val');
						return $.isNumeric(pan);
					}},
					{input: "#dirLow", message: "La dirección es obligatoria!", action: 'keyup, blur', rule: 'required'},
					{input: "#dirLow", message: "La Dirección debe ser de 8 caracteres!", action: 'keyup, blur', rule: 'length=8,8'},
					{input: "#institution", message: "La institución es obligatoria!", action: 'blur', rule: function (input, commit) {
                            var index = $("#institution").jqxDropDownList('getSelectedIndex');
                            return index != -1;
                        }
                    }
                    ]
			});
	$('#device_form').on('validationSuccess', function (event) {
        $('#device_form').submit();
    });
});
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
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:12%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab active" onclick="location.href='./configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
			<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
                	<%
					if(role.equals(Role.ADMINISTRATOR)){
					%>
	             	    <li style="height:35px;"> Usuarios..
                       		<ul>
                            	<li style="height:35px;"><a href="./register_user.jsp"> Agregar un Usuario </a></li>
	             	   			<li style="height:35px;"><a href="./edit_user.jsp"> Editar un Usuario </a></li>
	                   			<li style="height:35px;"><a href="./delete_user.jsp"> Eliminar un Usuario </a></li>
                            </ul>
                        </li>
                        <li style="height:35px;"> Instituciones..
	             	   		<ul>
                                <li style="height:35px;"><a href="./add_institution.jsp"> Agregar una Instituci&oacute;n </a></li>
                                <li style="height:35px;"><a href="./edit_institution.jsp"> Editar una Instituci&oacute;n </a></li>
                                <li style="height:35px;"><a href="./delete_institution.jsp"> Eliminar una Instituci&oacute;n </a></li>
                            </ul>
                        </li>
                        <li style="height:35px;"> Deportes..
                        	<ul>
                       			<li style="height:35px;"><a href="./add_sport.jsp"> Agregar un Deporte </a></li>
                            </ul>
                        </li>
                        <li style="height:35px;"> Dispositivos..
                        	<ul>
                                <li style="height:35px;"><a href=""> Agregar un Dispositivo </a></li>
                                <li style="height:35px;"><a href="./edit_device.jsp"> Editar un Dispositivo </a></li>
                            </ul>
                        </li>
                   <%
					}else if(role.equals(Role.TRAINER)){
                   %>
                   		<li style="height:35px;"><a href="./my_account.jsp"> Mi cuenta </a></li>
                   		<li style="height:35px;"><a href="./add_device.jsp"> Agregar un Dispositivo </a></li>
                   <%
					}else if(role.equals(Role.USER)){
                   %>
                   		<li style="height:35px;"><a href="./my_account.jsp"> Mi cuenta </a></li>
                   <%
					}
                   %>
        		</ul>
  			</div>
        </div>	   
        <div id="main_div">
			<div id="navigation" class="navigation">
            	<a href="./athletes.jsp">CONFIGURACI&Oacute;N</a> >> Agregar un dispositivo
            </div>
        	<form action="/mapps/addDevice" method="post" name="device_form" id="device_form">
            	<div id="title" style="margin:15px;">
           			<label> Rellene el siguiente formulario </label>
                </div>
                <div id="campos" class="campos" style="margin-left:100px;">
                	<div id="pan_id">
                    	<div class="tag_form"> PAN ID:  </div>
                    	<div class="input"><input type="text" name="panId" id="panId" /></div>
                    </div>
                    <div id="dir_low">
                        <div class="tag_form"> DIR LOW: </div>
                        <div class="input"><input type="text" name="dirLow" id="dirLow" /></div>
                    </div>
                    <div id="institucion">
                        <div class="tag_form_list"> Instituci&oacute;n </div>
                        <div id='institution' style="display: inline-block;"></div>
                    </div>
                    <div style="margin-left:25%; margin-top:20px;">
                    	<input type="button" id="validate" value="CONFIRMAR"/>
                    </div>
				</div>
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
