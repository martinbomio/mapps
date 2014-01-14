
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxpasswordinput.js"></script>
    <link rel="stylesheet" href="./jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/main_style.css">
</head>
<%@ page import="com.mapps.model.Role" %>
<%
    String error = String.valueOf(request.getAttribute("error"));
    if (error.equals("null"))
        error = "";
    String info = String.valueOf(request.getAttribute("info"));
    if (info.equals("null"))
        info = "";
    Role role;
    if(request.getAttribute("role")==null){
        role=null;
    }else{
        role=(Role)request.getAttribute("role");
    }
    String token=String.valueOf(request.getAttribute("token"));
    if(token.equals("null")||token.equals("")){

    }

%>
<script type="text/javascript">
    $(document).ready(function () {
        $("#name").jqxInput({placeHolder: "Nombre del deporte", height: 35, width: 220, minLength: 1  });
        $("#addSportButton").jqxButton({ width: '100', height: '30'});
    });
</script>

<body>
<div id="header">
    <div id="header_izq">

    </div>
    <div id="header_central">

    </div>
    <div id="header_der">

    </div>
</div>
<div id="container" style="border-top:solid 1px; border-bottom:solid 1px;">
    <div id="login_container" >
        <form action="addSport" method="post">
            <center><span class="error"><%= error %></span></center>
            <center><span class="error"><%= info %></span></center>
            <div id="sportNameField" class="loginForm" > Nombre del Deporte: </div>
            <input type="text" class="loginField" name="name" id="name" style="margin-left:20%;" required="required" />
            <input type="hidden" name="token" value=<%=token%>/>
            <input type="hidden" name="role" value= ""/>
            <div id="submit" align="center" >
                <input id="addSportButton" type="submit" name="Agregar Deporte" value="addSport" />
            </div>
        </form>
    </div>
    <div class="footer">

    </div>
</div>
<div id="pie">

</div>
</body>
</html>