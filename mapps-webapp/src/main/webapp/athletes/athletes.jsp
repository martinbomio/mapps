<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/jugadores_template.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
	<!-- InstanceBeginEditable name="EditRegion5" -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxsplitter.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    <!-- InstanceEndEditable -->
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	request.getRequestDispatcher("index_login.jsp");	
}
Role role;
if ( session.getAttribute("role") == null){
	role = null;	
}else{
	role = (Role) session.getAttribute("role");	
}
%>
<body>
<!-- InstanceBeginEditable name="EditRegion4" -->
<script type="text/javascript">

	$(document).ready(function () {
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '120', mode: 'vertical'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$("#splitter").jqxSplitter({  width: 820, height: 390, panels: [{ size: '40%'}] });
            // prepare the data
            var data = new Array();
            var firstNames = ["Nancy", "Andrew", "Janet", "Margaret", "Steven", "Michael", "Robert", "Laura", "Anne"];
            var lastNames = ["Davolio", "Fuller", "Leverling", "Peacock", "Buchanan", "Suyama", "King", "Callahan", "Dodsworth"];
            var titles = ["Sales Representative", "Vice President, Sales", "Sales Representative", "Sales Representative", "Sales Manager", "Sales Representative", "Sales Representative", "Inside Sales Coordinator", "Sales Representative"];
            var titleofcourtesy = ["Ms.", "Dr.", "Ms.", "Mrs.", "Mr.", "Mr.", "Mr.", "Ms.", "Ms."];
            var birthdate = ["08-Dec-48", "19-Feb-52", "30-Aug-63", "19-Sep-37", "04-Mar-55", "02-Jul-63", "29-May-60", "09-Jan-58", "27-Jan-66"];
            var hiredate = ["01-May-92", "14-Aug-92", "01-Apr-92", "03-May-93", "17-Oct-93", "17-Oct-93", "02-Jan-94", "05-Mar-94", "15-Nov-94"];
            var address = ["507 - 20th Ave. E. Apt. 2A", "908 W. Capital Way", "722 Moss Bay Blvd.", "4110 Old Redmond Rd.", "14 Garrett Hill", "Coventry House", "Miner Rd.", "Edgeham Hollow", "Winchester Way", "4726 - 11th Ave. N.E.", "7 Houndstooth Rd."];
            var city = ["Seattle", "Tacoma", "Kirkland", "Redmond", "London", "London", "London", "Seattle", "London"];
            var postalcode = ["98122", "98401", "98033", "98052", "SW1 8JR", "EC2 7JR", "RG1 9SP", "98105", "WG2 7LT"];
            var country = ["USA", "USA", "USA", "USA", "UK", "UK", "UK", "USA", "UK"];
            var homephone = ["(206) 555-9857", "(206) 555-9482", "(206) 555-3412", "(206) 555-8122", "(71) 555-4848", "(71) 555-7773", "(71) 555-5598", "(206) 555-1189", "(71) 555-4444"];
            var notes = ["Education includes a BA in psychology from Colorado State University in 1970.  She also completed 'The Art of the Cold Call.'  Nancy is a member of Toastmasters International.",
                "Andrew received his BTS commercial in 1974 and a Ph.D. in international marketing from the University of Dallas in 1981.  He is fluent in French and Italian and reads German.  He joined the company as a sales representative, was promoted to sales manager in January 1992 and to vice president of sales in March 1993.  Andrew is a member of the Sales Management Roundtable, the Seattle Chamber of Commerce, and the Pacific Rim Importers Association.",
                "Janet has a BS degree in chemistry from Boston College (1984).  She has also completed a certificate program in food retailing management.  Janet was hired as a sales associate in 1991 and promoted to sales representative in February 1992.",
                "Margaret holds a BA in English literature from Concordia College (1958) and an MA from the American Institute of Culinary Arts (1966).  She was assigned to the London office temporarily from July through November 1992.",
                "Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses 'Successful Telemarketing' and 'International Sales Management.'  He is fluent in French.",
                "Michael is a graduate of Sussex University (MA, economics, 1983) and the University of California at Los Angeles (MBA, marketing, 1986).  He has also taken the courses 'Multi-Cultural Selling' and 'Time Management for the Sales Professional.'  He is fluent in Japanese and can read and write French, Portuguese, and Spanish.",
                "Robert King served in the Peace Corps and traveled extensively before completing his degree in English at the University of Michigan in 1992, the year he joined the company.  After completing a course entitled 'Selling in Europe,' he was transferred to the London office in March 1993.",
                "Laura received a BA in psychology from the University of Washington.  She has also completed a course in business French.  She reads and writes French.",
                "Anne has a BA degree in English from St. Lawrence College.  She is fluent in French and German."];
            var k = 0;
            for (var i = 0; i < firstNames.length; i++) {
                var row = {};
                row["firstname"] = firstNames[k];
                row["lastname"] = lastNames[k];
                row["title"] = titles[k];
                row["titleofcourtesy"] = titleofcourtesy[k];
                row["birthdate"] = birthdate[k];
                row["hiredate"] = hiredate[k];
                row["address"] = address[k];
                row["city"] = city[k];
                row["postalcode"] = postalcode[k];
                row["country"] = country[k];
                row["homephone"] = homephone[k];
                row["notes"] = notes[k];
                data[i] = row;
                k++;
            }
            var source =
            {
                localdata: data,
                datatype: "array"
            };
            var dataAdapter = new $.jqx.dataAdapter(source);
            var updatePanel = function (index) {
                var container = $('<div style="margin: 5px;"></div>')
                var leftcolumn = $('<div style="float: left; width: 45%;"></div>');
                var rightcolumn = $('<div style="float: left; width: 40%;"></div>');
                container.append(leftcolumn);
                container.append(rightcolumn);
                var datarecord = data[index];
                var firstname = "<div style='margin: 10px;'><b>First Name:</b> " + datarecord.firstname + "</div>";
                var lastname = "<div style='margin: 10px;'><b>Last Name:</b> " + datarecord.lastname + "</div>";
                var title = "<div style='margin: 10px;'><b>Title:</b> " + datarecord.title + "</div>";
                var address = "<div style='margin: 10px;'><b>Address:</b> " + datarecord.address + "</div>";
                $(leftcolumn).append(firstname);
                $(leftcolumn).append(lastname);
                $(leftcolumn).append(title);
                $(leftcolumn).append(address);
                var postalcode = "<div style='margin: 10px;'><b>Postal Code:</b> " + datarecord.postalcode + "</div>";
                var city = "<div style='margin: 10px;'><b>City:</b> " + datarecord.city + "</div>";
                var phone = "<div style='margin: 10px;'><b>Phone:</b> " + datarecord.homephone + "</div>";
                var hiredate = "<div style='margin: 10px;'><b>Hire Date:</b> " + datarecord.hiredate + "</div>";
                $(rightcolumn).append(postalcode);
                $(rightcolumn).append(city);
                $(rightcolumn).append(phone);
                $(rightcolumn).append(hiredate);
                var education = "<div style='clear: both; margin: 10px;'><div><b>Education</b></div><div>" +  $('#listbox').jqxListBox('getItem', index).value + "</div></div>";
                container.append(education);
                $("#ContentPanel").html(container.html());
            }
            $('#listbox').on('select', function (event) {
                updatePanel(event.args.index);
            });
      
            // Create jqxListBox
            $('#listbox').jqxListBox({ selectedIndex: 0,  source: dataAdapter, displayMember: "firstname", valueMember: "notes", itemHeight: 70, height: '100%', width: '100%',
                renderer: function (index, label, value) {
                    var datarecord = data[index];
                    var imgurl = '../../images/' + label.toLowerCase() + '.png';
                    var img = '<img height="50" width="40" src="' + imgurl + '"/>';
                    var table = '<table style="min-width: 130px;"><tr><td style="width: 40px;" rowspan="2">' + img + '</td><td>' + datarecord.firstname + " " + datarecord.lastname + '</td></tr><tr><td>' + datarecord.title + '</td></tr></table>';
                    return table;
                }
            });
            updatePanel(0);
	
   	});
</script>
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
             	   <li><a href="add_athletes.jsp"> Agregar </a></li>
             	   <li><a href="edit_athletes.jsp"> Editar </a></li>
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