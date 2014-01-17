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
	
			
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		//name
		$("#name").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 1, theme: 'metro', disabled: true });
		//country
		$("#country").jqxInput({height: 25, width: 200, minLength: 1, theme: 'metro' });
	
		//register
		$("#validate").jqxButton({ width: '150', height: '35', theme: 'metro'});
	
	
	
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
            	<a href="./configuration.jsp">CONFIGURACI&Oacute;N</a> >> Editar una Institución
            </div>
	        <div id="main_div_left" style="float:left; width:50%; display:inline-block;">
            	<div id="title" style="margin:15px;">
                    <label> 1) Seleccione una instituci&oacute;n </label>
                </div>
        		<div id="list_institutions">
                </div>
            </div>
            <div id="main_div_right" style="float:right; width:50%; display:inline-block;">
                <form action="/mapps/..." method="post" name="edit_institution" id="edit_institution">
                    <div id="title" style="margin:15px;">
                        <label> 2) Modifique los datos que desee </label>
                    </div>
                    <div id="campos" style="margin-left:40px;">
                        <div id="nombre">
                        <div class="tag_form_editar"> Nombre:  </div>
                        <div class="input"><input type="text" name="name" id="name" required="required" /></div>
                        </div>
                        <div id="Descripcion">
                            <div class="tag_form_editar" style="vertical-align:top;"> Descripción: </div>
                            <div class="input"><textarea class="jqx-input jqx-rc-all jqx-input-metro jqx-widget-content-metro jqx-rc-all-metro" style="width:200px; height:200px;" type="text" name="description" id="description" required="required" ></textarea></div>
                        </div>
                        <div>
                            <div class="tag_form_editar"> País: </div>
                            <div class="input"><input name="country"  id="country" type="text" required /></div>
                        </div>
                    	<div style="margin-left:70px; margin-top:20px;">
                    		<input type="submit" id="validate" value="CONFIRMAR"/>
                   		</div>
                    </div>
                    <input type="hidden" id="document-hidden" name="document"></input>
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
                   <li style="height:35px;"><a href="#"> Editar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="./delete_institution.jsp"> Eliminar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="./add_device.jsp"> Agregar un Dispositivo </a></li>
        		</ul>
  			</div>
        </div>
    </div>
 
    
</div>
<div id="pie">

</div>
</body>
</html>
