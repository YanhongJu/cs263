package travelplan.travelplan;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class LoginServlet extends HttpServlet {

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		String userName = req.getParameter("userName");
		String password = req.getParameter("password");		
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key userKey = KeyFactory.createKey("User", userName);

		Entity signedUser;

		try {
			signedUser = datastore.get(userKey);
			if (password.equals(signedUser.getProperty("password"))) {
				RegisteredUser u = new RegisteredUser();
				u.setUserEmail(userName);
				u.setPassword(password);
				Gson gson = new GsonBuilder().setPrettyPrinting().create();
				String jsonUser = gson.toJson(u);
				System.out.println(jsonUser);				
				resp.sendRedirect("welcom.jsp?userName="+userName); 
			} else{
				resp.sendRedirect("login.html");
			}
				
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			resp.sendRedirect("login.html"); 
			
		}
	}
}
