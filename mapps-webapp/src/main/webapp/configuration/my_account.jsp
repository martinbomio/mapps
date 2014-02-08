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
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script> 
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
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
boolean show_pop_up = false;
String pop_up_message = "";
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";

if(info.equals("5")){
	// El Usuario fue modificado con exito
	pop_up_message = "Sus datos fueron modificados con éxito.";
	show_pop_up = true;	
}
if(info.equals("1")){
	
	pop_up_message = "La contraseña fue modificada con exito";
	show_pop_up = true;	
}
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
					
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '55%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		// Create a jqxMenu
        $("#jqxMenu2").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu2").css('visibility', 'visible');
        
        var url = "/mapps/getUserOfToken";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				get_user_data(response);	            	
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
	function get_user_data(response){
		var user = response;
		var name=user.name+" "+user.lastName;
		document.getElementById('username').innerHTML=user.userName;
		document.getElementById('institution').innerHTML=user.institution.name;
		document.getElementById('email').innerHTML=user.email;
		document.getElementById('role').innerHTML=user.role;
		document.getElementById('idDocument').innerHTML=user.idDocument;
		
		document.getElementById('name').innerHTML=name;
		
		
	}		
	
</script>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		
		<div id="pop_up">
            <div>
                <img width="14" height="14" src="../images/ok.png" alt="" />
                Informaci&oacute;n
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
        <div id="logout" class="up_tab"><a href="./configuration/my_account.jsp">MI CUENTA</a></div>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
    </div>
</div>
<div id="contenedor">
	<div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:12%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab active" onclick="location.href='./configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo" style="height:580px;">
		<div id="sidebar_left">
			<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
                   <%
					if(role.equals(Role.TRAINER)){
                   %>
                   		<li style="height:35px;"><a href=""> Mi cuenta </a></li>
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
            <div style="width:100%; height:100%; font-size:12px; margin-left:5%;">
            	<div id="main_div_left" style="width:32%; height:100%; display:inline-block;">
                	
                	<div id="document" class="my_account_field">
                    	<div class="my_account_tag">
                        	Documento
                        </div>
                        <div class="my_account_data" id="idDocument" name="idDocument">
                        	
                        </div>
                    </div>
                    
                    <div id="otherEmail" class="my_account_field">
                    	<div class="my_account_tag">
                        	E-mail
                        </div>
                        <div class="my_account_data" id="email" name="email">
                        	
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
                	<div id="img" style="float:left; width:80%; margin-top:65px;">	
                        <img src="../images/users/default.png" style="width:150px;"/>
                    </div>
                    
                    <div id="name" style="float:left; margin-top:15px;; width:65%; height:25px; text-align:center; font-size:14px; color:#000;">
                    	Luis Aguiar
                    </div>
                    
                    <div id="jqxMenu2" style="visibility:hidden; margin-top:100px; float:left;">
						<ul>
                            <li style="height:45px; text-align:center;"><a href="./edit_my_user.jsp"> Editar mis datos </a></li>
                            <li style="height:45px; text-align:center;"><a href="./change_my_password.jsp"> Cambiar contrase&ntilde;a </a></li>
                    	</ul>
                    </div>
                </div>
                <div id="main_div_right" style="width:32%; height:100%; display:inline-block; margin-left:8%;">
                	
                	<div id="otherInstitution" class="my_account_field">
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
            </div>
        </div>
        <div id="sidebar_right">
        	
        </div>
    </div>
 
    
</div>
<div id="pie">

</div>
</body>
</html>
