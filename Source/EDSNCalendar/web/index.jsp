<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
<title>EDSN Calendar</title>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="css/bootstrap.min.css" />
<link rel="stylesheet" href="css/bootstrap-responsive.min.css" />
<link rel="stylesheet" href="css/fullcalendar.css" />
<link rel="stylesheet" href="css/matrix-style.css" />
<link rel="stylesheet" href="css/matrix-media.css" />
<link href="font-awesome/css/font-awesome.css" rel="stylesheet" />
<link rel="stylesheet" href="css/jquery.gritter.css" />
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700,800' rel='stylesheet' type='text/css'>
</head>
<body>
    <%
        if(request.getSession().getAttribute("username") == null ||
                ((String)request.getSession().getAttribute("username")).isEmpty())
        {
            response.sendRedirect("login.jsp");
        }
    %>
<!--Header-part-->
<div id="header">
  <h1><a href="index.jsp">EDSN Calendar</a></h1>
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
    <li class="active"><a href="index.jsp"><i class="icon icon-home"></i> <span>Dashboard</span></a> </li>
    <li> <a href="GetEvents"><i class="icon icon-list-alt"></i> <span>Events</span></a> </li>
    <li><a href="Settings"><i class="icon icon-wrench"></i> <span>Settings</span></a></li>
    <li><a href="GetUsers"><i class="icon icon-user"></i> <span>Users</span></a></li>
    <li><a href="widgetcreator.jsp"><i class="icon icon-pencil"></i> <span>Widget Creator</span></a></li>
  </ul>
</div>
<!--sidebar-menu-->

<!--main-container-part-->
<div id="content">
<!--breadcrumbs-->
  <div id="content-header">
    <div id="breadcrumb"> <a href="index.jsp" title="Go to Home" class="tip-bottom"><i class="icon-home"></i> Home</a></div>
  </div>
<!--End-breadcrumbs-->

<!--Action boxes-->
  <div class="container-fluid">
    <div class="quick-actions_homepage">
      <ul class="quick-actions">
        <li class="bg_lb"> <a href="index.jsp"> <i class="icon-dashboard"></i> Dashboard </a> </li>
        <li class="bg_lg span3"> <a href=GetEvents> <i class="icon-list-alt"></i> Events</a> </li>
        <div><li class="bg_ly span3"> <a href="GetEvents"> <i class="icon-inbox"></i> <div id="unapprovedCount"></div> Events waiting for approval </a> </li>
        <li class="bg_lo"> <a href="frontpage.jsp"> <i class="icon-calendar"></i> View published calendar</a> </li>
        <li class="bg_ls"> <a href="Settings"> <i class="icon-wrench"></i> Settings</a> </li>
        <li class="bg_lo span3"> <a href="GetUsers"> <i class="icon-user"></i> Users</a> </li>
        <li class="bg_lg span3"> <a href="#" data-toggle="modal" data-target="#myModal"  onclick="document.getElementById('invisForm').style.visibility=''"> <i class="icon-plus"></i> Add Event</a> </li>   
        <li class="bg_lb"> <a href="widgetcreator.jsp"> <i class="icon-pencil"></i> Widget Creator</a> </li>
      </ul>
    </div>
 <div id="myCalendar" class="align" >
      <iframe src="https://calendar.google.com/calendar/embed?showTitle=0&amp;height=900&amp;wkst=1&amp;bgcolor=%23ffffff&amp;src=1b0fgl15no2em0s761g3nmsojk%40group.calendar.google.com&amp;color=%23125A12&amp;src=drcg5o2lrknp529espcaerom6g%40group.calendar.google.com&amp;color=%23B1365F&amp;src=4lc9vqncnpcs7l6j8v8fmi9k4o%40group.calendar.google.com&amp;color=%2323164E&amp;src=b9vn1j2c33h3t0q8rlhmq1tn9s%40group.calendar.google.com&amp;color=%238C500B&amp;ctz=America%2FNew_York" style="border-width:1px;border-style:solid;" width="89.75%" height="700" frameborder="1" scrolling="no"></iframe>
  </div>
  <div id="invisForm" class="container" style="visibility: hidden;">
      <div class="modal fade" id="myModal" role="dialog">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal">&times;</button>
              <h4 class="modal-title">POST YOUR EVENT</h4>
            </div>
            <div class="modal-body">
              <form action="EventSubmit" method="POST">
                <input type="text" class="form-control margins" name="fullName" maxlength="50" placeholder="Your full name (required)">
                <input type="text" class="form-control margins" name="email" maxlength="50" placeholder="Your email (required)">
                <input type="text" class="form-control margins" name="title" maxlength="50" placeholder="Event title (required)">
                <input type="text" class="form-control margins" name="address" maxlength="20" placeholder="Address (required)">
                <input type="text" class="form-control margins" name="city" maxlength="20" placeholder="City (required)">
                <input type="text" class="form-control margins" name="state" maxlength="2" placeholder="State (required)">
                <input type="text" class="form-control margins" name="zip" maxlength="5" placeholder="Zip Code (required)">
                <table>
                  <tr>
                    <td class="align"><label>Start Date/Time:</label></td>
                    <td><input type="date" class="form-control margins" name="strdate" placeholder="mm/dd/yyyy"></td>
                    <td><input type="time" class="form-control margins" name="strtime" placeholder="00:00AM/PM"></td>
                  </tr>
                  <tr>
                    <td class="align"><label>End Date/Time:</label></td>
                    <td><input type="date" class="form-control margins" name="enddate" placeholder="mm/dd/yyyy"></td>
                    <td><input type="time" class="form-control margins" name="endtime" placeholder="00:00AM/PM"></td>
                  </tr>
                </table>
                  <textarea name="description" class="form-control margins" placeholder="Description (required - 100 character limit)" maxlength="100"></textarea>
                  <div class="modal-footer">              
                    <button type="submit" class="btn btn-primary btn-block">Submit</button>
                  </div>
              </form>
            </div>
          </div>
        </div>
      </div>
  </div>
<!--End-Action boxes-->    


<!--end-main-container-part-->

<!--Footer-part-->

<!--end-Footer-part-->

<script src="js/excanvas.min.js"></script> 
<script src="js/jquery.min.js"></script> 
<script src="js/jquery.ui.custom.js"></script> 
<script src="js/bootstrap.min.js"></script> 
<script src="js/jquery.flot.min.js"></script> 
<script src="js/jquery.flot.resize.min.js"></script> 
<script src="js/jquery.peity.min.js"></script> 
<script src="js/fullcalendar.min.js"></script> 
<script src="js/matrix.js"></script> 
<script src="js/matrix.dashboard.js"></script> 
<script src="js/jquery.gritter.min.js"></script> 
<script src="js/matrix.interface.js"></script> 
<script src="js/matrix.chat.js"></script> 
<script src="js/jquery.validate.js"></script> 
<script src="js/matrix.form_validation.js"></script> 
<script src="js/jquery.wizard.js"></script> 
<script src="js/jquery.uniform.js"></script> 
<script src="js/select2.min.js"></script> 
<script src="js/matrix.popover.js"></script> 
<script src="js/jquery.dataTables.min.js"></script> 
<script src="js/matrix.tables.js"></script> 
<script src="js/edsn-cal-events.js"/></script>

<script type="text/javascript">
  getNumOfEventsForApproval();
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

// resets the menu selection upon entry to this page:
function resetMenu() {
   document.gomenu.selector.selectedIndex = 2;
}
</script>
</body>
</html>
