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
    <script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
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
%>
<body>

<script type="text/javascript">

	$(document).ready(function () {
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: 200, minLength: 1, theme: 'metro' });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: 200, minLength: 1, theme: 'metro'  });
		$("#document").jqxInput({placeHolder: "C.I", height: 30, width: 200, minLength: 1, theme: 'metro'  });
		$('#document').jqxInput({disabled: true });
		$("#date").jqxInput({placeHolder: "Fecha de Nacimiento", height: 30, width: 200, minLength: 1, theme: 'metro'  });
		$('#date').jqxInput({disabled: true });
		$("#weight").jqxInput({placeHolder: "Peso (kg)", height: 30, width: 200, minLength: 1, theme: 'metro'  });
		$("#height").jqxInput({placeHolder: "Altura (cm)", height: 30, width: 200, minLength: 1, theme: 'metro'  });
		$("#email").jqxInput({placeHolder: "e.g: mapps@mapps.com", height: 30, width: 200, minLength: 1, theme: 'metro'  });
		$("#gender_list").jqxDropDownList({ source: ["Hombre", "Mujer", "Desconocido"], selectedIndex: 0, width: '200', height: '30', dropDownHeight: '100', theme: 'metro'});
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
		});
	
	function create_list(response){
		var athletes = response['athletes'];
		$('#list_players').on('select', function (event) {
            updatePanel(athletes[event.args.index]);
        });
		$('#list_players').jqxListBox({ selectedIndex: 0,  source: athletes, displayMember: "firstname", valueMember: "notes", itemHeight: 70, height: '100%', width: '390', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = athletes[index];
                //var imgurl = '../../images/' + label.toLowerCase() + '.png';
                var img = '<img height="50" width="40" src="../images/logo.png"/>';
                var table = '<table style="min-width: 130px;"><tr><td style="width: 40px;" rowspan="2">' + img + '</td><td>' + datarecord.name + " " + datarecord.lastName + '</td></table>';
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
    
    


<div id="header">
	<div id="header_izq">
    	<img src="../images/logo_mapps.png" style="height:80px; margin-top:15px; margin-left:20px;" />
    </div>
    <div id="header_central">
	
    </div>
    <div id="header_der">
	
    </div>
</div>
<div id="contenedor">

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
                <form action="/mapps/modifyAthlete" method="post" name="agregar_deportista" id="edit_athlete">
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
                            <div class="tag_form_editar">Nacimiento: </div>
                            <div class="input"><input type="text" id="date" /></div>
                        </div>
                        <div id="peso">
                            <div class="tag_form_editar"> Peso: </div>
                            <div class="input"><input type="text" name="weight" id="weight" /></div>
                        </div>
                        <div id="altura">
                            <div class="tag_form_editar"> Altura: </div>
                            <div class="input"><input type="text" name="height" id="height" /></div>
                        </div>
                        <div id='gender' style="display:inline-block">
                        	<div class="tag_form_editar"> Sexo: </div>
                            <div id="gender_list" style="display:inline-block; margin-top:10px"></div>
                        </div>
                        <div id="e_mail">
                            <div class="tag_form_editar"> Email: </div>
                            <div class="input"><input type="text" name="email" id="email" /></div>
                        </div>
                    	<div style="margin-left:100px; margin-top:50px;">
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
