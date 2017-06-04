package Events;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import Settings.Settings;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.SQLException;

/**
 *
 * @author pc
 */
@WebServlet(urlPatterns = {"/Filter"})
public class Filter extends HttpServlet {

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
         Connection conn;
         ResultSet rs,rsS,rsC;
         PreparedStatement ps;
        try (PrintWriter out = response.getWriter()) {
            Class.forName(Settings.dbDriver);
            conn= DriverManager.getConnection(Settings.dbURL,Settings.dbUsername,Settings.dbPass);
            String critA = request.getParameter("critA");
            String critB = request.getParameter("critB");
            //crit = "pool";
            if(!(critA.isEmpty()) || !(critB.isEmpty())){
             if (critA.isEmpty() && !(critB.isEmpty())){
                ps = conn.prepareStatement("Select * from events where Category=?");
                ps.setString(1,critB);
                rs = ps.executeQuery();
                request.setAttribute("events", rs);
            }
            else if(!(critA.isEmpty())&& critB.isEmpty()){
                ps = conn.prepareStatement("Select * from events where summary like?");
                ps.setString(1,critA + "%");
                rs = ps.executeQuery();
                request.setAttribute("events", rs);
            }
            else if(!(critA).isEmpty() && !(critB.isEmpty())){
                ps = conn.prepareStatement("Select * from events where summary like ? and Category = ?");
                ps.setString(1,critA + "%");
                ps.setString(2,critB);
                rs = ps.executeQuery();
                request.setAttribute("events", rs);
            }
            
            //rs = ps.executeQuery();
            
            ps = conn.prepareStatement("select * from events");
            rsS = ps.executeQuery(); //summary
            request.setAttribute("Scriteria", rsS);
            ps = conn.prepareStatement("select * from events");
            rsC = ps.executeQuery(); //category
            request.setAttribute("Ccriteria", rsC);
            request.getRequestDispatcher("Tables.jsp").forward(request,response);
          }
        }
        
          catch (SQLException | ClassNotFoundException ex) 
            {
                System.out.println("Failure");
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
