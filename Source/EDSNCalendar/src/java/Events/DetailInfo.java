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
@WebServlet(urlPatterns = {"/detailinfo"})
public class DetailInfo extends HttpServlet {

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
       response.setContentType("text/xml;charset=UTF-8");
       PrintWriter out = response.getWriter();
       Connection con;
        PreparedStatement ps;
        ResultSet rs;      
        try 
            {
                Class.forName(Settings.dbDriver);
                con= DriverManager.getConnection(Settings.dbURL,Settings.dbUsername,Settings.dbPass);
                ps=con.prepareStatement("select * from events where id=?");
                int id = Integer.parseInt(request.getParameter("id"));
                ps.setInt(1, id);
                rs=ps.executeQuery();
                rs.next();
                String str = "";
                str += "<data>\n";
                str +="<id>" + rs.getInt("id") + "</id>";
                str += "<startdate>" + rs.getString("start_date") + "</startdate>\n";
                str += "<starttime>" + rs.getString("start_time") + "</starttime>\n";
                str += "<enddate>" + rs.getString("end_date") + "</enddate>\n";
                str += "<endtime>" + rs.getString("end_time") + "</endtime>\n";
                str += "<summary>" + rs.getString("summary") + "</summary>\n";
                str += "<description>" + rs.getString("description") + "</description>\n";
                str += "<location>" + rs.getString("location") + "</location>";
                str += "</data>\n";
                
                out.println(str);
                
                 out.close();
                 //rs.close(); 
                 //ps.close();
                 //con.close();

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
