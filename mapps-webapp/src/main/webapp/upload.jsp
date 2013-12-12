<%
String error = "";
if(request.getAttribute("error")== null){
   error = "";

}else error = String.valueOf(request.getAttribute("error"));

%>
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
     <div class="movie">
     <h1>Ingresar una nueva pelicula</h1>
     	<form method="post" action="uploadservlet" enctype="multipart/form-data">
     	<center><span class="error"><%=error%></span></center>
         <br/>
         <h3>Clip Upload:</h3>
            <p>Clip 1: </p>
         <label style="font-size:12px;margin-left:20px">Duration: </label><input type="time" name="clipduration0" step="10" id="clipduration1" style="width:100px" required/>
         <br />
        <center><input style="width:120px;font-size:16px;margin-bottom:20px;" type="submit" name="ingresar" value="Upload" style="font-size:16px"/></center>
        <input type="hidden" name="token" id="token" value="<%=request.getAttribute("token")%>" />
    	 </form>
     </div>

    <!-- end .content --></div>
  <div class="sidebar2">

    <!-- end .sidebar2 --></div>
  <div class="footer">

    <!-- end .footer --></div>
  <!-- end .container --></div>
</body>
</html>
