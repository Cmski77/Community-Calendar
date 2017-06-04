package Events;


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
 * @author Chris
 */
@WebServlet(urlPatterns = {"/GetUnpublishedEvents"})
public class GetUnpublishedEvents extends HttpServlet {
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
        
        // Get the request action from the POST (either a list of events is returned of an amount of 
        // events.
        String requestAction = request.getParameter("requestAction");
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");
        Connection con;
        PreparedStatement ps;
        ResultSet rs;      
        try 
        {
            Class.forName(Settings.dbDriver);
            con= DriverManager.getConnection(Settings.dbURL,Settings.dbUsername,Settings.dbPass);
            // Get a result set of all unpublished events, so where isPublished is set to 0.
            ps=con.prepareStatement("select * from events where isPublished=0", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs=ps.executeQuery();

            String outString = "";
            
            if(requestAction.equals("eventsList")) {
                // Loop through the result set and build the HTML table rows w/ data.
                while(rs.next()){
                    outString += "<tr class=\"gradeX\">\n";
                    outString += "\t<td><input type=\"checkbox\" /></td>\n";
                    outString += "\t<td> <center>" + rs.getString("id") + "</center></td>\n";
                    outString += "\t<td> <center>" + rs.getString("start_date") + "</center></td>\n";
                    outString += "\t<td> <center>" + rs.getString("start_time") + "</center></td>\n";
                    outString += "\t<td> <center>" + rs.getString("end_date") + "</center></td>\n";
                    outString += "\t<td> <center>" + rs.getString("end_time") + "</center></td>\n";
                    outString += "\t<td> <center>" + rs.getString("summary") + "</center></td>\n";
                    outString += "\t<td> <center>" + rs.getString("description") + "</center></td>\n";
                    outString += "\t<td> <center>" + rs.getString("location") + "</center></td>\n";
                    
                    // Add the 'publish' and 'delete' buttons to the last column
                    // these will contain the javascript calls for the appropriate actions.
                    outString += "\t<td>\n" +
                                      "\t\t<center>\n" +
                                          "\t\t\t<a href=\"#\" class=\"btn btn-success btn-mini\" onclick=\"executePublishAction(" + rs.getString("id") + ",\'publish\');\">Publish</a> \n" +
                                          "\t\t\t<a href=\"#\" class=\"btn btn-danger btn-mini\" onclick=\"executePublishAction(" + rs.getString("id") + ",\'delete\');\">Delete</a>\n" +
                                          "\t\t\t<a href=\"#\" class=\"btn btn-danger btn-mini\" onclick=\"sendMail(" + rs.getString("id") + ");\">Send Rejection Notice</a>\n" +
                                      "\t\t</center>\n" +
                                  "\t</td>";
                    outString += "</tr>\n";
                }
            }
            else if(requestAction.equals("eventsCount"))
            {
                // If we just want to get the little number popup on the dashbored for unapproved events, we can just
                // go to the last result in the result set and get the row number.
                if(rs.last()){
                    outString = "<span class=\"label label-important\" id=\"unapprovedCount\">" + rs.getRow()+ "</span>"; 
                }
            }
            
            // Print out the resulting HTML.
            out.println(outString);
            
            con.close();
            ps.close();
            rs.close();
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
    } // </editor-fold>
}




