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
    <script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
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
            	var names = response['name'];
            	$("#institution").jqxDropDownList(
                		{
                			source: names,
                			selectedIndex: 0,
                			width: '200',
                			height: '25',
                			dropDownHeight: '75'
                			}
                		);
            	}
            });
			
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		//name
		$("#panId").jqxInput({placeHolder: "PAN ID", height: 25, width: 200, minLength: 1, theme: 'metro'});
		//lastname
		$("#dirLow").jqxInput({placeHolder: "DIR LOW", height: 25, width: 200, minLength: 1, theme: 'metro'});
	
		//register
		$("#validate").jqxButton({ width: '150', theme: 'metro'});
		$("#register_button").on('click', function (){ 
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
		});
	$('#device_form').on('validationSuccess', function (event) {
        $('#validate').submit();
    });
</script>

<div id="header">
	<div id="header_izq">
    
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
        <div id="tab_5" class="tab active" onclick="location.href='./configuration.jsp" style="margin-right:180px;">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">

        </div>	   
        <div id="main_div">
			<div id="navigation" class="navigation">
            	<a href="./athletes.jsp">JUGADORES</a> -> Agregar
            </div>
        	<form action="/mapps/addDevice" method="post" name="device_form" id="device_form">
            	<div id="title" style="margin:15px;">
           			<label> Rellene el siguiente formulario </label>
                </div>
                <div id="campos" class="campos" style="margin-left:100px;">
                	<div id="pan_id">
                    	<div class="tag_form"> PAN ID:  </div>
                    	<div class="input"><input type="text" name="panId" id="panId" required="required" /></div>
                    </div>
                    <div id="dir_low">
                        <div class="tag_form"> DIR LOW: </div>
                        <div class="input"><input type="text" name="dirLow" id="dirLow" required="required" /></div>
                    </div>
                    <div id="institucion" style="display: inline-block;">
                        <div class="tag_form"> Instituci&oacute;n </div>
                        <div id='institution' style="display: inline-block;"></div>
                    </div>
                    <div style="margin-left:200px; margin-top:20px;">
                    	<input type="submit" id="validate" value="CONFIRMAR"/>
                    </div>
				</div>
            </form>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="./register_user"> Agregar un Usuario </a></li>
             	   <li style="height:35px;"><a href="#"> Editar / Eliminar un Usuario </a></li>
             	   <li style="height:35px;"><a href="#"> Agregar un Deporte </a></li>
                   <li style="height:35px;"><a href="#"> Agregar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="#"> Editar / Eliminar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="#"> Agregar un Dispositivo </a></li>
        		</ul>
  			</div>
        </div>
    </div>
 
    
</div>
<div id="pie">

</div>
</body>
</html>
