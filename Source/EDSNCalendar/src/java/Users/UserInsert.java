package Users;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import Settings.Settings;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;

/**
 *
 * @author TOMEK
 */
@WebServlet(urlPatterns = {"/UserInsert"})
public class UserInsert extends HttpServlet {

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
        try {
            Class.forName(Settings.dbDriver);
            con = DriverManager.getConnection(Settings.dbURL, Settings.dbUsername, Settings.dbPass);
            String userName = request.getParameter("username");
            String plainPwd = request.getParameter("password");
            int accessLvl = Integer.parseInt(request.getParameter("accessLvl"));
            MessageDigest md = MessageDigest.getInstance("MD5");

            md.update(plainPwd.getBytes());
            byte[] bytes = md.digest();
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < bytes.length; i++) {
                sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
            }
            String hashPwd = sb.toString();
            
            ps = con.prepareStatement("insert into users (id,username,password,access_level) values (null,?,?,?)");
            ps.setString(1, userName);
            ps.setString(2, hashPwd);
            ps.setInt(3, accessLvl);
            ps.executeUpdate();
            ps.close();
            con.close();
            response.sendRedirect("GetUsers");
        } catch(Exception ex){
                out.write(ex.toString());
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
