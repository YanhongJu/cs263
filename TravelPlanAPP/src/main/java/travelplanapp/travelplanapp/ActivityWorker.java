package travelplanapp.travelplanapp;

import java.util.logging.Level;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

/**
 * ActivityWorker is a class in charge of implementing tasks related to Trip
 * activities. The methods in this class consume HTTP POST requests from task
 * dispatcher and add/delete/update activities by adding/deleting/updating
 * entities in datastore.
 * 
 * @author Yanhong Ju
 * @version 1.0
 * @since 1.0
 */

@Path("/activityworker")
public class ActivityWorker {

	/**
	 * Consumes a HttpRequest with userName,planName,title,address,day and notes
	 * about an activity. Create an entity of type Activity using Titile as Key.
	 * This entity has a parent key corresponding to the plan to which the
	 * activity belongs. Set the properties of this entity including address,day
	 * and notes. Update the memcache information about this plan. Memcache
	 * stores plan summary information.
	 * 
	 * @param request
	 *            httpRequest to be processed
	 * @since 1.0
	 */
	@POST
	@Path("/createactivity")
	public void createActivity(@Context HttpServletRequest request)
			throws Exception {

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		String userName = request.getParameter("userName");
		String planName = request.getParameter("planName");
		String activityTitle = request.getParameter("title");
		String address = request.getParameter("address");
		String day = request.getParameter("day");

		String notes = request.getParameter("notes");
		System.out.println("in worker" + planName + " " + activityTitle);
		Key userKey = KeyFactory.createKey("User", userName);
		Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
		Key activityKey = KeyFactory.createKey(planKey, "Activity",
				activityTitle);
		Entity activity = new Entity(activityKey);

		activity.setProperty("title", activityTitle);
		activity.setProperty("day", day);
		activity.setProperty("address", address);
		activity.setProperty("notes", notes);
		System.out.println(activity);
		datastore.put(activity);

		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers
				.getConsistentLogAndContinue(Level.INFO));
		if (syncCache.get(planName) != null
				&& !syncCache.get(planName).equals("")) {
			String details = (String) syncCache.get(planName);
			syncCache.put(planName, details + "," + day + "\t" + activityTitle);
		} else
			syncCache.put(planName, day + "\t" + activityTitle);
	}

	/**
	 * Consumes a HttpRequest with userName,planName and title about an
	 * activity. Delete the entity corresponding to this activity.Update the
	 * memcache information about this plan.
	 * 
	 * @param request
	 *            httpRequest to be processed
	 * @since 1.0
	 */

	@POST
	@Path("/deleteactivity")
	public void deleteActivity(@Context HttpServletRequest httpRequest)
			throws Exception {
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();

		String userName = httpRequest.getParameter("userName");
		String planName = httpRequest.getParameter("planName");
		String activityTitle = httpRequest.getParameter("title");

		Key userKey = KeyFactory.createKey("User", userName);
		Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
		Key activityKey = KeyFactory.createKey(planKey, "Activity",
				activityTitle);
		datastore.delete(activityKey);

		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers
				.getConsistentLogAndContinue(Level.INFO));
		if (syncCache.get(planName) != null) {
			String details = (String) syncCache.get(planName);
			if (!details.equals("")) {
				String[] list = details.split(",");
				details = "";

				for (String s : list) {
					if (s != null && !s.equals("")) {
						String[] subList = s.split("\t");
						if (!subList[1].equals(activityTitle))
							details = details + s + ",";
					}

				}
			}
			if (details.length() > 0)
				syncCache.put(planName,
						details.substring(0, details.length() - 1));
			else
				syncCache.delete(planName);

		}

	}

}
