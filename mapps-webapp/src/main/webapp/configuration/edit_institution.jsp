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
	
			
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		//name
		$("#name").jqxInput({placeHolder: "Nombre", height: 25, width: '100%', minLength: 1, theme: 'metro'});
		$("#file").jqxInput({placeHolder: "Nombre", height: 25, width: '100%', minLength: 1, theme: 'metro'});
		//country
		var countries = new Array("Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burma", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo, Democratic Republic", "Congo, Republic of the", "Costa Rica", "Cote d'Ivoire", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Greenland", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, North", "Korea, South", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Mongolia", "Morocco", "Monaco", "Mozambique", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda", "Samoa", "San Marino", " Sao Tome", "Saudi Arabia", "Senegal", "Serbia and Montenegro", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "Spain", "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe");
		$("#country").jqxInput({ placeHolder: "País", height: 25, width: '100%', minLength: 1 ,theme: 'metro', 
            source: function (query, response) {
                var item = query.split(/,\s*/).pop();
                // update the search query.
                $("#country").jqxInput({ query: item });
                response(countries);
            },
            renderer: function (itemValue, inputValue) {
                var terms = inputValue.split(/,\s*/);
                // remove the current input
                terms.pop();
                // add the selected item
                terms.push(itemValue);
                // add placeholder to get the comma-and-space at the end
                terms.push("");
                var value = terms.join("");
                return value;
            }
        });
		//register
		$("#validate").jqxButton({ width: '150', height: '35', theme: 'metro'});
		$("#validate").on('click', function (){ 
	        $('#edit_institution').jqxValidator('validate');
	    });
		$("#edit_institution").jqxValidator({
            rules: [
                    {
                        input: "#name", message: "El nombre de la institución es obligatorio!", action: 'keyup, blur', rule: 'required'
                    },
                    { input: "#country", message: "El país al que pertenece la institución es obligatorio!", action: 'keyup, blur', rule: 'required'},
                   
            ],  theme: 'metro'
        });
		$('#edit_institution').on('validationSuccess', function (event) {
	        $('#edit_institution').submit();
	    });
		//Get institutions
		var url = "/mapps/getAllInstitutions";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				create_list(response);	            	
            },
        	data: {edit : 1}    
		});
	});
	function create_list(response){
		var institutions = response;
		$('#list_institutions').on('select', function (event) {
            updatePanel(institutions[event.args.index]);
        });
		$('#list_institutions').jqxListBox({ selectedIndex: 0,  source: institutions, displayMember: "name", valueMember: "name", itemHeight: 60, height: '100%', width: '85%', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = institutions[index];
                var imageurl = datarecord.imageURI;
                //var imgurl = '../../images/' + label.toLowerCase() + '.png';
                var img = '<img height="50" width="50" src="' + datarecord.imageURI + '"/>';
                var table = '<table style="min-width: 130px;"><tr><td style="width: 40px;" rowspan="2">' + img + '</td><td>' + datarecord.name + '</td></table>';
                return table;
            }
        });
		updatePanel(institutions[0]);
	}
	function updatePanel(institutions){
		$('#name').jqxInput('val', institutions['name']);
		$('#country').jqxInput('val', institutions['country']);
		$('#description').val(institutions['description']);
		$('#id-hidden').val(institutions.id)
	}
</script>

<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab">MI CUENTA</div>
		<div id="logout" class="up_tab">CERRAR SESI&Oacute;N</div>
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
    <div id="area_de_trabajo">
		<div id="sidebar_left">

        </div>	   
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="configuration_main.jsp">CONFIGURACI&Oacute;N</a> >> Editar una Institución
            </div>
	        <div id="main_div_left" style="float:left; width:40%; display:inline-block;">
            	<div id="title" style="margin:15px;">
                    <label> 1) Seleccione una instituci&oacute;n </label>
                </div>
        		<div id="list_institutions">
                </div>
            </div>
            <div id="main_div_right" style="float:right; width:60%; display:inline-block;">
                <form action="/mapps/modifyInstitution" method="post" name="edit_institution" id="edit_institution" enctype="multipart/form-data">
                    <div id="title" style="margin:15px;">
                        <label> 2) Modifique los datos que desee </label>
                    </div>
                    <div id="campos" style="margin-left:40px;">
                        <div id="nombre">
                        <div class="tag_form_editar"> Nombre:  </div>
                        <div class="input"><input type="text" name="name" id="name"  /></div>
                        </div>
                        <div id="Descripcion">
                            <div class="tag_form_editar" style="vertical-align:top;"> Descripción: </div>
                            <div class="input"><textarea class="jqx-input jqx-rc-all jqx-input-metro jqx-widget-content-metro jqx-rc-all-metro" style="width:100%; height:200px;" type="text" name="description" id="description" ></textarea></div>
                        </div>
                        <div>
                            <div class="tag_form_editar"> País: </div>
                            <div class="input"><input name="country"  id="country"  /></div>
                        </div>
                        <div>
                    		<div class="tag_form_editar"> Imagen: </div>
                        	<div class="input"><input name="file"  id="file" type="file" class="jqx-rc-all jqx-rc-all-metro jqx-button jqx-button-metro jqx-widget jqx-widget-metro jqx-fill-state-normal jqx-fill-state-normal-metro" /></div>
                    	</div>
                    	<div style="margin-left:25%; margin-top:20px;">
                    		<input type="button" id="validate" value="CONFIRMAR"/>
                   		</div>
                    </div>
                    <input type="hidden" id="id-hidden" name="id-hidden"></input>
                </form>
            </div>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="./register_user.jsp"> Agregar un Usuario </a></li>
             	   <li style="height:35px;"><a href="./edit_user.jsp"> Editar un Usuario </a></li>
                   <li style="height:35px;"><a href="./delete_user.jsp"> Eliminar un Usuario </a></li>
             	   <li style="height:35px;"><a href="./add_sport.jsp"> Agregar un Deporte </a></li>
                   <li style="height:35px;"><a href="./add_institution.jsp"> Agregar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="#"> Editar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="./delete_institution.jsp"> Eliminar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="./add_device.jsp"> Agregar un Dispositivo </a></li>
                   <li style="height:35px;"><a href="./edit_device.jsp"> Editar un Dispositivo </a></li>
        		</ul>
  			</div>
        </div>
    </div>
 
    
</div>
<div id="pie">

</div>
</body>
</html>
