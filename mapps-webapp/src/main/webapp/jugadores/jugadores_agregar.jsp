<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
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
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    <!-- InstanceEndEditable -->
</head>

<body>
<!-- InstanceBeginEditable name="EditRegion4" -->
<script type="text/javascript">

	$(document).ready(function () {
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '120', mode: 'vertical'});
        $("#jqxMenu").css('visibility', 'visible');
		
	
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
	    <div id="tab_1" class="tab" onclick="location.href='index_template.jsp'" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab active" onclick="window.location.reload()">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='entrenamientos.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='miclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='configuracion.jsp'" style="margin-right:180px;">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<form action="" method="post" name="agregar_deportista" id="agregar_deportista">
           		<label> Rellene los siguientes formularios </label>
                <br />
                <br />
                <label> Nombre: <input type="text" name="name" id="name" required="required" /></label>
                <br />
                <br />
                <label> Apellido: <input type="text" name="lastName" id="lastName" required="required" /></label>
                <br />
                <br />
                <label> Peso: <input type="text" name="weight" id="weight" required="required" /></label>
                <br />
                <br />
                <label> Altura: <input type="text" name="height" id="height" required="required" /></label>
                <br />
                <br />
                <label> Fecha de Nacimiento: <input type="date" name="birth" id="birth" required="required" /></label>
                <br />
                <br />
                <label> Sexo: <select name="gender"><option value="male">M</option><option value="female">F</option></select></label>
                <br />
                <br />
                <label> Email: <input type="text" name="email" id="email" required="required" /></label>
                <br />
                <br />
                <label> Instituci&oacute;n <select name="institution">
                <& &>
                <option value="<% %>"><% %></option>
                                           </select>
                                       </label>
                <br />
                <br />
                <label> C.I.  <input type="text" name="idDocument" id="idDocument" required="required" /></label>
            </form>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li><a href="#"> Agregar </a></li>
             	   <li><a href="#"> Editar </a></li>
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
