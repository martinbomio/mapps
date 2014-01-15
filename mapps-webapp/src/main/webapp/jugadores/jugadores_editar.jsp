<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/jugadores_template.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
	<!-- InstanceBeginEditable name="EditRegion5" --><title>Untitled Document</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8" />
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css" /> 
    <!-- InstanceEndEditable -->
</head>

<body>
<!-- InstanceBeginEditable name="EditRegion4" -->
<script type="text/javascript">

	$(document).ready(function () {
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '120', mode: 'vertical'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$('#list').jqxListMenu({autoSeparators: true, enableScrolling: false, showHeader: false, width: '370px', placeHolder: 'Seleccione un jugador' });
		$("#list_players").jqxPanel({ width: 390, height: 380});
		
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: 200, minLength: 1  });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: 200, minLength: 1  });
		$("#weight").jqxInput({placeHolder: "Peso (kg)", height: 30, width: 200, minLength: 1  });
		$("#height").jqxInput({placeHolder: "Altura (cm)", height: 30, width: 200, minLength: 1  });
		$("#email").jqxInput({placeHolder: "jose@gmail.com", height: 30, width: 200, minLength: 1  });
		
		$("#validate").jqxButton({ width: '150'});
		
	
   	});
</script>

    <style type="text/css">
        #list img
        {
            width: 50px;
            height: 55px;
        }
        #list div
        {
            margin-top: -35px;
            margin-left: 80px;
        }
        .jqx-listmenu-item
        {
            padding: 0px;
            min-height: 57px;
        }
    </style>
    
    
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
	    <div id="tab_1" class="tab" onclick="location.href='../index_template.jsp'" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab active" onclick="../jugadores/jugadores.jsp">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../entrenamientos/entrenamientos.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../miclub/miclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuracion/configuracion.jsp'" style="margin-right:180px;">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="jugadores.jsp">JUGADORES</a> -> Editar
            </div>
            <div id="main_div_left" style="float:left; width:50%; display:inline-block;">
                <div id="title" style="margin:15px;">
                    <label> 1) Seleccione un jugador </label>
                </div>
                <div id="list_players">
                    <ul id="list" data-role="listmenu">
                        <li>
                            <img src="../../images/andrew.png" alt="" /><div>
                                Andrew Fuller</div>
                            
                        </li>
                        <li>
                            <img src="../../images/anne.png" alt="" /><div>
                                Anne Dodsworth</div>
                            
                        </li>
                        <li>
                            <img src="../../images/janet.png" alt="" /><div>
                                Janet Leverling</div>
                            
                        </li>
                        <li>
                            <img src="../../images/laura.png" alt="" /><div>
                                Laura Callahan</div>
                            
                        </li>
                        <li>
                            <img src="../../images/margaret.png" alt="" /><div>
                                Margaret Peacock</div>
                            
                        </li>
                        <li>
                            <img src="../../images/michael.png" alt="" /><div>
                                Michael Suyama</div>
                            
                        </li>
                        <li>
                            <img src="../../images/nancy.png" alt="" /><div>
                                Nancy Divolio</div>
                            
                        </li>
                        <li>
                            <img src="../../images/robert.png" alt="" /><div>
                                Robert King</div>
                            
                        </li>
                        <li>
                            <img src="../../images/steven.png" alt="" /><div>
                                Steven Buchanan</div>
                            
                        </li>
                    </ul>
                </div>
            </div>
            <div id="main_div_right" style="float:right; width:50%; display:inline-block;">
                <form action="" method="post" name="agregar_deportista" id="agregar_deportista">
                    <div id="title" style="margin:15px;">
                        <label> 2) Modifique los datos que desee </label>
                    </div>
                    <div id="campos" style="margin-left:40px;">
                        <div id="nombre">
                            <div class="tag_form_editar"> Nombre:  </div>
                            <div class="input"><input type="text" name="name" id="name" required="required" /></div>
                        </div>
                        <div id="apellido">
                            <div class="tag_form_editar"> Apellido: </div>
                            <div class="input"><input type="text" name="lastName" id="lastName" required="required" /></div>
                        </div>
                        <div id="peso">
                            <div class="tag_form_editar"> Peso: </div>
                            <div class="input"><input type="text" name="weight" id="weight" required="required" /></div>
                        </div>
                        <div id="altura">
                            <div class="tag_form_editar"> Altura: </div>
                            <div class="input"><input type="text" name="height" id="height" required="required" /></div>
                        </div>
                        <div id="sexo">
                            <div class="tag_form_editar"> Sexo: </div>
                            <div class="input">
                                <select name="gender">
                                    <option value="male">M</option>
                                    <option value="female">F</option>
                                </select>
                            </div>
                        </div>
                        <div id="e_mail">
                            <div class="tag_form_editar"> Email: </div>
                            <div class="input"><input type="text" name="email" id="email" required="required" /></div>
                        </div>
                        <div id="institucion">
                            <div class="tag_form_editar"> Instituci&oacute;n </div>
                            <div class="input">
                                <select name="institution">
                                <& 
                                &>
                                    <option value="<% %>"><% %></option>
                                </select>
                            </div>
                        </div>
                    	<div style="margin-left:100px; margin-top:50px;">
                    		<input type="button" id="validate" value="CONFIRMAR"/>
                   		</div>
                    </div>
                </form>
            </div>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li><a href="jugadores_agregar.jsp"> Agregar </a></li>
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
