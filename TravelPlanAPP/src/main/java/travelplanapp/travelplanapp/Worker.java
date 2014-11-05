package travelplanapp.travelplanapp;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/*import com.google.gson.Gson;
 import com.google.gson.GsonBuilder;*/
@Path("/worker")
public class Worker {
	@POST
	@Path("/createplan")
	public void createPlan(@Context HttpServletRequest httpRequest) {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		String planName = httpRequest.getParameter("planName");
		String date = httpRequest.getParameter("date");
		System.out.println(planName+" "+date);
		Key parentKey;
		if(userName== null)
			parentKey= KeyFactory.createKey("User", "test@example.com");
		else 
			parentKey = KeyFactory.createKey("User", userName.toString());
		Key planKey = KeyFactory.createKey(parentKey, "Plan", planName);
		Entity plan = new Entity(planKey);
		plan.setProperty("date", date);
		datastore.put(plan);
	}
	@POST
	@Path("/createactivity")
	public void createActivity(@Context HttpServletRequest httpRequest) {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		
		String planName = httpRequest.getParameter("planName");
		String activityTitle = httpRequest.getParameter("activityTitle");
		String address = httpRequest.getParameter("address");
		String day = httpRequest.getParameter("day");
		String notes = httpRequest.getParameter("notes");		
		System.out.println(planName+" "+activityTitle);
		Key userKey;
		if(userName== null)
			userKey= KeyFactory.createKey("User", "test@example.com");
		else 
			userKey = KeyFactory.createKey("User", userName.toString());
		Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
		Key activityKey = KeyFactory.createKey(planKey, "Activity", activityTitle);
		Entity activity = new Entity(activityKey);
		activity.setProperty("activityTitle",activityTitle);
		activity.setProperty("day", day);
		activity.setProperty("address", address);
		activity.setProperty("notes", notes);
		System.out.println(activity);
		datastore.put(activity);
	}
}
