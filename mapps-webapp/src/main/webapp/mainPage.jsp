<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.mapps.model.Role" %><%

    Role role;
    if(request.getAttribute("role")==null){
        role=null;
    }else{
        role=(Role)request.getAttribute("role");
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

<%if(role.toString()=="Administrator"){  %>
<form action="registerUser" method="post">

<input type="hidden" name="token" value=<%=token%>/>
<input type="submit" value="register user" name="register"/>
</form>
<%}%>
MAIN PAGE

 <%=token%>




</body>
</html>