<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
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
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
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

String info = String.valueOf(request.getAttribute("info"));
if (info.equals("null"))
	info = "";
String error = String.valueOf(request.getAttribute("error"));
if (error.equals("null"))
	error = "";
%>
<body>

<script type="text/javascript">

	$(document).ready(function () {
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: 220, minLength: 1, theme: 'metro'  });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: 220, minLength: 1, theme: 'metro'  });
		$("#weight").jqxInput({placeHolder: "Peso (kg)", height: 30, width: 220, minLength: 1, theme: 'metro'  });
		$("#height").jqxInput({placeHolder: "Altura (cm)", height: 30, width: 220, minLength: 1, theme: 'metro'  });
		$("#email").jqxInput({placeHolder: "jose@gmail.com", height: 30, width: 220, minLength: 1, theme: 'metro'  });
		$("#document").jqxInput({placeHolder: "1234567-8", height: 30, width: 220, minLength: 1, theme: 'metro'  });
		
		$("#addAthlete_button").jqxButton({ width: '150', height: '35', theme: 'metro'});
	
	//getAllInstitutions
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
            			dropDownHeight: '100',
						theme: 'metro'
            			}
            		);
        	}
        });
	
		$("#addAthlete_form").jqxValidator({
			rules: [
					{
						input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'
					},
					{
						input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'
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
						input: "#institution", message: "La institución es obligatoria!", action: 'blur', rule: function (input, commit) {
							var index = $("#institution").jqxDropDownList('getSelectedIndex');
							return index != -1;
						}
					}
			], theme: 'metro'
    	});
	

		$('#addAthlete_form').on('validationSuccess', function (event) {
    		$('#addAthlete_form').submit();
		});
		
	
	
	$("#addAthlete_form").jqxValidator({
        rules: [
                {
                    input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'
                },
                {
                    input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'
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
                    input: "#institution", message: "La institución es obligatoria!", action: 'blur', rule: function (input, commit) {
                        var index = $("#institution").jqxDropDownList('getSelectedIndex');
                        return index != -1;
                    }
                }
        ], theme: 'metro'
    });

	$('#addAthlete_form').on('validationSuccess', function (event) {
    	$('#addAthlete_form').submit();
	});
});
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
        <div id="tab_2" class="tab active" onclick="location.href='./athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration.jsp'">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./athletes.jsp">JUGADORES</a> >> Agregar
            </div>
            <div id="title" style="margin:15px;">
                <label> Complete el siguiente formulario </label>
            </div>     	
            <div style="margin-left:100px;">
        		<form action="/mapps/addAthletes" method="post" id="addAthlete_form">
                	<div id="nombre">
                        <div class="tag_form"> Nombre:  </div>
                        <div class="input"><input type="text" name="name" id="name"  /></div>
                    </div>
                    <div id="apellido">
                        <div class="tag_form"> Apellido: </div>
                        <div class="input"><input type="text" name="lastName" id="lastName" /></div>
                    </div>
                    <div id="birth">
                        <div class="tag_form">Nacimiento: </div>
                        <div id="date" class="input">
                        </div>
                    </div>
                    <div id='gender_field' style="display:inline-block">
                      	<div class="tag_form"> Sexo: </div>
                        <div id="gender" style="display:inline-block; margin-top:10px"></div>
                    </div>
                    <div id="e_mail">
                        <div class="tag_form"> Email: </div>
                        <div class="input"><input type="text" name="email" id="email"  /></div>
                    </div>
                    <div id="peso">
                        <div class="tag_form"> Peso: </div>
                        <div class="input"><input type="text" name="weight" id="weight"  /></div>
                    </div>
                    <div id="altura">
                        <div class="tag_form"> Altura: </div>
                        <div class="input"><input type="text" name="height" id="height"  /></div>
                    </div>
                    <div id="ci">
                        <div class="tag_form"> C.I.: </div>
                        <div class="input"><input type="text" id="document" /></div>
                    </div>
                    <div id="institution_field">
                        <div class="tag_form"> Instituci&oacute;n: </div>
                        <div id="institution" class="input">
                        </div>
                    </div>
                   	<div style="margin-left:80px; margin-top:10px;">
                    	<input type="button" id="addAthlete_button" value="CONFIRMAR"/>
                 	</div>
                </form>  
        	</div>        
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="#"> Agregar </a></li>
             	   <li style="height:35px;"><a href="edit_athletes.jsp"> Editar </a></li>
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
