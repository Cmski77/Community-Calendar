package Settings;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;

/*
 * Settings are stored to a server path to a file called config.properties. 
 * idk where it is... but the user will.
 */

/**
 *
 * @author gotoel
 */
public class Settings {
    // Database settings
    public static String dbURL = "jdbc:mysql://149.56.12.59:3306/cs410?zeroDateTimeBehavior=convertToNull";
    public static String dbDriver = "com.mysql.jdbc.Driver";
    public static String dbUsername = "cs410";
    public static String dbPass = "db123";
    
    // Google calendar settings
    public static String applicationName = "258158693641-vjfjotncl9l4spi4j3h380je3kp31hvo.apps.googleusercontent.com";
    public static String calendarID = "l0u6k0e8s4i26sgpoh68g9e2io@group.calendar.google.com";
    public static String dataStoreFile = ".credentials/calendar-java-quickstart";
    public static String credentialsFile = "/client_secret.json";
    
    private static Settings instance = null;
    
    protected Settings() {
        try {
            File f = new File("config.properties");
            if(!f.exists()) {
                f.createNewFile();
                java.awt.Desktop.getDesktop().edit(f);
            }else
            {
                Load();
            }
        } catch (IOException ex) {
            ex.printStackTrace();  
	}
    }
    
    public static Settings getInstance() {
      if(instance == null) {
         instance = new Settings();
      }
      return instance;
   }
    
    public void Load()
    {
        Properties prop = new Properties();
	InputStream input = null;

	try {
            input = new FileInputStream("config.properties");

            prop.load(input);

            // Load the database settings.
            dbURL = prop.getProperty("dbURL", dbURL);
            dbDriver = prop.getProperty("dbDriver", dbDriver);
            dbUsername = prop.getProperty("dbUsername", dbUsername);
            dbPass = prop.getProperty("dbPass", dbPass);
            
            // Load the Google calendar settings
            applicationName = prop.getProperty("applicationName", applicationName);
            calendarID = prop.getProperty("calendarID", calendarID);
            dataStoreFile = prop.getProperty("dataStoreFile", dataStoreFile);
            credentialsFile = prop.getProperty("credentialsFile", credentialsFile);
        } catch (FileNotFoundException e) {
            // Properties file not found, let's create one.
            Save();
        } catch (IOException ex) {
            ex.printStackTrace();  
	} finally {
            if (input != null) {
                try {
                        input.close();
                } catch (IOException e) {
                        e.printStackTrace();
                }
            }
	}
    }
    
    public void Save()
    {
        Properties prop = new Properties();
	OutputStream output = null;

	try {
            output = new FileOutputStream("config.properties");
            System.out.println(System.getProperty("user.dir"));
            
            // Save the database settings.
            prop.setProperty("dbURL", dbURL);
            prop.setProperty("dbDriver", dbDriver);
            prop.setProperty("dbUsername", dbUsername);
            prop.setProperty("dbPass", dbPass);
            
            // Save the Google calendar settings
            prop.setProperty("applicationName", applicationName);
            prop.setProperty("calendarID", calendarID);
            prop.setProperty("dataStoreFile", dataStoreFile);
            prop.setProperty("credentialsFile", credentialsFile);

            prop.store(output, null);
            

	} catch (IOException io) {
		io.printStackTrace();
	} finally {
            if (output != null) {
                try {
                        output.close();
                } catch (IOException e) {
                        e.printStackTrace();
                }
            }

	}
    }
}
