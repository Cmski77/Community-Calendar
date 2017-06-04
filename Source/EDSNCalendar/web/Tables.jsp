<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>EDSN Calendar - Events</title>
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

        <style>
            .modal {
                display: none; /* Hidden by default */
                position: fixed; /* Stay in place */
                z-index: 1; /* Sit on top */
                padding-top: 100px; /* Location of the box */
                left: 0;
                top: 0;
                width: 100%; /* Full width */
                height: 100%; /* Full height */
                margin:auto;
                overflow: auto; /* Enable scroll if needed */
                background-color: rgb(0,0,0); /* Fallback color */
                background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
                /*text-align:center;*/
            }

            .modal-content {
                background-color: #fefefe;
                /*text-align:center;*/
                color:black;
                margin: auto;
                padding: 20px;
                border: 1px solid #888;
                width: 45%;
            }
            .close {
                color: #aaaaaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
            }
            .close:hover,
            .close:focus {
                color: #000;
                text-decoration: none;
                cursor: pointer;
            }
        </style>

    </head>
    <body>
        <%
            if (request.getSession().getAttribute("username") == null
                    || ((String) request.getSession().getAttribute("username")).isEmpty()) {
                response.sendRedirect("login.jsp");
            }
        %>
        <!--Header-part-->
        <div id="header">
            <h1><a href="events.jsp">EDSN Calendar - Events</a></h1>
        </div>
        <!--close-Header-part-->


        <!--top-Header-menu-->
        <div id="user-nav" class="navbar navbar-inverse">
            <ul class="nav">
                <li  class="dropdown" id="profile-messages" ><a title="" href="#" data-toggle="dropdown" data-target="#profile-messages" class="dropdown-toggle"><i class="icon icon-user"></i>  <span class="text">Welcome <%=(String) session.getAttribute("username")%> </span><b class="caret"></b></a>
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
                <li class="active"> <a href="GetEvents"><i class="icon icon-list-alt"></i> <span>Events</span></a> </li>
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
                <div id="breadcrumb"> <a href="index.jsp" title="Go to Home" class="tip-bottom"><i class="icon-home"></i> Home</a> <a href="#">Events</a> </div>
                <h1>Events</h1>
                <div class="container-fluid">
                    <hr>
                    <div id="publisherResult">

                    </div>
                    <div id="approvalRequired" class="row-fluid">
                        <div class="span12">
                            <div id="approvalRequired" class="widget-box">
                                <div class="widget-title"> <span class="icon">
                                        <input type="checkbox" id="title-checkbox" name="title-checkbox" onclick="checkAllEvents();"/>
                                    </span>
                                    <h5>Approval needed</h5>
                                </div>
                                <div class="widget-content nopadding">
                                    <table class="table table-bordered table-striped with-check">
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <th>id</th>
                                                <th>start_date</th>
                                                <th>start_time</th>
                                                <th>end_date</th>
                                                <th>end_time</th>
                                                <th>summary</th>
                                                <th>description</th>
                                                <th>location</th>
                                            </tr>
                                        </thead>
                                        <tbody id="approvalNeededTable">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <a href="#" class="btn btn-success btn" onclick="publishSelected();">Publish selected</a>
                                <a href="#" class="btn btn-danger btn" onclick="deleteSelected();">Delete selected</a>
                            </div>
                            <hr>
                            <h5> Filter Events</h5>
                            <div id="criteria" class="row-fluid">
                                <form name="myform" action="Filter" style="padding: 5px 0 0 0;">
                                    <% ResultSet rs = (ResultSet) request.getAttribute("Scriteria");%>
                                    <select id="summary">
                                        <option value="">Summary</option>
                                        <% while (rs.next()) {%>
                                        <option value=<%= rs.getString("summary")%>><%= rs.getString("summary")%> </option>
                                        <%}%>
                                    </select>
                                    <input type="hidden" id="critA" name="critA"value=""/>

                                    <% ResultSet rs1 = (ResultSet) request.getAttribute("Ccriteria");%>
                                    <select id="category">
                                        <option value="">Category</option>
                                        <% while (rs1.next() && rs1.getString("Category") != null) {%>
                                        <option value=<%= rs1.getString("Category")%>><%= rs1.getString("Category")%> </option>
                                        <%}%>
                                    </select>
                                    <input type="hidden" id="critB" name="critB"value=""/>
                                    <input type="submit" class="btn btn-info" value="Filter" onclick="fcriteria();" style="vertical-align: top;">
                                    <a href="GetEvents"><button type="button"  class="btn btn-info"style="vertical-align: top; margin-left:10px;"> Cancel </button> </a>
                                </form>

                            </div>
                        </div> 
                        <div id="allEvents" class="widget-box">
                            <div class="widget-title"> <span class="icon"><i class="icon-th"></i></span>
                                <h5>Events</h5>
                            </div>
                            <div class="widget-content nopadding">
                                <table class="table table-bordered data-table">
                                    <thead>
                                        <tr>
                                            <th>id</th>
                                            <th>start_date</th>
                                            <th>start_time</th>
                                            <th>end_date</th>
                                            <th>end_time</th>
                                            <th>summary</th>
                                            <th>description</th>
                                            <th>location</th>
                                            <th>isPublished</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% ResultSet resultSet = (ResultSet) request.getAttribute("events");%>
                                        <%while (resultSet.next()) {%>
                                        <tr class="gradeX">
                                            <td> <center><%= resultSet.getString("id")%></center></td>
                                    <td> <center><%= resultSet.getString("start_date")%></center></td>
                                    <td> <center><%= resultSet.getString("start_time")%></center></td>
                                    <td> <center><%= resultSet.getString("end_date")%></center></td>
                                    <td> <center><%= resultSet.getString("end_time")%></center></td>
                                    <td> <center><%= resultSet.getString("summary")%></center></td>
                                    <td> <center><%= resultSet.getString("description")%></center></td>
                                    <td> <center><%= resultSet.getString("location")%></center></td>
                                    <td> <center><%= resultSet.getString("isPublished")%></center></td>
                                    <td>
                                        <button type="button" class = "btn btn-danger btn-success" onclick="fopen(<%= resultSet.getString("id")%>)" id="myBtn"> Detail</button>
                                    </td>
                                    <td>
                                        <button type="button" class = "btn btn-danger btn-mini" onclick="unpublish(<%= resultSet.getString("id")%>)" id="myBtn"> Delete from calendar</button>
                                    </td>
                                    </tr>

                                    </tbody>
                                    <%}%>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div id="myModal" class="modal">
                <!-- Modal content -->
                <div class="modal-content" style="background-color:#b3daff">
                    <span class="close">×</span>
                    <center><h2>Detailed Event View</h2></center>
                    <form name="dform" action="submitback" >
                        <table>
                            <tr>
                            <input type="hidden" id="anID" name="anID">
                            <td class="align"><label>Start Date/Time:</label></td>
                            <td><input type="date" class="form-control margins" id="startdate" name="startdate"></td>
                            <td><input type="time" class="form-control margins" id="starttime" name="starttime"></td>
                            </tr>
                            <tr>
                                <td class="align"><label>End Date/Time:</label></td>
                                <td><input type="date" class="form-control margins" id="enddate" name="enddate"></td>
                                <td><input type="time" class="form-control margins" id="endtime" name="endtime"></td>
                            </tr>
                        </table>

                        <lable>Summary<input type="text" class="form-control margins" id="summary1" placeholder="Re-enter the summary/title CANT BE BLANK!! (BUG) " name="summary" maxlength="100" style="width:500px;"></lable><br>
                        <lable>Description<input type="text" class="form-control margins" id="description" name="description"  placeholder="Description (required - 100 character limit)" maxlength="100" style="width:500px;"></lable><br>
                        <lable>Location<input type="text" class="form-control margins" id="location" name="location" placeholder="Location" maxlength="100" style="width:500px;"></lable><br>
                        <div class="modal-footer" style="background-color:#b3daff">

                            <button type="submit" class="btn btn-primary btn-block">Submit</button>
                        </div>
                    </form>
                </div>
            </div>



            <!--End-breadcrumbs-->

            <!--Action boxes-->

            <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PAGE CODE GOES HERE@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->

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
                                              getApprovalNeededEvents();
                                              // This function is called from the pop-up menus to transfer to
                                              // a different page. Ignore if the value returned is a null string:
                                              
                                              unpublish(eventID); 
                                              //This is used to call the Google Calendar API to delete the event from the calendar and update the status in the DB to ispublished=3
                                              function goPage(newURL) {

                                                  // if url is empty, skip the menu dividers and reset the menu selection to default
                                                  if (newURL != "") {

                                                      // if url is "-", it is this page -- reset the menu:
                                                      if (newURL == "-") {
                                                          resetMenu();
                                                      }
                                                      // else, send page to designated URL
                                                      else {
                                                          document.location.href = newURL;
                                                      }
                                                  }
                                              }

                                              function fcriteria() {

                                                  var cr = document.getElementById("summary");
                                                  var sv = cr.options[cr.selectedIndex].value;
                                                  document.getElementById("critA").value = sv;

                                                  var cr = document.getElementById("category");
                                                  var sv1 = cr.options[cr.selectedIndex].value;
                                                  //alert(sv1);
                                                  document.getElementById("critB").value = sv1;
                                                  if (!(sv === "" && sv1 === ""))
                                                      myform.submit();
                                              }


                                              function fopen(theid) {
                                                  //var date = document.getElementById("dd").value 
                                                  document.getElementById("startdate").value = theid;
                                                  //document.getElementById("starttime").value = thetime; 
                                                  if (window.XMLHttpRequest) {
                                                      xmlhttp = new XMLHttpRequest();
                                                  } else {
                                                      xmlhttp = new ActiveXObject(Microsoft.XMLHTTP);
                                                  }
                                                  var url = "detailinfo?id=" + theid;
                                                  xmlhttp.open("GET", url, true);
                                                  xmlhttp.onreadystatechange = update;
                                                  xmlhttp.send();
                                              }
                                              function update() {
                                                  if (xmlhttp.readyState == 4) {
                                                      if (xmlhttp.status == 200) {
                                                          var rootNode = xmlhttp.responseXML.documentElement;
                                                          //start date
                                                          var startdateNode = rootNode.getElementsByTagName("startdate");
                                                          var startdate = startdateNode[0].firstChild.nodeValue;
                                                          document.getElementById("startdate").value = startdate;
                                                          //start time
                                                          var starttimeNode = rootNode.getElementsByTagName("starttime");
                                                          var starttime = starttimeNode[0].firstChild.nodeValue;
                                                          document.getElementById("starttime").value = starttime;
                                                          //end date
                                                          var enddateNode = rootNode.getElementsByTagName("enddate");
                                                          var enddate = enddateNode[0].firstChild.nodeValue;
                                                          document.getElementById("enddate").value = enddate;
                                                          //end time
                                                          var endtimeNode = rootNode.getElementsByTagName("endtime");
                                                          var endtime = endtimeNode[0].firstChild.nodeValue;
                                                          document.getElementById("endtime").value = endtime;

                                                          //summary
                                                          var summaryNode = rootNode.getElementsByTagName("summary");
                                                          var summary = summaryNode[0].firstChild.nodeValue;
                                                          document.getElementById("summary1").value = summary;
                                                           //alert(summary);

                                                          //description
                                                          var descriptionNode = rootNode.getElementsByTagName("description");
                                                          var description = descriptionNode[0].firstChild.nodeValue;
                                                          document.getElementById("description").value = description;

                                                          //location
                                                          var locationNode = rootNode.getElementsByTagName("location");
                                                          var location = locationNode[0].firstChild.nodeValue;
                                                          document.getElementById("location").value = location;


                                                          //id
                                                          var idNode = rootNode.getElementsByTagName("id");
                                                          var id = idNode[0].firstChild.nodeValue;
                                                          //alert(id);
                                                          document.getElementById("anID").value = id;
                                                          var modal = document.getElementById('myModal');
                                                          var span = document.getElementsByClassName("close")[0];
                                                          modal.style.display = "block";
                                                          // When the user clicks on <span> (x), close the modal
                                                          span.onclick = function () {
                                                              modal.style.display = "none";
                                                          }
                                                          // When the user clicks anywhere outside of the modal, close it
                                                          window.onclick = function (event) {
                                                              if (event.target == modal) {
                                                                  modal.style.display = "none";
                                                              }
                                                          }
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
