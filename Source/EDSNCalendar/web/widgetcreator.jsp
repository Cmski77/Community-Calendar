<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>EDSN Calendar - Widget Creator</title>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="css/bootstrap-responsive.min.css" />
<link rel="stylesheet" href="css/fullcalendar.css" />
<link rel="stylesheet" href="css/matrix-style.css" />
<link rel="stylesheet" href="css/matrix-media.css" />
<link href="font-awesome/css/font-awesome.css" rel="stylesheet" />
<link rel="stylesheet" href="css/select2.css">
<link rel="stylesheet" href="css/jquery.gritter.css" />
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/bootstrap-responsive.min.css">
<link rel="stylesheet" href="css/colorpicker.css">
<link rel="stylesheet" href="css/datepicker.css">
<link rel="stylesheet" href="css/uniform.css">
<link rel="stylesheet" href="css/select2.css">
<link rel="stylesheet" href="css/matrix-style.css">
<link rel="stylesheet" href="css/matrix-media.css">
<link rel="stylesheet" href="css/bootstrap-wysihtml5.css">
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700,800' rel='stylesheet' type='text/css'>
  <link rel="stylesheet" href="css/frontstyle.css" type="text/css"/>
</head>
<body onload="myFunction()">
<body class="wysihtml5-supported">
    <%
        if(request.getSession().getAttribute("username") == null ||
                ((String)request.getSession().getAttribute("username")).isEmpty())
        {
            response.sendRedirect("login.jsp");
        }
    %>
<!--Header-part-->
<div id="header">
  <h1><a href="dashboard.jsp">Widget Creator</a></h1>
</div>
<!--close-Header-part--> 


<!--top-Header-menu-->
<div id="user-nav" class="navbar navbar-inverse">
  <ul class="nav">
    <li  class="dropdown" id="profile-messages" ><a title="" href="#" data-toggle="dropdown" data-target="#profile-messages" class="dropdown-toggle"><i class="icon icon-user"></i>  <span class="text">Welcome <%=(String)session.getAttribute("username")%>  </span><b class="caret"></b></a>
      <ul class="dropdown-menu">
        <li><a href="#"><i class="icon-user"></i> My Profile</a></li>
        <li class="divider"></li>
        <li><a href="login.jsp"><i class="icon-key"></i> Log Out</a></li>
      </ul>
    </li>
    <li class=""><a title="" href="frontpage.jsp"><i class="icon icon-calendar"></i> <span class="text">View calendar</span></a></li>
    <li class=""><a title="" href="Settings"><i class="icon icon-cog"></i> <span class="text">Settings</span></a></li>
    <li class=""><a title="" href="login.jsp"><i class="icon icon-share-alt"></i> <span class="text">Logout</span></a></li>
  </ul>
</div>
<!--close-top-Header-menu-->
<!--start-top-serch-->
<!--close-top-serch-->
<!--sidebar-menu-->
<div id="sidebar"><a href="#" class="visible-phone"><i class="icon icon-home"></i> Dashboard</a>
  <ul>
    <li><a href="index.jsp"><i class="icon icon-home"></i> <span>Dashboard</span></a> </li>
    <li> <a href="GetEvents"><i class="icon icon-list-alt"></i> <span>Events</span></a> </li>
    <li><a href="Settings"><i class="icon icon-wrench"></i> <span>Settings</span></a></li>
    <li><a href="GetUsers"><i class="icon icon-user"></i> <span>Users</span></a></li>
    <li class="active"><a href="widgetcreator.jsp"><i class="icon icon-pencil"></i> <span>Widget Creator</span></a></li>
  </ul>
</div>
<!--sidebar-menu-->

<!--main-container-part-->
<div id="content">
<!--breadcrumbs-->
  <div id="content-header">
        <div id="breadcrumb"> <a href="index.jsp" title="Go to Home" class="tip-bottom"><i class="icon-home"></i> Home</a> <a href="#">Widget Creator</a> </div>
    <h1>Widget Creator</h1>
  </div>
<!--End-breadcrumbs-->

<!--Action boxes-->

