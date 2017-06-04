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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author gotoel
 */
@WebServlet(urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    /*
    
    Processes a login request.
    Access levels:
    0 - No access.
    1 - View access
    2 - View and some editing access (ability to edit events)
    3 - View and some more editing access (ability to edit events+users)
    4 - Full access.
    
    Two session attributes:
    username: Logged in user's username.
    access_level: Logged in user's access level.
    
    */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        Connection con;
        PreparedStatement ps;
        ResultSet rs; 
        try (PrintWriter out = response.getWriter()) {
            try {
            // Initialize DB stuff
            Class.forName(Settings.dbDriver);
            con = DriverManager.getConnection(Settings.dbURL,Settings.dbUsername,Settings.dbPass);
            String username = request.getParameter("username");
            String plaintextPassword = request.getParameter("password");
            MessageDigest md = MessageDigest.getInstance("MD5");

            //Add password bytes to digest
            md.update(plaintextPassword.getBytes());

            //Get the hash's bytes 
            byte[] bytes = md.digest();

            //This bytes[] has bytes in decimal format;
            //Convert it to hexadecimal format
            StringBuilder sb = new StringBuilder();
            for(int i=0; i< bytes.length ;i++)
            {
                sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
            }

            //Get complete hashed password in hex format
            String hashedPassword = sb.toString();

            // Create a statement that will update the isPublished status of the specified event.
            ps = con.prepareStatement("select password from users where username=?");
            ps.setString(1, username);

            rs = ps.executeQuery();
            if(!rs.next())
            {
                // We got no records for that username, bad username.
                sendBadLoginMsg(request, response);
            }
            
            // Check if password hash matches DB pass hash.
            if(!rs.getString("password").isEmpty() && 
                    !hashedPassword.isEmpty() &&
                    rs.getString("password").equals(hashedPassword))
            {
                // If you're in here, successful login. Hopefully.
                
                // Now we need to get the user's access level.
                ps = con.prepareStatement("select access_level from users where username=?");
                ps.setString(1, username);
                
                rs = ps.executeQuery();
                
                if(!rs.next())
                {
                    // Shouldn't happen, but if we get no record.
                    sendBadAccessMsg(request, response);
                }
                
                // Pull the access level from the returned recordset.
                int accessLevel = rs.getInt("access_level");
                
                if(accessLevel > 0) {
                    // Set appropriate sessiona ttributes
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("access_level", accessLevel);

                    // Forward user to the dashboard. May need to make JSP for more control later.
                    request.getRequestDispatcher("/index.jsp").forward(request, response);
                }
                else
                {
                    // User doesn't have any access in the system, inform them.
                    sendBadAccessMsg(request, response);
                }
            }
            else
            {
                // Password doesn't match.
                sendBadLoginMsg(request, response);
            }
            } catch(Exception ex)
            {
                out.write(ex.toString());
            }
            
        } catch(Exception ex)
        {
            
        }
    }
    
    private void sendBadLoginMsg(HttpServletRequest request, HttpServletResponse response)
    {
        try {
            request.setAttribute("msgHTML", "<div style=\"color: #FF0000;\">Invalid username or password...</div>");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch(Exception ex)
        {

        }
    }
    
    private void sendBadAccessMsg(HttpServletRequest request, HttpServletResponse response)
    {
        try {
            request.setAttribute("msgHTML", "<div style=\"color: #FF0000;\">You are not authorized to log into this system...</div>");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch(Exception ex)
        {

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
