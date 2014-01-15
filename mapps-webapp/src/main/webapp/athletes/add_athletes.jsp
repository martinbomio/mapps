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
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    <!-- InstanceEndEditable -->
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	request.getRequestDispatcher("index_login.jsp");	
}
Role role;
if ( session.getAttribute("role") == null){
	role = null;	
}else{
	role = (Role) session.getAttribute("role");	
}
%>
<body>
<!-- InstanceBeginEditable name="EditRegion4" -->
<script type="text/javascript">

	$(document).ready(function () {
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '120', mode: 'vertical'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: 220, minLength: 1  });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: 220, minLength: 1  });
		$("#weight").jqxInput({placeHolder: "Peso (kg)", height: 30, width: 220, minLength: 1  });
		$("#height").jqxInput({placeHolder: "Altura (cm)", height: 30, width: 220, minLength: 1  });
		$("#email").jqxInput({placeHolder: "jose@gmail.com", height: 30, width: 220, minLength: 1  });
		$("#idDocument").jqxInput({placeHolder: "1234567-8", height: 30, width: 220, minLength: 1  });
		
		$("#validate").jqxButton({ width: '150'});
	
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
	    <div id="tab_1" class="tab" onclick="location.href='index.jsp'" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab active" onclick="window.location.reload()">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='entrenamientos.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='miclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='configuracion.jsp'" style="margin-right:180px;">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="jugadores.jsp">JUGADORES</a> -> Agregar
            </div>
        	<form action="" method="post" name="agregar_deportista" id="agregar_deportista">
            	<div id="title" style="margin:15px;">
           			<label> Rellene el siguiente formulario </label>
                </div>
                <div id="campos" class="campos" style="margin-left:100px;">
                	<div id="nombre">
                    	<div class="tag_form"> Nombre:  </div>
                    	<div class="input"><input type="text" name="name" id="name" required="required" /></div>
                    </div>
                    <div id="apellido">
                        <div class="tag_form"> Apellido: </div>
                        <div class="input"><input type="text" name="lastName" id="lastName" required="required" /></div>
                    </div>
                    <div id="fch_nac">
                        <div class="tag_form"> Fecha de Nacimiento: </div>
                        <div class="input"><input type="date" name="birth" id="birth" required="required" style="width:220px; height:25px;" /></div>
                    </div>
                    <div id="peso">
                        <div class="tag_form"> Peso: </div>
                        <div class="input"><input type="text" name="weight" id="weight" required="required" /></div>
                    </div>
                    <div id="altura">
                        <div class="tag_form"> Altura: </div>
                        <div class="input"><input type="text" name="height" id="height" required="required" /></div>
                    </div>
                    <div id="sexo">
                        <div class="tag_form"> Sexo: </div>
                        <div class="input">
                            <select name="gender">
                                <option value="male">M</option>
                                <option value="female">F</option>
                            </select>
                        </div>
                    </div>
                    <div id="e_mail">
                        <div class="tag_form"> Email: </div>
                        <div class="input"><input type="text" name="email" id="email" required="required" /></div>
                    </div>
                    <div id="institucion">
                        <div class="tag_form"> Instituci&oacute;n </div>
                        <div class="input">
                            <select name="institution">
                            <& 
                            &>
                                <option value="<% %>"><% %></option>
                            </select>
                        </div>
                    </div>
                    <div id="ci">
                        <div class="tag_form"> C.I.  </div>
                        <div class="input"><input type="text" name="idDocument" id="idDocument" required="required" /></div>
                    </div>
                    <div style="margin-left:200px; margin-top:20px;">
                    	<input type="button" id="validate" value="CONFIRMAR"/>
                    </div>
				</div>
            </form>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li><a href="#"> Agregar </a></li>
             	   <li><a href="jugadores_editar.jsp"> Editar </a></li>
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
