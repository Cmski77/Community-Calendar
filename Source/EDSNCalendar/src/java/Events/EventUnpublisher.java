/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Events;

import static Events.EventPublisher.getCalendarService;
import Settings.Settings;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Chris
 */
public class EventUnpublisher extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection con;
        PreparedStatement ps;
        ResultSet rs;
        String calendarId;
        PrintWriter out = response.getWriter();
        try {
            // Get the eventID and action out of parameters.
            // Action is either publish or delete.
            String eventID = request.getParameter("eventID");
            if (eventID != null) {
                Class.forName(Settings.dbDriver);
                con = DriverManager.getConnection(Settings.dbURL, Settings.dbUsername, Settings.dbPass);

                // Create a statement that will update the isPublished status of the specified event.
                int eventIDNum = Integer.parseInt(eventID.replaceAll("\\s+", ""));

                //Now query for the event we want to insert
                ps = con.prepareStatement("Select * from events where id=?");
                ps.setInt(1, eventIDNum);
                rs = ps.executeQuery();

                //<-------------------------------------------Calendar Interfacing Begins Here---------------------------------------------------------------->
                com.google.api.services.calendar.Calendar service = getCalendarService();
                rs.next();
                //Build the event
                String category = rs.getString("category");

                //Pick the right subcalendar based on the category:
                if (category.equalsIgnoreCase("education")) {
                    calendarId = "1b0fgl15no2em0s761g3nmsojk@group.calendar.google.com";
                } else if (category.equalsIgnoreCase("religion")) {
                    calendarId = "drcg5o2lrknp529espcaerom6g@group.calendar.google.com";
                } else if (category.equalsIgnoreCase("sport")) {
                    calendarId = "b9vn1j2c33h3t0q8rlhmq1tn9s@group.calendar.google.com";
                } else if (category.equalsIgnoreCase("music")) {
                    calendarId = "drcg5o2lrknp529espcaerom6g@group.calendar.google.com";
                } else {
                    return;
                }
                
                service.events().delete(calendarId, rs.getString("id") + "abc").execute();

                ps = con.prepareStatement("UPDATE events SET isPublished=? where id=?");

                ps.setInt(1, 3); // 3 = silent delete (still in db, just not shown)
                ps.setInt(2, eventIDNum);

                if (ps.executeUpdate() == 1) {
                    String successOutput = "<div class=\"alert alert-success\">\n"
                            + "<button class=\"close\" data-dismiss=\"alert\">x</button>\n"
                            + "<strong>Event successfully unpublished from calendar"
                            + "</div>";
                    out.println(successOutput);
                }
                //<-------------------------------Calendar Interfacing Ends Here-------------------------------------------------------------------------------->

                //request.setAttribute("eventToInsert",rs);
                //request.getRequestDispatcher("CalendarInsert").forward(request,response);
            }

        } catch (Exception ex) {
            // In case an error occurs, an alert will be created stating the error.
            String errorOutput = "<div class=\"alert alert-error\">\n"
                    + "<button class=\"close\" data-dismiss=\"alert\">x</button>\n"
                    + "<strong>Error:</strong>\t\t\t" + ex.toString() + "\n"
                    + "</div>";

            out.println(errorOutput);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
