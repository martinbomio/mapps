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
    <script type='text/javascript' src="../scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
	<script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../scripts/demos.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxnumberinput.js"></script>
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
	//Get athletes

	$("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
    $("#jqxMenu").css('visibility', 'visible');
    $("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});

    $("#validate").click(function (){ 
        $('#change_permission').submit();
    });
	
    
    
    var url = "/mapps/getAllEditableTrainings";		
	$.ajax({
        url: url,
        type: "GET",
        success: function (response){
        	var trainings = response;
        	$('#trainings').on('select', function (event) {
                updatePanel(trainings[event.args.index]);
            });
        	$("#trainings").jqxDropDownList({ source: trainings, selectedIndex: 0, width: '220', height: '25',displayMember: "date", valueMember: "name", dropDownHeight: '80', theme: 'metro'});
     		
        	updatePanel(trainings[0]);
        
        },
    	   
	});
    
   
});
function updatePanel(trainings){
	var users = trainings.users;
	for (var i=0; i<users.length; i++){
		var container = $("<div></div>");
		var div = $('<div> '+ users[i].userName +'</div>');
		var input = $('<div id="permission_list'+i+'" class="list_box"></div>');
		var hiddenUsername = $('<input type="hidden" id="username-hidden'+i+'" name="username-hidden'+i+'" value="'+users[i].userName +'"></input>');
		
		$(container).append(div);
		$(container).append(input);
		$(container).append(hiddenUsername);
		$("#users_div").append(container.html());
		var permissions = trainings.permissions; 
			if (permissions[i] == "READ"){
				var index = 1;
			}else{
				var index = 0;
			}
		$('#permission_list'+i+'').jqxDropDownList({ source: ['Crear', 'Ver'], selectedIndex: index, width: '220', height: '25', dropDownHeight: '80', theme: 'metro'});
	}
	$('#numberOfUsers').val(users.length);
	$('#name-hidden').val(trainings.name);
	
}

	
	
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
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab active" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration.jsp'">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo" style="height:550px;">
		<div id="sidebar_left">

        </div>	   
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./training.jsp">ENTRENAMIENTOS</a> >> Editar un entrenamiento
            </div>
	        
	         <div id='trainings_div' style="display:inline-block">
                       	<div class="tag_form" style="vertical-align:top; margin-top:15px;"> Entrenamientos: </div>
                        <div class="input" style="margin-top:10px;">
                        	<div id="trainings" style="display:inline-block; margin-top:10px"></div>
                        </div>
             </div>
             <form action="/mapps/changePermission" method="post" name="change_permission" id="change_permission">
	             <div id="users_div" >
	             </div>
	             <input type="hidden" id="numberOfUsers" name="numberOfUsers"></input>
	             <input type="hidden" id="name-hidden" name="name-hidden"></input>
	             <div style="margin-left:25%; margin-top:20px;">
                    	<input type="button" id="validate" value="CONFIRMAR"/>
                    </div>
             </form>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	    <li style="height:35px;"><a href="#"> Ver entrenamientos anteriores </a></li>
             	   <li style="height:35px;"><a href="./create_training.jsp"> Programar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./edit_training.jsp"> Editar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./change_permissions_training.jsp"> Editar Permisos </a></li>
             	   <li style="height:35px;"><a href="#">  </a></li>
        		</ul>
  			</div>
        </div>
    </div>
 
    
</div>
<div id="pie">

</div>
</body>
</html>