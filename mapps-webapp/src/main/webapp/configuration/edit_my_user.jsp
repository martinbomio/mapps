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
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
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
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
					
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '55%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		
		$("#name").jqxInput({placeHolder: "Pepe", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#email").jqxInput({placeHolder: "pepe@gmail", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		
		
		$("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#validate").on('click', function (){ 
	        $('#edit_user').jqxValidator('validate');
	    });
		
		$("#edit_user").jqxValidator({
            rules: [
                    {input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: "#email", message: "El email es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: '#email', message: 'Invalid e-mail!', action: 'keyup,blur', rule: 'email'},
                  
            ],  theme: 'metro'
	        });
		$('#edit_user').on('validationSuccess', function (event) {
	        $('#edit_user').submit();
	    });
		
		var url = "/mapps/getUserOfToken";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				get_user_data(response);	            	
            }});
		
	});
	
	function get_user_data(response){
		var user = response;	
		document.getElementById('institution').innerHTML=user.institution.name;
		document.getElementById('username').innerHTML=user.userName;
		document.getElementById('idDocument').innerHTML=user.idDocument;
		document.getElementById('role').innerHTML=user.role;
		$('#email').jqxInput('val', user.email);
		$('#name').jqxInput('val', user['name']);
		$('#lastName').jqxInput('val', user['lastName']);
		
		
		
	}
</script>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab"><a href="./my_account.jsp">MI CUENTA</a></div>
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
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_5" class="tab active" onclick="location.href='./configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo" style="height:580px;">
		<div id="sidebar_left">
			<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
                   <%
					if(role.equals(Role.TRAINER)){
                   %>
                   		<li style="height:35px;"><a href="./my_account.jsp"> Mi cuenta </a></li>
                   		<li style="height:35px;"><a href="./add_device.jsp"> Agregar un Dispositivo </a></li>
                   <%
					}
				   %>     				
        		</ul>
  			</div>
        </div>	   
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="configuration_main.jsp">CONFIGURACI&Oacute;N</a> > > >  Mi cuenta
            </div>
            <div id="title" style="margin:15px;">
                
            </div>     	
            <div style="width:100%; height:100%; font-size:12px;">
            	<form  action="/mapps/modifyMyAccount" method="post" name="edit_user" id="edit_user" >
                    <div id="main_div_left" style="width:32%; height:100%; display:inline-block;">
                        <div id="document" class="my_account_field">
                            <div class="my_account_tag">
                                Documento
                            </div>
                            <div class="my_account_data" id="idDocument" name="idDocument">
                                
                            </div>
                        </div>
                        <div id="email_form" class="my_account_field">
                            <div class="my_account_tag">
                                E-mail
                            </div>
                            <div class="my_account_data">
                                <div class="input"><input type="text" name="email" id="email" /></div>
                            </div>
                        </div>
                        <div id="otherRole" class="my_account_field">
                            <div class="my_account_tag">
                                Rol
                            </div>
                            <div class="my_account_data" id="role" name="role">
                                
                            </div>
                        </div>
                    </div>
                    <div id="main_div_center" style="width:25%; height:100%; display:inline-block;">
                        <div id="img" style="float:left; width:80%; margin-top:35px;">	
                            <img src="../images/users/default.png" style="width:150px;"/>
                        </div>
                        
                        <div id="name_form" style="float:left; margin-top:15px; width:65%; text-align:center; font-size:14px; color:#000;">
                            <div style="margin-top:10px;"> Nombre:  </div>
                            <div style="margin-top:10px;"><input type="text" name="name" id="name" /></div>
                            <div style="margin-top:10px;"> Apellido:  </div>
                            <div style="margin-top:10px;"><input type="text" name="lastName" id="lastName" /></div>
                        </div>
                        
                        <div style="margin-left:-10%; margin-top:35px;">
                    		<input type="button" id="validate" value="CONFIRMAR" style="margin-top:40px; margin-left:5%;"/>
                   		</div>
                    </div>
                    <div id="main_div_right" style="width:32%; height:100%; display:inline-block; margin-left:8%;">
                        
                        <div id="othherInstitution" class="my_account_field">
                            <div class="my_account_tag">
                                Instituci&oacute;n
                            </div>
                            <div class="my_account_data" id="institution" name="institution">
                                
                            </div>
                        </div>
                        
                        <div id="otherUsername" class="my_account_field">
                    		<div class="my_account_tag" >
                        		Nombre de usuario
                        	</div>
                        	<div class="my_account_data" name="username" id="username">
                        	
                        	</div>
                    	</div>
                    	
                        <div id="otherPassword" class="my_account_field">
                            <div class="my_account_tag">
                                Contrase&ntilde;a
                            </div>
                            <div class="my_account_data" id="password" name="password">
                              ****  
                            </div>
                        </div>
                    </div>
                 </form>
            </div>
        </div>
        <div id="sidebar_right">
        	
        </div>
    </div>
 
    
</div>
<div id="pie">
<%} %>
</div>
</body>
</html>