<div class="container-fluid">
  <hr>
  <div class="row-fluid">
    <div class="span6">
      <div class="widget-box">
        <div class="widget-title"> <span class="icon"> <i class="icon-align-justify"></i> </span>
          <h5>Widget settings</h5>
        </div>
        <div class="widget-content nopadding">
          <form action="javascript:generateWidget()" method="post" class="form-horizontal">
            <div class="control-group">
              <label class="control-label">Header text :</label>
              <div class="controls">
                <input type="text" class="span11" placeholder="Calendar header text" id="headerText"  value="EDSN Calendar">
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Header text color :</label>
              <div class="controls">
                <div data-color-format="hex" data-color="#000000" class="input-append color colorpicker">
                  <input type="text" value="#000000" class="span11" id='headerTextColor' readonly>
                  <span class="add-on"><i style="background-color: rgb(117, 20, 20);"></i></span> </div>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Header image url :</label>
              <div class="controls">
                <input type="text" class="span11" placeholder="localhost/frog.png" id="headerURL" value="http://edsn.org/Portals/13/LogoEDSN01.jpg?ver=2013-08-19-075743-833">
              </div>
            </div>
              <div class="control-group">
              <label class="control-label">Options :</label>
              <div class="controls">
                <label style='position:relative;top:3px;'>
                  <span class=""><input type="checkbox" name="radios" id="eventBtnChkbox" style="opacity: 0;">
                  Event add button</label>
              </div>
            </div>
            <div class="form-actions">
              <button class="btn btn-success">Create widget</button>
            </div>
          </form>
        </div>
      </div>
    </div>
      
    <div class="span5">
      <div class="widget-box">
        <div class="widget-title"> <span class="icon"> <i class="icon-align-justify"></i> </span>
          <h5>Paste this code onto your site:</h5>
        </div>
        <div class="widget-content" style="height: 300px;">
          <form action="#" >
                    <div class="controls">
            <textarea class="span11" readonly style="height: 300px; width: 100%;" id="widgetCode"></textarea>
        </div>
          </form>
        </div>
      </div>
  </div>
      
    <div class="span6" style="float: left;height: 100%;width: 89%">
      <div class="widget-box" >
        <div class="widget-title"> <span class="icon"> <i class="icon-align-justify"></i> </span>
          <h5>Preview:</h5>
        </div>
        <div class="widget-content" id="previewContent" >

        </div>
      </div>
  </div>
</div>

<!--End-Action boxes-->    


<!--end-main-container-part-->

<!--Footer-part-->

<!--end-Footer-part-->

<script src="js/jquery.min.js"></script> 
<script src="js/jquery.ui.custom.js"></script> 
<script src="js/bootstrap.min.js"></script> 
<script src="js/bootstrap-colorpicker.js"></script> 
<script src="js/bootstrap-datepicker.js"></script> 
<script src="js/jquery.toggle.buttons.js"></script> 
<script src="js/masked.js"></script> 
<script src="js/jquery.uniform.js"></script> 
<script src="js/select2.min.js"></script> 
<script src="js/matrix.js"></script> 
<script src="js/matrix.form_common.js"></script> 
<script src="js/wysihtml5-0.3.0.js"></script> 
<script src="js/jquery.peity.min.js"></script> 
<script src="js/bootstrap-wysihtml5.js"></script> 


<script type="text/javascript">
    
