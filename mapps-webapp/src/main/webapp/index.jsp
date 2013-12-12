
<%
String error = "";
if(request.getAttribute("error")== null){
   error = "";
   
}else error = String.valueOf(request.getAttribute("error"));

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html5; charset=UTF-8" />
<title>UMFlix-UploadWeb</title>
<link rel="stylesheet" href="css/style.css" type="text/css" media="screen"/>
</head>


<body>

<div class="container">

  <div class="sidebar1">
    <!-- end .sidebar1 --></div>
  <div class="content">
 	 <div class="image">
     	<img src="images/logo.png" width="100%"  />
        <center><h1>Upload-Web</h1></center>
 	 </div>
     <div class="login">
     <div class="loginContent">
    	 <form action="loginservlet" method="post">
    	 <center><span class="error"><%=error%></span></center>
         <br/>
     	<label>Username: <input type="email" name="email" id="email" required="required" /></label>
        <br/>
        <br/>
        <label>Password: <input type="password" name="password" id="password" required="required" /></label>
        <br/>
        <br/>
        <center><input type="submit" name="ingresar" value="Ingresar" style="font-size:16px"/></center>
    	 </form>
	</div>
     </div>

    <!-- end .content --></div>
  <div class="sidebar2">

    <!-- end .sidebar2 --></div>
  <div class="footer">

    <!-- end .footer --></div>
  <!-- end .container --></div>
</body>
</html>

