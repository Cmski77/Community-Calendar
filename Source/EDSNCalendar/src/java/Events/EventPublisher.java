package Events;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//
import Settings.Settings;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.calendar.CalendarScopes;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventDateTime;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author gotoel , Chris
 */
@WebServlet(urlPatterns = {"/EventPublisher"})
public class EventPublisher extends HttpServlet {

    //<--------------Google Calendar instance variables and methods begin here----------------->
    private static final String APPLICATION_NAME
            = Settings.applicationName;
    
    //Directory to store user credentials for this application.
    private static final java.io.File DATA_STORE_DIR = new java.io.File(
            System.getProperty("user.home"), Settings.dataStoreFile);

    //Global instance of the {@link FileDataStoreFactory}.
    private static FileDataStoreFactory DATA_STORE_FACTORY;


     //Global instance of the JSON factory.
    private static final JsonFactory JSON_FACTORY
            = JacksonFactory.getDefaultInstance();


     //Global instance of the HTTP transport.
    private static HttpTransport HTTP_TRANSPORT;

    private static final List<String> SCOPES
            = Arrays.asList(CalendarScopes.CALENDAR);

    static {
        try {
            HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
            DATA_STORE_FACTORY = new FileDataStoreFactory(DATA_STORE_DIR);
        } catch (Throwable t) {
            t.printStackTrace();
            System.exit(1);
        }
    } 
     //Creates an authorized Credential object.
    public static Credential authorize() throws IOException {
        // Load client secrets.
        InputStream in
                = EventPublisher.class.getResourceAsStream(Settings.credentialsFile);
        GoogleClientSecrets clientSecrets
                = GoogleClientSecrets.load(JSON_FACTORY, new InputStreamReader(in));

        // Build flow and trigger user authorization request.
        GoogleAuthorizationCodeFlow flow
                = new GoogleAuthorizationCodeFlow.Builder(
                        HTTP_TRANSPORT, JSON_FACTORY, clientSecrets, SCOPES)
                        .setDataStoreFactory(DATA_STORE_FACTORY)
                        .setAccessType("offline")
                        .build();
        Credential credential = new AuthorizationCodeInstalledApp(
                flow, new LocalServerReceiver.Builder().setPort(9089).build()).authorize("user");
        System.out.println(
                "Credentials saved to " + DATA_STORE_DIR.getAbsolutePath());
        return credential;
    }

     //Build and return an authorized Calendar client service.
    public static com.google.api.services.calendar.Calendar
            getCalendarService() throws IOException {
        Credential credential = authorize();
        return new com.google.api.services.calendar.Calendar.Builder(
                HTTP_TRANSPORT, JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME)
                .build();
    }
    //<---------------------Calendar instance variables and methods end --------------------------------------->

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
            String action = request.getParameter("action");

            if (eventID != null) {
                Class.forName(Settings.dbDriver);
                con = DriverManager.getConnection(Settings.dbURL, Settings.dbUsername, Settings.dbPass);

                // Create a statement that will update the isPublished status of the specified event.
                ps = con.prepareStatement("UPDATE events SET isPublished=? where id=?");
                int eventIDNum = Integer.parseInt(eventID.replaceAll("\\s+", ""));

                // Set the statement variables appropriately based on action.
                if (action.equals("publish")) {
                    ps.setInt(1, 1); // 1 = published
                    ps.setInt(2, eventIDNum);
                } else if (action.equals("delete")) {
                    ps.setInt(1, 3); // 3 = silent delete (still in db, just not shown)
                    ps.setInt(2, eventIDNum);
                }

                // Execute the update and create a little alert that states that the action succeeded.
                if (ps.executeUpdate() == 1) {
                    String successOutput = "<div class=\"alert alert-success\">\n"
                            + "<button class=\"close\" data-dismiss=\"alert\">x</button>\n"
                            + "<strong>Success:</strong>\t\t\tEvent(s) "
                            + (action.equals("publish") ? "published." : " deleted.") + "\n"
                            + "</div>";
                    out.println(successOutput);

                    //Now query for the event we want to insert
                    ps = con.prepareStatement("Select * from events where id=?");
                    ps.setInt(1, eventIDNum);
                    rs = ps.executeQuery();

                    //<-------------------------------------------Calendar Interfacing Begins Here---------------------------------------------------------------->
                    if(action.equals("delete") == false)
                    {
                    com.google.api.services.calendar.Calendar service = getCalendarService();
                    rs.next();
                    //Build the event
                    String category= rs.getString("category");
                    Event event = new Event()
                            .setSummary(rs.getString("summary"))
                            .setLocation(rs.getString("location"))
                            .setDescription(rs.getString("description"))
                            .setId((rs.getString("id"))+"abc"); //An event's ID is just the id from the db+"abc" appended to it
                    DateTime startDateTime = new DateTime(rs.getString("start_date")+"T"+rs.getString("start_time")+"-05:00");
                    //DateTime startDateTime = new DateTime("2016-11-11T09:00:00-07:00");
                    
                    EventDateTime start = new EventDateTime()
                            .setDateTime(startDateTime)
                            .setTimeZone("America/New_York");

                    event.setStart(start);
                    DateTime endDateTime = new DateTime(rs.getString("end_date")+"T"+rs.getString("end_time")+"-05:00");
                    //DateTime endDateTime = new DateTime("2016-11-11T17:00:00-07:00");
                    EventDateTime end = new EventDateTime()
                            .setDateTime(endDateTime)
                            .setTimeZone("America/New_York");
                    event.setEnd(end);
                    
                    
                    if(category.equalsIgnoreCase("education"))
                        calendarId="1b0fgl15no2em0s761g3nmsojk@group.calendar.google.com";
                    else if (category.equalsIgnoreCase("religion"))
                        calendarId="drcg5o2lrknp529espcaerom6g@group.calendar.google.com";
                    else if (category.equalsIgnoreCase("sport"))
                        calendarId="b9vn1j2c33h3t0q8rlhmq1tn9s@group.calendar.google.com";
                    else if (category.equalsIgnoreCase("music"))
                        calendarId="drcg5o2lrknp529espcaerom6g@group.calendar.google.com";
                    else
                        calendarId = "l0u6k0e8s4i26sgpoh68g9e2io@group.calendar.google.com";
                    //String EduCal= "1b0fgl15no2em0s761g3nmsojk@group.calendar.google.com";
                    //String ReligionCal= "drcg5o2lrknp529espcaerom6g@group.calendar.google.com";
                    //String SportCal= "b9vn1j2c33h3t0q8rlhmq1tn9s@group.calendar.google.com";
                    //String MusicCal= "drcg5o2lrknp529espcaerom6g@group.calendar.google.com";
                    //String calendarId = "l0u6k0e8s4i26sgpoh68g9e2io@group.calendar.google.com";
                    
                    
                    event = service.events().insert(calendarId, event).execute();
                    }
                    //<-------------------------------Calendar Interfacing Ends Here-------------------------------------------------------------------------------->
                    
                    //request.setAttribute("eventToInsert",rs);
                    //request.getRequestDispatcher("CalendarInsert").forward(request,response);
                }
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
