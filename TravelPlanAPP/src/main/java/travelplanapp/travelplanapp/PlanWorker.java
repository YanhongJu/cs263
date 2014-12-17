package travelplanapp.travelplanapp;

import java.util.Date;
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
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

/**
 * PlanWorker is a class in charge of implementing tasks related to Trip plans.
 * The methods in this class consume HTTP POST requests from task dispatcher and
 * add/delete plans by adding/deleting entities in datastore.
 * 
 * @author Yanhong Ju
 * @version 1.0
 * @since 1.0
 */
@Path("/planworker")
public class PlanWorker {

	/**
	 * Consumes a HttpRequest with userName,planName, start date. Create an
	 * entity of type Plan using planName as Key. This entity has a parent key
	 * corresponding to the user to which the plan belongs. Set the properties
	 * of this entity including planName,date userName.
	 * 
	 * @param request
	 *            httpRequest to be processed
	 * @since 1.0
	 */

	@POST
	@Path("/createplan")
	public void createPlan(@Context HttpServletRequest httpRequest)
			throws Exception {
		String userName = httpRequest.getParameter("userName");
		System.out.println(userName);
		String planName = httpRequest.getParameter("planName");
		String dateString = httpRequest.getParameter("date");
		System.out.println(planName + " " + dateString);
		String[] array = dateString.split("-");
		int year = Integer.parseInt(array[0]);
		int month = Integer.parseInt(array[1]);
		int day = Integer.parseInt(array[2]);
		Date date = new Date(year - 1900, month - 1, day);

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

	/**
	 * Consumes a HttpRequest with userName,planName. Delete the entity of type
	 * Plan corresponding to the userName and planName. Delete the Memcache
	 * corresponding to this plan.
	 * 
	 * @param request
	 *            httpRequest to be processed
	 * @since 1.0
	 */

	@POST
	@Path("/deleteplan")
	public void deletePlan(@Context HttpServletRequest httpRequest)
			throws Exception {

		String userName = httpRequest.getParameter("userName");
		String planName = httpRequest.getParameter("planName");
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key parentKey = KeyFactory.createKey("User", userName);
		Key planKey = KeyFactory.createKey(parentKey, "Plan", planName);
		Query detailq = new Query("Activity").setAncestor(planKey);
		PreparedQuery pdetailq = datastore.prepare(detailq);
		for (Entity result : pdetailq.asIterable()) {
			datastore.delete(result.getKey());
		}
		datastore.delete(planKey);

		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers
				.getConsistentLogAndContinue(Level.INFO));
		syncCache.delete(planName);
	}

}
