<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Untitled Document</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8" />
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type='text/javascript' src="../scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxvalidator.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css" /> 
    
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

boolean show_pop_up = false;
String pop_up_message = "";
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";
String error = String.valueOf(request.getParameter("error"));
if (error.equals("null"))
	error = "";

if(error.equals("1")){
	// El atleta ha sido ingresado con exito
	pop_up_message = "Error al modificar los datos del atleta. Contacte al administrador.";
	show_pop_up = true;	
}else if(error.equals("2")){
	// El atleta fue modificado con exito
	pop_up_message = "Error al modificar los datos del atleta. Usted no tiene los permisos necesarios. Contacte al administrador.";
	show_pop_up = true;	
}
%>
<body>

<script type="text/javascript">

	$(document).ready(function () {
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$("#document").jqxInput({placeHolder: "C.I", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$('#document').jqxInput({disabled: true });
		$("#date").jqxDateTimeInput({width: '50%', height: '30px', theme: 'metro'});
		$("#weight").jqxInput({placeHolder: "Peso (kg)", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$("#height").jqxInput({placeHolder: "Altura (cm)", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$("#email").jqxInput({placeHolder: "e.g: mapps@mapps.com", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$("#gender_list").jqxDropDownList({ source: ["Hombre", "Mujer", "Desconocido"], selectedIndex: 0, width: '50%', height: '30', dropDownHeight: '100', theme: 'metro'});
		$("#file").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 1, theme: 'metro'});
		$("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#validate").on('click', function (){ 
	        $('#edit_athlete').jqxValidator('validate');
	    });
		$("#edit_athlete").jqxValidator({
            rules: [
                    {input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#weight", message: "El peso es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#height", message: "La altura es obligatoria!", action: 'keyup, blur', rule: 'required'},
                    {input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: "#email", message: "El email es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: '#email', message: 'Invalid e-mail!', action: 'keyup,blur', rule: 'email'},
                    { input: "#document", message: "El documento es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#gender", message: "El Género es obligatorio!", action: 'blur', rule: function (input, commit) {
                        var index = $("#gender").jqxDropDownList('getSelectedIndex');
                        return index != -1;
                       }
                    },
            ],  theme: 'metro'
	        });
		$('#edit_athlete').on('validationSuccess', function (event) {
	        $('#edit_athlete').submit();
	    });
		//Get athletes
		var url = "/mapps/getAllAthletesOfInstitution";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				create_list(response);	            	
            }});
		
		$('#pop_up').jqxWindow({ maxHeight: 150, maxWidth: 280, minHeight: 30, minWidth: 250, height: 145, width: 270,
            resizable: false, draggable: false,
            okButton: $('#ok'), 
            initContent: function () {
                $('#ok').jqxButton({  width: '65px' });
                $('#ok').focus();
            }
        });	
			
		<%
		if(show_pop_up){	
		%>
			$("#pop_up").css('visibility', 'visible');
		<%
		}else{
		%>
			$("#pop_up").css('visibility', 'hidden');
			$("#pop_up").css('display', 'none');
		<%
		}
		%>
			
	});
	
	function create_list(response){
		var athletes = response['athletes'];
		$('#list_players').on('select', function (event) {
            updatePanel(athletes[event.args.index]);
        });
		$('#list_players').jqxListBox({ selectedIndex: 0,  source: athletes, displayMember: "firstname", valueMember: "notes", itemHeight: 70, height: '100%', width: '90%', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = athletes[index];
                //var imgurl = '../../images/' + label.toLowerCase() + '.png';
                var img = '<img height="50" width="50" src="' + datarecord.imageURI + '"/>';
                var table = '<table style="min-width: 130px;"><tr><td style="width: 40px;" rowspan="2">' + img + '</td><td>  ' + datarecord.name + " " + datarecord.lastName + '</td></table>';
                return table;
            }
        });
		updatePanel(athletes[0]);
	}
	
	function updatePanel(athlete){
		$('#name').jqxInput('val', athlete['name']);
		$('#lastName').jqxInput('val', athlete['lastName']);
		$('#document').jqxInput('val', athlete['idDocument']);
		$('#weight').jqxInput('val', athlete['weight']);
		$('#height').jqxInput('val', athlete['height']);
		$('#email').jqxInput('val', athlete['email']);
		var index = 2;
		if (athlete['gender'] == "FEMALE"){
			index = 1;
		}else if (athlete['gender'] == "MALE"){
			index = 0;
		}
		$("#gender_list").jqxDropDownList({selectedIndex: index });
		$("#document-hidden").val(athlete.idDocument);
		$("#date").jqxInput('val', athlete.birth);
	}
</script>

<style type="text/css">
#list img{
	width: 50px;
    height: 55px;
}

#list div{
	margin-top: -35px;
    margin-left: 80px;
}

.jqx-listmenu-item{
	padding: 0px;
    min-height: 57px;
}
</style>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		<div id="pop_up">
            <div>
                <img width="14" height="14" src="../images/delete.png" alt="" />
                Error
            </div>
            <div>
            	<div style="height:60px;">
                	<%=pop_up_message
					%>
                </div>
                <div>
            		<div style="float: right; margin-top: 15px; vertical-align:bottom;">
           		        <input type="button" id="ok" value="OK" style="margin-right: 10px" />
        	        </div>
                </div>
            </div>
        </div>
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab">MI CUENTA</div>
		<div id="logout" class="up_tab">CERRAR SESI&Oacute;N</div>
    </div>
</div>
<div id="contenedor">

    <div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:12%;">INICIO</div>
        <div id="tab_2" class="tab active" onclick="location.href='./athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        	
        </div>
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./athletes.jsp">JUGADORES</a> >> Editar
            </div>
            <div id="main_div_left" style="float:left; width:50%; display:inline-block;">
                <div id="title" style="margin:15px;">
                    <label> 1) Seleccione un jugador </label>
                </div>
                <div id="list_players">
                </div>
            </div>
            <div id="main_div_right" style="float:right; width:50%; display:inline-block;">
                <form action="/mapps/modifyAthlete" method="post" name="agregar_deportista" id="edit_athlete" enctype="multipart/form-data">
                    <div id="title" style="margin:15px;">
                        <label> 2) Modifique los datos que desee </label>
                    </div>
                    <div id="campos" style="margin-left:40px;">
                        <div id="nombre">
                            <div class="tag_form_editar"> Nombre:  </div>
                            <div class="input"><input type="text" name="name" id="name" /></div>
                        </div>
                        <div id="apellido">
                            <div class="tag_form_editar"> Apellido: </div>
                            <div class="input"><input type="text" name="lastName" id="lastName" /></div>
                        </div>
                        <div id="ci">
                            <div class="tag_form_editar"> C.I.: </div>
                            <div class="input"><input type="text" id="document" /></div>
                        </div>
                        <div id="birth">
                            <div class="tag_form_editar_list">Nacimiento: </div>
                            <div id="date" class="input list_box">
                            </div>
                        </div>
                        <div id="peso">
                            <div class="tag_form_editar"> Peso: </div>
                            <div class="input"><input type="text" name="weight" id="weight" /></div>
                        </div>
                        <div id="altura">
                            <div class="tag_form_editar"> Altura: </div>
                            <div class="input"><input type="text" name="height" id="height" /></div>
                        </div>
                        <div id='gender'>
                        	<div class="tag_form_editar_list"> Sexo: </div>
                            <div id="gender_list" class="list_box"></div>
                        </div>
                        <div id="e_mail">
                            <div class="tag_form_editar"> Email: </div>
                            <div class="input"><input type="text" name="email" id="email" /></div>
                        </div>
                        <div style="display:inline-block">
                    		<div class="tag_form"> Cambiar Imagen: </div>
                        	<div class="input" style="display:inline-block" ><input name="file"  id="file" type="file" /></div>
                    	</div>
                    	<div style="margin-left:25%; margin-top:20px;">
                    		<input type="button" id="validate" value="CONFIRMAR"/>
                   		</div>
                    </div>
                    <input type="hidden" id="document-hidden" name="document"></input>
                </form>
            </div>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="add_athletes.jsp"> Agregar </a></li>
             	   <li style="height:35px;"><a href="#"> Editar </a></li>
             	   <li style="height:35px;"><a href="delete_athletes.jsp"> Eliminar </a></li>
        		</ul>
  			</div>
        </div>
    </div>

</div>
<div id="pie">

</div>
</body>
</html>
