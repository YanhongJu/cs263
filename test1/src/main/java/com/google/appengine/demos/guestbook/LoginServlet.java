package com.google.appengine.demos.guestbook;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
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

public class LoginServlet extends HttpServlet {
	@Override
	  public void doPost(HttpServletRequest req, HttpServletResponse resp)
	      throws IOException {
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

	    String userName = req.getParameter("userName");
	    String password = req.getParameter("password");
	    Key userKey = KeyFactory.createKey("User", userName);
	    Entity signedUser ;
		try {
			signedUser = datastore.get(userKey);
			if(password.equals(signedUser.getProperty("password"))){
				resp.sendRedirect("welcom.html");   
		    }
			else resp.sendRedirect("login.html");
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		resp.sendRedirect("login.html"); 

	   
	  }
  
}