package Events;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import static Events.EventPublisher.getCalendarService;
import com.google.api.services.calendar.model.Event;
import Settings.Settings;
import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.model.EventDateTime;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.ResultSet;
/**
 *
 * @author TOMEK
 */

@WebServlet(urlPatterns = {"/submitback"})
public class SubmitBack extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        Connection con;
        PreparedStatement ps;
        ResultSet rs;
        PrintWriter out = response.getWriter();
        try  {
            String strDate = request.getParameter("startdate");
            //strDate.replaceAll("\\s","");
            String strTime = request.getParameter("starttime");
            //strTime.replaceAll("\\s","");
            String endDate = request.getParameter("enddate");
            String endTime = request.getParameter("endtime");
            String descrpt = request.getParameter("description");
            String location = request.getParameter("location");
            String summary = request.getParameter("summary");
            Integer id = Integer.parseInt(request.getParameter("anID"));
            Class.forName(Settings.dbDriver);
            con = DriverManager.getConnection(Settings.dbURL,Settings.dbUsername,Settings.dbPass);

            ps = con.prepareStatement("update events set start_date =?, start_time=?, end_date=?, end_time=?, description=?, location=?, summary=? WHERE id=?");
            ps.setString(1, strDate);
            ps.setString(2, strTime);
            ps.setString(3, endDate);
            ps.setString(4, endTime);
            ps.setString(5, descrpt);
            ps.setString(6, location);
            ps.setString(7, summary);
            ps.setInt(8, id);
            ps.executeUpdate();
            //ps.close();
            
            ps = con.prepareStatement("Select * from events where id=?");
            ps.setString(1,request.getParameter("anID"));
            rs=ps.executeQuery();
            //ps.close();
            //con.close();
            rs.next();
            String category = rs.getString("category");
            String calendarId;
            
            
            //Initialize google calendar 
            com.google.api.services.calendar.Calendar service = getCalendarService();
            if(category.equalsIgnoreCase("education"))
                        calendarId="1b0fgl15no2em0s761g3nmsojk@group.calendar.google.com";
                    else if (category.equalsIgnoreCase("religion"))
                        calendarId="drcg5o2lrknp529espcaerom6g@group.calendar.google.com";
                    else if (category.equalsIgnoreCase("sport"))
                        calendarId="b9vn1j2c33h3t0q8rlhmq1tn9s@group.calendar.google.com";
                    else if (category.equalsIgnoreCase("music"))
                        calendarId="drcg5o2lrknp529espcaerom6g@group.calendar.google.com";
                    else
                        return;
            
            Event event = service.events().get(calendarId,request.getParameter("anID")+"abc").execute(); //The eventID is just the id from db with "abc" appended
            
            event.setLocation(location);
            event.setDescription(descrpt);
            event.setSummary(summary);
                    DateTime startDateTime = new DateTime(strDate+"T"+strTime+"-05:00");
                    EventDateTime start = new EventDateTime()
                            .setDateTime(startDateTime)
                            .setTimeZone("America/New_York");
                    event.setStart(start);

                   DateTime endDateTime = new DateTime(endDate+"T"+endTime+"-05:00");
                    EventDateTime end = new EventDateTime()
                            .setDateTime(endDateTime)
                            .setTimeZone("America/New_York");
                    out.println("Right before setting endDateTime");
                    event.setEnd(end);
                    
                    Event updatedEvent = service.events().update(calendarId,event.getId(),event).execute();
                    
            response.sendRedirect("GetEvents");
            
        } catch (Exception e) {
            out.println("Exception occured " + e.getMessage());
            e.printStackTrace();
        } finally{
            out.close();
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
