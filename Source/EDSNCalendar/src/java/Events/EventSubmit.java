package Events;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import Settings.Settings;
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

/**
 *
 * @author TOMEK
 */

@WebServlet(urlPatterns = {"/EventSubmit"})
public class EventSubmit extends HttpServlet {

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
        PrintWriter out = response.getWriter();
        try  {
            String strDate = request.getParameter("strdate");
            String strTime = request.getParameter("strtime");
            String endDate = request.getParameter("enddate");
            String endTime = request.getParameter("endtime");
            String summary = request.getParameter("title");
            String descrpt = request.getParameter("description");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String zipCode = request.getParameter("zip");
            String category = request.getParameter("categories");
            String subName = request.getParameter("fullName");
            String subEmail = request.getParameter("email");
            String location = address + ", " + city + " " + state + ", " + zipCode;
            Class.forName(Settings.dbDriver);
            con = DriverManager.getConnection(Settings.dbURL,Settings.dbUsername,Settings.dbPass);
            ps = con.prepareStatement("insert into events (ID,start_date,start_time,end_date,end_time,summary,description,location,ispublished,category,subName,subEmail) values (null,?,?,?,?,?,?,?,0,?,?,?)");
            ps.setString(1, strDate);
            ps.setString(2, strTime);
            ps.setString(3, endDate);
            ps.setString(4, endTime);
            ps.setString(5, summary);
            ps.setString(6, descrpt);
            ps.setString(7, location);
            ps.setString(8, category);
            ps.setString(9, subName);
            ps.setString(10, subEmail);
            ps.executeUpdate();
            ps.close();
            con.close();
            response.sendRedirect("frontpage.jsp");
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
