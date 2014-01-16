<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/jugadores_template.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
	<!-- InstanceBeginEditable name="EditRegion5" -->
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
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    <!-- InstanceEndEditable -->
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
%>
<body>
<!-- InstanceBeginEditable name="EditRegion4" -->
<script type="text/javascript">
$(document).ready(function () {
	
	//getAllInstitutions
	var url = "/mapps/getAllInstitutions";
	$.ajax({
        url: url,
        type: "GET",
        success: function (response){
        	var names = response['name']
        	$("#institution").jqxDropDownList(
            		{
            			source: names,
            			selectedIndex: 0,
            			width: '200',
            			height: '25',
            			dropDownHeight: '100'
            			}
            		);
        	}
        });
	
	//Create a jqxMenu
    $("#jqxMenu").jqxMenu({ width: '150', mode: 'vertical'});
    $("#jqxMenu").css('visibility', 'visible');
	//name
	$("#name").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 1});
	//lastname
	$("#lastname").jqxInput({placeHolder: "Apellido", height: 25, width: 200, minLength: 1});
	//weight
	$("#weight").jqxMaskedInput({ width: 200, height: 25, mask: '###.##'});
	//height
	$("#height").jqxMaskedInput({ width: 200, height: 25, mask: '#.##'});
	//email
	$("#email").jqxInput({placeHolder: "Mail", height: 25, width: 200, minLength: 3});
	//Drop list
	$("#gender").jqxDropDownList({ source: ["Hombre", "Mujer", "Desconocido"], selectedIndex: 0, width: '200', height: '25', dropDownHeight: '100'});
	//Date
	$("#date").jqxDateTimeInput({width: '200px', height: '25px'});
	//document
	$("#document").jqxMaskedInput({ width: 200, height: 25, mask: '#.###.###-#'});
	//rol
	
	
	//addAthlete
	$("#addAthlete_button").jqxButton({ width: '150'});
	$("#addAthlete_button").on('click', function (){ 
        $('#addAthlete_form').jqxValidator('validate');
    });
	
	$("#addAthlete_form").jqxValidator({
        rules: [
                {
                    input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'
                },
                {
                    input: "#lastname", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'
                },
                { input: "#weight", message: "El peso del atleta es obligatorio!", action: 'keyup, blur', rule: 'required'},
                { input: "#height", message: "La altura del atleta es obligatoria!", action: 'keyup, blur', rule: 'required'},
                { input: "#email", message: "El email es obligatorio!", action: 'keyup, blur', rule: 'required'},
                { input: '#email', message: 'Invalid e-mail!', action: 'keyup,blur', rule: 'email'},
                { input: "#document", message: "El documento es obligatorio!", action: 'keyup, blur', rule: 'required'},
                {
                    input: "#gender", message: "El Género es obligatorio!", action: 'blur', rule: function (input, commit) {
                        var index = $("#gender").jqxDropDownList('getSelectedIndex');
                        return index != -1;
                    }
                },
                {
                	input: "#date", message: "La Fecha de Nacimiento es obligatoria!", action: 'keyup, blur', rule: 'required' 
                },
                {
                    input: "#institution", message: "La institución es obligatoria!", action: 'blur', rule: function (input, commit) {
                        var index = $("#institution").jqxDropDownList('getSelectedIndex');
                        return index != -1;
                    }
                }
        ],  hintType: "label"
    });
});

$('#addAthlete_form').on('validationSuccess', function (event) {
    $('#addAthlete_button').submit();
});
</script>
<!-- InstanceEndEditable -->

<div id="header">
	<div id="header_izq">
    
    </div>
    <div id="header_central">
	<!-- InstanceBeginEditable name="EditRegion1" -->
	
	<!-- InstanceEndEditable -->
    </div>
    <div id="header_der">
	
    </div>
</div>
<div id="contenedor">
<!-- InstanceBeginEditable name="EditRegion2" -->
    <div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab active" onclick="location.href='./athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration.jsp'" style="margin-right:180px;">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./athletes.jsp">JUGADORES</a> -> Agregar
            </div>
        	
        	<form action="/mapps/addAthlete" method="post" id="addAthlete_form">
                	<table width="200" border="0">
                          <tr>
                            <td>Nombre: </td>
                            <td><input name="name" id="name" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Apellido: </td>
                            <td><input name="lastName" id="lastname" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Fecha de Nacimiento:</td>
                            <td><div id='date'></div></td>
                          </tr>
                          <tr>
                            <td>Género: </td>
                            <td><div id='gender'></div></td>
                          </tr>
                          <tr>
                            <td>Mail: </td>
                            <td><input name="email" id="email" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Peso: </td>
                            <td><input name="weight"  id="weight" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Altura: </td>
                            <td><input name="height" id="height" type="text" requiered/></td>
                          </tr>
                          <tr>
                            <td>Documento: </td>
                            <td><input name="document" id="document" type="text" required /></td>
                          </tr>
                          <tr>
                            <td>Institución: </td>
                            <td><div id='institution'></div></td>
                          </tr>
                          
                            <td><center></center><input type="submit" value="Agregar Atleta" id="addAthlete_button" /></center></td>
                          </tr>
                        </table>
                </form>
                
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li><a href="#"> Agregar </a></li>
             	   <li><a href="edit_athletes.jsp"> Editar </a></li>
             	   <li><a href="#"> Eliminar </a></li>
        		</ul>
  			</div>
        </div>
    </div>
<!-- InstanceEndEditable -->    
</div>
<div id="pie">

</div>
</body>
<!-- InstanceEnd --></html>
