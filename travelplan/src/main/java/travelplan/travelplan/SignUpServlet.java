package travelplan.travelplan;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SignUpServlet extends HttpServlet {
	@Override
	  public void doPost(HttpServletRequest req, HttpServletResponse resp)
	      throws IOException {
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();

	    String userName = req.getParameter("userName");
	    String password = req.getParameter("password1");
	    	Key guestbookKey = KeyFactory.createKey("User", userName);
	    	 Entity signedUser = new Entity(guestbookKey);
	    	 signedUser.setProperty("password", password);
	    	 DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    	 datastore.put(signedUser);
	    	 System.out.println("save to database");
	    	 resp.sendRedirect("welcom.html");    

	   
	  }
  
}
