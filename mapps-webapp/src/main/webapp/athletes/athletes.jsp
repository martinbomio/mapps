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
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxsplitter.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
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
String error = String.valueOf(request.getParameter("error"));
if (error.equals("null"))
	error = "";

if(info.equals("1")){
	// El atleta ha sido ingresado con exito
	pop_up_message = "El atleta fue ingresado al sistema con exito.";
	show_pop_up = true;	
}
%>
<body>


<script type="text/javascript">

	$(document).ready(function () {
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
        var url = "/mapps/getAllAthletesOfInstitution";
        $.ajax({
            url: url,
            type: "GET",
            success: function (response){
            	fill_splitter(response);
            }});
			
			
		$('#pop_up').jqxWindow({ maxHeight: 150, maxWidth: 280, minHeight: 30, minWidth: 250, height: 145, width: 270,
            resizable: false, 
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
	function fill_splitter(response){
		$("#splitter").jqxSplitter({  width: 820, height: 390, panels: [{ size: '40%'}] });
		var athletes = response["athletes"];
        // prepare the data
        var k = 0;
		var data = [];
        for (var i = 0; i < athletes.length; i++) {
            var row = {};
            row["name"] = athletes[i]['name'];
            row["lastname"] = athletes[i]['lastName'];
            row["birth"] = athletes[i]['birth'];
            row["gender"] = athletes[i]['gender'];
            row["email"] = athletes[i]['email'];
            row["weight"] = athletes[i]['weight'];
            row["height"] = athletes[i]['height'];
            row["document"] = athletes[i]['idDocument'];
            data[i] = row;
            k++;
        }
        var source =
        {
            localdata: data,
            datatype: "json"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        var updatePanel = function (index) {
            var container = $('<div style="margin: 5px;"></div>')
            var leftcolumn = $('<div style="float: left; width: 45%;"></div>');
            var rightcolumn = $('<div style="float: left; width: 40%;"></div>');
            container.append(leftcolumn);
            container.append(rightcolumn);
            var datarecord = data[index];
            var name = "<div style='margin: 10px;'><b>Nombre:</b> " + datarecord.name + "</div>";
            var lastname = "<div style='margin: 10px;'><b>Apellido:</b> " + datarecord.lastname + "</div>";
            var birth = "<div style='margin: 10px;'><b>Fecha de Nacimiento:</b> " + datarecord.birth + "</div>";
            var gender = "<div style='margin: 10px;'><b>Género:</b> " + get_gender(datarecord.gender) + "</div>";
            $(leftcolumn).append(name);
            $(leftcolumn).append(lastname);
            $(leftcolumn).append(birth);
            $(leftcolumn).append(gender);
            var email = "<div style='margin: 10px;'><b>Email:</b> " + datarecord.email + "</div>";
            var weight = "<div style='margin: 10px;'><b>Peso:</b> " + datarecord.weight + "</div>";
            var height = "<div style='margin: 10px;'><b>Altura:</b> " + datarecord.height + "</div>";
            var document = "<div style='margin: 10px;'><b>C.I.:</b> " + datarecord.document + "</div>";
            $(rightcolumn).append(email);
            $(rightcolumn).append(weight);
            $(rightcolumn).append(height);
            $(rightcolumn).append(document);
            $("#ContentPanel").html(container.html());
        }
        $('#listbox').on('select', function (event) {
            updatePanel(event.args.index);
        });
  
        // Create jqxListBox
        $('#listbox').jqxListBox({ selectedIndex: 0,  source: dataAdapter, displayMember: "firstname", valueMember: "notes", itemHeight: 70, height: '100%', width: '100%', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = data[index];
                //var imgurl = '../../images/' + label.toLowerCase() + '.png';
                var img = '<img height="50" width="40" src="../images/logo.png"/>';
                var table = '<table style="min-width: 130px;"><tr><td style="width: 40px;" rowspan="2">' + img + '</td><td>' + datarecord.name + " " + datarecord.lastname + '</td></table>';
                return table;
            }
        });
        updatePanel(0);
	}
	
	function get_gender(gender){
		var gender = "Desconocido";
		if (gender.localeCompare("MALE")){
			gender = "Hombre";
		}else if (gender.localeCompare("FEMALE")){
			gender = "Mujer";
		}
		return gender;
	}
</script>


<div id="header">
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:15px; margin-left:20px;" /></a>
    </div>
    <div id="header_central">
		<div id="pop_up">
            <div>
                <img width="14" height="14" src="" alt="" />
                Modal Window
            </div>
            <div>
            	<div>
                	<%=pop_up_message
					%>
                </div>
                <div>
            		<div style="float: right; margin-top: 15px;">
           		        <input type="button" id="ok" value="OK" style="margin-right: 10px" />
        	        </div>
                </div>
            </div>
        </div>
    </div>
    <div id="header_der">
	
    </div>
</div>
<div id="contenedor">

    <div id="tabs">
	    <div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab active" onclick="window.location.reload()">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration.jsp'">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
       
        	<div id="title" style="margin:15px;">
           			<label> Todos mis jugadores </label>
            </div>
            <div id="splitter" style="margin-top:20px;margin-bottom:35px;">
                <div style="overflow: hidden;">
                    <div style="border: none;" id="listbox">
                    
                    </div>
                </div>
                <div style="overflow: hidden;" id="ContentPanel">
                
                </div>
        	</div>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="add_athletes.jsp"> Agregar </a></li>
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
