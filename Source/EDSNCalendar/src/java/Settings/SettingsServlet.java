/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Settings;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author gotoel
 */
@WebServlet(name = "SettingsServlet", urlPatterns = {"/Settings"})
public class SettingsServlet extends HttpServlet {

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
        String requestAction = request.getParameter("requestAction");
        PrintWriter out = response.getWriter();
        try {
            if(requestAction != null) 
            {
                String settingsType = "";
                if(requestAction.equals("setDatabaseSettings"))
                {
                    settingsType = "Database";
                    Settings.dbURL = request.getParameter("databaseURL");
                    Settings.dbDriver = request.getParameter("databaseDriver");
                    Settings.dbUsername = request.getParameter("databaseUsername");
                    Settings.dbPass = request.getParameter("databasePassword");

                    Settings.getInstance().Save();
                }
                else if(requestAction.equals("setGoogleCalendarSettings"))
                {
                    settingsType = "Google calendar";
                    Settings.applicationName = request.getParameter("applicationName");
                    Settings.calendarID = request.getParameter("calendarID");
                    Settings.dataStoreFile = request.getParameter("dataStoreFile");
                    Settings.credentialsFile = request.getParameter("credentialsFile");

                    Settings.getInstance().Save();
                }
                String successOutput = "<div class=\"alert alert-success\">\n"
                    + "<button class=\"close\" data-dismiss=\"alert\">x</button>\n"
                    + "<strong>Success:</strong>\t\t\t" + settingsType + " settings saved successfully!"
                    + "</div>";
                
                request.setAttribute("result", successOutput);
            }

            // Default is to get settings.
            Settings.getInstance().Load();
            request.setAttribute("dbURL", Settings.dbURL);
            request.setAttribute("dbDriver", Settings.dbDriver);
            request.setAttribute("dbUsername", Settings.dbUsername);
            request.setAttribute("dbPass", Settings.dbPass);

            request.setAttribute("applicationName", Settings.applicationName);
            request.setAttribute("calendarID", Settings.calendarID);
            request.setAttribute("dataStoreFile", Settings.dataStoreFile);
            request.setAttribute("credentialsFile", Settings.credentialsFile);
        }
        catch(Exception ex)
        {
            // In case an error occurs, an alert will be created stating the error.
            String errorOutput = "<div class=\"alert alert-error\">\n"
                    + "<button class=\"close\" data-dismiss=\"alert\">x</button>\n"
                    + "<strong>Error:</strong>\t\t\t" + ex.toString() + "\n"
                    + "</div>";

            request.setAttribute("result", errorOutput);
        }
        
        request.getRequestDispatcher("settings.jsp").forward(request, response);
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
