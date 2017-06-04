package Utils;

import Settings.Settings;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;
/**
 *
 * @author gotoel
 */
@WebListener
public class ContextListener implements ServletContextListener {
  @Override
  public void contextDestroyed(ServletContextEvent arg0) {
        // Server shuttind down.
  }

  @Override
  public void contextInitialized(ServletContextEvent arg0) {
        // Server starting.
        Settings.getInstance().Save();
        System.out.println("Initialized.");
  }
}
