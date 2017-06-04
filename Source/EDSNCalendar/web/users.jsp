<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>EDSN Calendar - Users</title>
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
            if (request.getSession().getAttribute("username") == null
                    || ((String) request.getSession().getAttribute("username")).isEmpty()) {
                response.sendRedirect("login.jsp");
            }
        %>
        <!--Header-part-->
        <div id="header">
            <h1><a href="dashboard.jsp">Users</a></h1>
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
                <li> <a href="GetEvents"><i class="icon icon-list-alt"></i> <span>Events</span></a> </li>
                <li><a href="Settings"><i class="icon icon-wrench"></i> <span>Settings</span></a></li>
                <li class="active"><a href="GetUsers"><i class="icon icon-user"></i> <span>Users</span></a></li>
                <li><a href="widgetcreator.jsp"><i class="icon icon-pencil"></i> <span>Widget Creator</span></a></li>
            </ul>
        </div>
        <!--sidebar-menu-->

        <!--main-container-part-->
        <div id="content">
            <!--breadcrumbs-->
            <div id="content-header">
                <div id="breadcrumb"> <a href="index.jsp" title="Go to Home" class="tip-bottom"><i class="icon-home"></i> Home</a> <a href="#">Users</a> </div>
                <h1>Create User</h1>
                <div class="container-fluid">
                    <div class="widget-content nopadding">
                        <form action="UserInsert" method="POST">
                            <table>
                                <tr>
                                    <td><input type="text" name="username" required maxlength="30" placeholder="Username"/></td>
                                </tr>
                                <tr>
                                    <td><input type="password" name="password" required maxlength="20" placeholder="Password"/></td>
                                </tr>
                                <tr>
                                    <td><input type="password" required maxlength="20" placeholder="Confirm Password"/></td>
                                </tr>
                                <tr>
                                    <td>
                                        <select required name="accessLvl">
                                            <option value="1" selected>View access only</option>
                                            <option value="2">View with event edit</option>
                                            <option value="3">View with event & user edit</option>
                                            <option value="4">Full access</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><center><input type="submit" value="Create User"/></center></td>
                                </tr>      
                            </table></br>
                        </form>
                    </div>
                    <div id="allUsers" class="widget-box">
                        <div class="widget-title"> <span class="icon"><i class="icon-th"></i></span>
                            <h5>Users</h5>
                        </div>
                        <div class="widget-content nopadding">
                            <table class="table table-bordered data-table">
                                <thead>
                                    <tr>
                                        <th>id</th>
                                        <th>username</th>
                                        <th>access level</th>
                                        <th>roles</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% ResultSet resultSet = (ResultSet) request.getAttribute("users");%>
                                    <%while (resultSet.next()) {%>
                                    <tr class="gradeX">
                                        <td> <center><%= resultSet.getString("id")%></center></td>
                                <td> <center><%= resultSet.getString("username")%></center></td>
                                <td> <center><%= resultSet.getString("access_level")%></center></td>
                                <td><input type="checkbox" name="view" disabled="disabled" checked> View Only
                                    <input type="checkbox" name="eEvent" disabled="disabled" <% if (resultSet.getInt("access_level") >= 2) {
                                            out.print("checked=\"checked\"");
                                        }%>> Edit Events
                                    <input type="checkbox" name="eUsers" disabled="disabled" <% if (resultSet.getInt("access_level") >= 3) {
                                            out.print("checked=\"checked\"");
                                        }%>> Edit Users
                                    <input type="checkbox" name="allAccess" disabled="disabled" <% if (resultSet.getInt("access_level") == 4) {
                                            out.print("checked=\"checked\"");
                                        }%>> Full Access</td>
                                </tr>
                                <%}%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
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

        <script type="text/javascript">
            // This function is called from the pop-up menus to transfer to
            // a different page. Ignore if the value returned is a null string:
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

            // resets the menu selection upon entry to this page:
            function resetMenu() {
                document.gomenu.selector.selectedIndex = 2;
            }
        </script>
    </body>
</html>
