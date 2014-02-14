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
    <script type="text/javascript" src="../jqwidgets/jqxnumberinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxvalidator.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	response.sendRedirect("../index_login.jsp");	
}else{
	
String trainingStarted = String.valueOf(session.getAttribute("trainingStarted"));
if (trainingStarted.equals("null"))
trainingStarted = "";

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
        $("#jqxMenu").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: '80%', minLength: 1, theme: 'metro'  });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: '80%', minLength: 1, theme: 'metro'  });
		$("#weight").jqxInput({placeHolder: "Peso (kg)", height: 30, width: '80%', minLength: 1, theme: 'metro'  });
		$("#height").jqxMaskedInput({ height: 30, width: '80%', mask: '#.##', theme: 'metro'  });
		$("#email").jqxInput({placeHolder: "jose@gmail.com", height: 30, width: '80%', minLength: 1, theme: 'metro'  });
		$("#document").jqxMaskedInput({height: 30, width: '80%', mask: '#.###.###-#', theme: 'metro'  });
		
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
							valueMember:"name",
							selectedIndex: 0,
							width: '40%',
							height: '30',
							dropDownHeight: '100',
							theme: 'metro'
							}
						);
				}
			});

		//Drop list
		$("#gender").jqxDropDownList({ source: ["Hombre", "Mujer", "Desconocido"], selectedIndex: 2, width: '40%', height: '25', dropDownHeight: '100', theme: 'metro'});
		//Date
		$("#date").jqxDateTimeInput({width: '40%', height: '30px', theme: 'metro'});
	
		
		//addAthlete
		$("#addAthlete_button").jqxButton({ width: '200', height: 35});
		$("#addAthlete_button").on('click', function (){ 
			$('#addAthlete_form').jqxValidator('validate');
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
					{ input: "#weight", message: "El debe ser un numero del 0-999!", action: 'keyup, blur', rule: function(){
						var value = $("#weight").val();
						return ($.isNumeric(value) && value>=0 && value<=999);
					}},
					{ input: "#height", message: "La altura del atleta es obligatoria!", action: 'keyup, blur', rule: 'required'},
					{ input: "#height", message: "La altura debe ser un numero!", action: 'keyup, blur', rule: function(){
						var value = $("#height").val();
						return $.isNumeric(value);
					}},
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
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab"><a href="../configuration/my_account.jsp">MI CUENTA</a></div>
        <%if(trainingStarted.equals("trainingStarted")){%>
		<div id="logout" class="up_tab"><a href="../index.jsp?logout=1" >CERRAR SESI&Oacute;N</a></div>
		<%}else{ %>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
		<%} %>
		
    </div>
</div>
<div id="contenedor">

    <div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:12%;">INICIO</div>
        <div id="tab_2" class="tab active" onclick="location.href='./athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="#"> Agregar </a></li>
             	   <li style="height:35px;"><a href="edit_athletes.jsp"> Editar </a></li>
             	   <li style="height:35px;"><a href="delete_athletes.jsp"> Eliminar </a></li>
        		</ul>
  			</div>
        </div>
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./athletes.jsp">JUGADORES</a> >> Agregar
            </div>
            <div id="add_div">
            <div id="title" style="margin:15px;">
                <label> Complete el siguiente formulario </label>
            </div>     	
            <div style="margin-left:15%; margin-right:15%;">
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
                        <div class="tag_form_list">Nacimiento: </div>
                        <div id="date" class="input list_box">
                        </div>
                    </div>
                    <div id='gender_field'>
                      	<div class="tag_form_list"> Sexo: </div>
                        <div id="gender" class="input list_box"></div>
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
                   	<div style=" margin-top:10px;">
                    	<center><input type="button" id="addAthlete_button" value="CONFIRMAR"/></center>
                 	</div>
                </form>  
                </div>
        	</div>        
        </div>
        <div id="sidebar_right">
        	
        </div>
    </div>
</div>
<div id="pie">
</div>
<%} %>
</body>
</html>
