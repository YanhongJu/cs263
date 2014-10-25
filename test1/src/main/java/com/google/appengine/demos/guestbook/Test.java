package com.google.appengine.demos.guestbook;

import javax.servlet.http.HttpServlet;



import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.PreparedQuery;
import java.util.*;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.*;

public class Test  extends HttpServlet {
	
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
		      throws IOException {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query q = new Query("TaskData");
		PreparedQuery p = datastore.prepare(q);	
		List<Entity> entities=p.asList(FetchOptions.Builder.withLimit(5));	    
	    resp.setContentType("text/plain");
	    if (entities.isEmpty()) {	    	
	        resp.getWriter().println("No data in datastroe");
	    } else {	    	
	    	    for (Entity d : entities) { 
	    	    	resp.getWriter().println(" Key: "+d.getProperty("key") +"     Value: "+d.getProperty("value"));
	    	    	
	    	    } 
		    
		}
	}
}