$(document).on('input', $('#headerText'), function(){
generateWidget();
});
$(document).on('change', $('#headerTextColor'), function(){
generateWidget();
});
$(document).on('input', $('#headerURL'), function(){
generateWidget();
});
  // This function is called from the pop-up menus to transfer to
  // a different page. Ignore if the value returned is a null string:
  function goPage (newURL) {

      // if url is empty, skip the menu dividers and reset the menu selection to default
      if (newURL != "") {
      
          // if url is "-", it is this page -- reset the menu:
          if (newURL == "-" ) {
              resetMenu();            
          } 
          // else, send page to designated URL            
          else {  
            document.location.href = newURL;
          }
      }
  }
  
  function generateWidget()
  {
      var widgetCode = "";
      var widgetCodeScripts = "";
      widgetCode += "<div id='edsnCal'>\n";
      widgetCodeScripts += "<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>\n";
      widgetCodeScripts += "<script";
      widgetCodeScripts += "src='https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js'></s";
      widgetCodeScripts += "cript>\n";
      widgetCodeScripts += "<script";
      widgetCodeScripts += "src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js'></s";
      widgetCodeScripts += "cript>\n";
      widgetCode += "\t<center>\n";
      widgetCode += "\t\t<img src='" + document.getElementById("headerURL").value + "' id='previewImg'/><br>\n";
      widgetCode += "\t\t<h1 style='color:" + document.getElementById("headerTextColor").value+ ";'>" + document.getElementById("headerText").value + "</h1>\n";
      if(document.getElementById("eventBtnChkbox").checked)
      {
            widgetCode += "   <div class='container'>\n";
            widgetCode += "    <div class='align'>\n";
            widgetCode += "      <button type='button' class='btn btn-primary btn-md paddin' data-toggle='modal' data-target='#myModal'>\n";
            widgetCode += "      <span class='glyphicon glyphicon-plus' aria-hidden='true'></span> ADD EVENT</button>\n";
            widgetCode += "    </div>\n";
            widgetCode += "      <div class='modal fade' id='myModal' role='dialog'>\n";
            widgetCode += "        <div class='modal-dialog'>\n";
            widgetCode += "          <div class='modal-content'>\n";
            widgetCode += "            <div class='modal-header'>\n";
            widgetCode += "              <button type='button' class='close' data-dismiss='modal'>&times;</button>\n";
            widgetCode += "              <h4 class='modal-title'>POST YOUR EVENT</h4>\n";
            widgetCode += "            </div>\n";
            widgetCode += "              <div></div>\n";
            widgetCode += "            <div class='modal-body'>\n";
            widgetCode += "              <form action='EventSubmit' method='POST'>\n";
            widgetCode += "                <input type='text' class='form-control margins' name='fullName' maxlength='50' required placeholder='Your full name (required)'>\n";
            widgetCode += "                <input type='text' class='form-control margins' name='email' maxlength='50' required placeholder='Your email (required)'>\n";
            widgetCode += "                <input type='text' class='form-control margins' name='title' maxlength='50' required placeholder='Event title (required)'>\n";
            widgetCode += "                <input type='text' class='form-control margins' name='address' maxlength='80' required placeholder='Address (required)'>\n";
            widgetCode += "                <input type='text' class='form-control margins' name='city' maxlength='20' required placeholder='City (required)'>\n";
            widgetCode += "                <input type='text' class='form-control margins' name='state' maxlength='2' required placeholder='State (required)'>\n";
            widgetCode += "                <input type='text' class='form-control margins' name='zip' maxlength='5' required placeholder='Zip Code (required)'>\n";
            widgetCode += "                <label>&emsp;Select category:</label>\n";
            widgetCode += "                <select required name='categories'>\n";
            widgetCode += "                    <option value='Education'>Education</option>\n";
            widgetCode += "                    <option value='Music'>Music</option>\n";
            widgetCode += "                    <option value='Religion'>Religion</option>\n";
            widgetCode += "                    <option value='Sport'>Sport</option>\n";
            widgetCode += "                </select>\n";
            widgetCode += "                <table>\n";
            widgetCode += "                  <tr>\n";
            widgetCode += "                    <td class='align'><label>&emsp;Start Date/Time:</label></td>\n";
            widgetCode += "                    <td><input type='date' class='form-control margins' name='strdate' required placeholder='yyyy-mm-dd'></td>\n";
            widgetCode += "                    <td><input type='time' class='form-control margins' name='strtime' required placeholder='HH:MM:SS'></td>\n";
            widgetCode += "                  </tr>\n";
            widgetCode += "                  <tr>\n";
            widgetCode += "                    <td class='align'><label>&emsp;End Date/Time:</label></td>\n";
            widgetCode += "                    <td><input type='date' class='form-control margins' name='enddate' required placeholder='yyyy-mm-dd'></td>\n";
            widgetCode += "                    <td><input type='time' class='form-control margins' name='endtime' required placeholder='HH:MM:SS'></td>\n";
            widgetCode += "                  </tr>\n";
            widgetCode += "                </table>\n";
            widgetCode += "                  <textarea name='description' class='form-control margins' placeholder='Description (required - 100 character limit)' maxlength='100'></textarea>\n";
            widgetCode += "                  <div class='modal-footer'>              \n";
            widgetCode += "                    <button type='submit' class='btn btn-primary btn-block'>Submit</button>\n";
            widgetCode += "                  </div>\n";
            widgetCode += "              </form>\n";
            widgetCode += "            </div>\n";
            widgetCode += "          </div>\n";
            widgetCode += "        </div>\n";
            widgetCode += "      </div>\n";
            widgetCode += "  </div>\n";
      }
      widgetCode += "\t</center><br>\n";
      widgetCode += "\t<div id=myCalendar' class='align'>\n";
      widgetCode += "\t\t<iframe src='https://calendar.google.com/calendar/embed?showTitle=0&amp;height=900&amp;wkst=1&amp;bgcolor=%23ffffff&amp;src=1b0fgl15no2em0s761g3nmsojk%40group.calendar.google.com&amp;color=%23125A12&amp;src=drcg5o2lrknp529espcaerom6g%40group.calendar.google.com&amp;color=%23B1365F&amp;src=4lc9vqncnpcs7l6j8v8fmi9k4o%40group.calendar.google.com&amp;color=%2323164E&amp;src=b9vn1j2c33h3t0q8rlhmq1tn9s%40group.calendar.google.com&amp;color=%238C500B&amp;ctz=America%2FNew_York' style='border-width:0' width='100%' height='600px' frameborder='1' scrolling='no'></iframe>\n";
      widgetCode += "\t</div>\n";
      widgetCode += "</div>";


      widgetCode += "";
      widgetCode += "";
      document.getElementById("widgetCode").value = widgetCodeScripts + widgetCode;
      document.getElementById("previewContent").innerHTML = widgetCode;
      //console.log(widgetCode);
  }

// resets the menu selection upon entry to this page:
function resetMenu() {
   document.gomenu.selector.selectedIndex = 2;
}
</script>
</body>
</html>
