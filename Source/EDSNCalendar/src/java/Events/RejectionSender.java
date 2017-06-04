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
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.annotation.WebServlet;

/**
 *
 * @author Chris
 */
@WebServlet(urlPatterns = {"/RejectionSender"})
public class RejectionSender extends HttpServlet {

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
        
        try {
            String eventID = request.getParameter("eventID");
            
            if(eventID != null)
            {
                
                Class.forName(Settings.dbDriver);
                con= DriverManager.getConnection(Settings.dbURL,Settings.dbUsername,Settings.dbPass);
                //In the future this select query will bring the resultset with the offender's email for use in writing the rejection
                //For now, I'm hardcoding my own email for debug purposes
                
                ps=con.prepareStatement("select * from events where id=?");   
                int eventIDNum = Integer.parseInt(eventID.replaceAll("\\s+",""));
                ps.setInt(1,eventIDNum);
                
                rs=ps.executeQuery();
                rs.next();
                String senderEmail ="edsneventrejection@gmail.com"; //Password: QuickHugeCalendar    
                String senderPassword="QuickHugeCalendar";
                 //HARDCODED RECIPIENT EMAIL (ITS MINE)
                String recipientEmail= rs.getString("subEmail");
                //String recipientEmail="cmski77@yahoo.com";
                String emailSMTPserver = "smtp.gmail.com";
                String emailServerPort = "587";
                String host = "localhost"; //Sending from this computer
                
                String rejectionMessage= "Hello,\n"
                        + "You are recieving this message because the Event you submitted to the EDSN Community Calendar violated the terms of service, and consequently has not been published.\n"
                        + "You may try to submit your event again, or contact an administrator at XXXXXXXXX.\n"
                        + "-EDSN IT";
                
                Properties props = new Properties();
                props.put("mail.smtp.host",emailSMTPserver); //Startup the smtp server
                props.put("mail.smtp.user",senderEmail);
                props.put("mail.smtp.password", senderPassword);
                props.put("mail.smtp.auth","true");
                    
                props.put("mail.smtp.port",emailServerPort);
                props.put("mail.smtp.starttls.enable","true");
                props.put("mail.smtp.socketFactory.port",emailServerPort);
                props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
                
                
                SecurityManager security = System.getSecurityManager();
                
                
                
                Session session = Session.getInstance(props, 
                        new javax.mail.Authenticator(){
                            protected PasswordAuthentication getPasswordAuthentication(){
                                return new PasswordAuthentication(senderEmail,senderPassword);    
                            }
                        });
                
                MimeMessage message = new MimeMessage(session);
                
                message.setFrom(new InternetAddress(senderEmail));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
                message.setText(rejectionMessage);
                message.setSubject("Event Rejection");
                Transport.send(message);
                
                String successOutput = "<div class=\"alert alert-success\">\n"
                        + "<button class=\"close\" data-dismiss=\"alert\">x</button>\n"
                        + "<strong>Rejection Notice Sent to " + recipientEmail
                        + "</div>";
                out.println(successOutput);
                
                
                
            }
    } catch(Exception ex)
        {
            String errorOutput = "<div class=\"alert alert-error\">\n" +
                                    "<button class=\"close\" data-dismiss=\"alert\">x</button>\n" +
                                    "<strong>Error:</strong>\t\t\t" + ex.toString() +"\n" +
                                    "</div>";
            
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
