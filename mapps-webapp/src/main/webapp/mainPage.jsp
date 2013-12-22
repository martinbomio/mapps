<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %><%
    String admin;
    if(request.getAttribute("admin")== null){
        admin="";
    } else{
        admin=String.valueOf(request.getAttribute("admin"));
    }

    String token=String.valueOf(request.getAttribute("token"));






%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html5; charset=UTF-8" />
    <title></title>
</head>
<body>

<%if(admin=="administrator"){  %>
<form action="registerUser" method="post">

<input type="hidden" name="token" value=<%=token%>/>
<input type="submit" value="register user" name="register"/>
</form>
<%}%>
MAIN PAGE

 <%=token%>




</body>
</html>