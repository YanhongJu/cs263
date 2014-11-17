package travelplanapp.travelplanapp;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/*import com.google.gson.Gson;
 import com.google.gson.GsonBuilder;*/
@Path("/worker")
public class Worker {
	@POST
	@Path("/createplan")
	public void createPlan(@Context HttpServletRequest httpRequest)
			throws Exception {
		String userName = httpRequest.getParameter("userName");
		System.out.println(userName);		
		String planName = httpRequest.getParameter("planName");
		String date = httpRequest.getParameter("date");
		System.out.println(planName+" "+date);
		
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key parentKey = KeyFactory.createKey("User", userName);		
		Key planKey = KeyFactory.createKey(parentKey, "Plan", planName);
		Entity plan = new Entity(planKey);
		plan.setProperty("planName", planName);
		plan.setProperty("date", date);
		plan.setProperty("userName", userName);
		datastore.put(plan);
	}

	@POST
	@Path("/createactivity")
	public void createActivity(@Context HttpServletRequest httpRequest)
			throws Exception {

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		String userName = httpRequest.getParameter("userName");
		String planName = httpRequest.getParameter("planName");
		String activityTitle = httpRequest.getParameter("activityTitle");
		String address = httpRequest.getParameter("address");
		String day = httpRequest.getParameter("day");
		String notes = httpRequest.getParameter("notes");
		System.out.println("in worker"+planName + " " + activityTitle);
		Key userKey = KeyFactory.createKey("User", userName);		
		Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
		Key activityKey = KeyFactory.createKey(planKey, "Activity", activityTitle);
		Entity activity = new Entity(activityKey);	

		activity.setProperty("title", activityTitle);
		activity.setProperty("day", day);
		activity.setProperty("address", address);
		activity.setProperty("notes", notes);
		System.out.println(activity);
		datastore.put(activity);
	}
	
	@POST
	@Path("/createfood")
	public void createFood(@Context HttpServletRequest httpRequest)
			throws Exception {

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		String userName = httpRequest.getParameter("userName");
		String planName = httpRequest.getParameter("planName");
		String restaurant = httpRequest.getParameter("restaurant");
		String address = httpRequest.getParameter("address");
		String day = httpRequest.getParameter("day");
		String notes = httpRequest.getParameter("notes");
		System.out.println("in worker"+planName + " " + restaurant);
		Key userKey = KeyFactory.createKey("User", userName);		
		Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
		Key foodKey = KeyFactory.createKey(planKey, "Food", restaurant);
		Entity food = new Entity(foodKey);	

		food.setProperty("title", restaurant);
		food.setProperty("day", day);
		food.setProperty("address", address);
		food.setProperty("notes", notes);
		System.out.println(food);
		datastore.put(food);
	}
}
