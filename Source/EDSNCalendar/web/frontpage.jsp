<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html lang="en">
<head>
  <title>EDSN Calendar</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="css/frontstyle.css" type="text/css"/>
</head>

<body>
  <div class="align">
    <img src="img/edsnlogo.jpg">   
  </div>    
    
    
  <!-- pop up modal for adding new events -->
  <div class="container">
    <div class="align">
      <button type="button" class="btn btn-primary btn-md paddin" data-toggle="modal" data-target="#myModal">
      <span class="glyphicon glyphicon-plus" aria-hidden="true"></span> ADD EVENT</button>
    </div>
      <div class="modal fade" id="myModal" role="dialog">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal">&times;</button>
              <h4 class="modal-title">POST YOUR EVENT</h4>
            </div>
              <div></div>
            <div class="modal-body">
              <form action="EventSubmit" method="POST">
                <input type="text" class="form-control margins" name="fullName" maxlength="50" required placeholder="Your full name (required)">
                <input type="text" class="form-control margins" name="email" maxlength="50" required placeholder="Your email (required)">
                <input type="text" class="form-control margins" name="title" maxlength="50" required placeholder="Event title (required)">
                <input type="text" class="form-control margins" name="address" maxlength="80" required placeholder="Address (required)">
                <input type="text" class="form-control margins" name="city" maxlength="20" required placeholder="City (required)">
                <input type="text" class="form-control margins" name="state" maxlength="2" required placeholder="State (required)">
                <input type="text" class="form-control margins" name="zip" maxlength="5" required placeholder="Zip Code (required)">
                <label>&emsp;Select category:</label>
                <select required name="categories">
                    <option value="Education">Education</option>
                    <option value="Music">Music</option>
                    <option value="Religion">Religion</option>
                    <option value="Sport">Sport</option>
                </select>
                <table>
                  <tr>
                    <td class="align"><label>&emsp;Start Date/Time:</label></td>
                    <td><input type="date" class="form-control margins" name="strdate" required placeholder="yyyy-mm-dd"></td>
                    <td><input type="time" class="form-control margins" name="strtime" required placeholder="HH:MM:SS"></td>
                  </tr>
                  <tr>
                    <td class="align"><label>&emsp;End Date/Time:</label></td>
                    <td><input type="date" class="form-control margins" name="enddate" required placeholder="yyyy-mm-dd"></td>
                    <td><input type="time" class="form-control margins" name="endtime" required placeholder="HH:MM:SS"></td>
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
  <!--<a href="CalendarInsert"><i class="icon icon-list-alt"></i> <span>Debug event insertion</span></a>-->
  <div id="myCalendar" class="align" >
     <iframe src="https://calendar.google.com/calendar/embed?showTitle=0&amp;height=900&amp;wkst=1&amp;bgcolor=%23ffffff&amp;src=1b0fgl15no2em0s761g3nmsojk%40group.calendar.google.com&amp;color=%23125A12&amp;src=drcg5o2lrknp529espcaerom6g%40group.calendar.google.com&amp;color=%23B1365F&amp;src=4lc9vqncnpcs7l6j8v8fmi9k4o%40group.calendar.google.com&amp;color=%2323164E&amp;src=b9vn1j2c33h3t0q8rlhmq1tn9s%40group.calendar.google.com&amp;color=%238C500B&amp;ctz=America%2FNew_York" style="border-width:0" width="1600" height="900" frameborder="0" scrolling="no"></iframe>
  </div>
</body>
</html>
