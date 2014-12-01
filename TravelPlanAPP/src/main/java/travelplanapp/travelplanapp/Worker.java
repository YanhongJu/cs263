package travelplanapp.travelplanapp;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;

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
		String dateString = httpRequest.getParameter("date");
		System.out.println(planName + " " + dateString);
		String[] array = dateString.split("-");
		int year = Integer.parseInt(array[0]);
		int month = Integer.parseInt(array[1]);
		int day = Integer.parseInt(array[2]);
		Date date = new Date(year, month, day);

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
	@Path("/createalbum")
	public void createAlbum(@Context HttpServletRequest httpRequest)
			throws Exception {
		String userName = httpRequest.getParameter("userName");
		String albumName = httpRequest.getParameter("albumName");
		String notes = httpRequest.getParameter("notes");
		List<BlobKey> list = null;
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key albumKey = KeyFactory.createKey("Album", userName + albumName);
		Entity album = new Entity(albumKey);
		album.setProperty("UserName", userName);
		album.setProperty("albumName", albumName);
		album.setProperty("notes", notes);
		album.setProperty("list", list);
		datastore.put(album);
	}

	@POST
	@Path("/addphoto")
	public void upload(@Context HttpServletRequest httpRequest)
			throws Exception {
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();

		Transaction txn = datastore.beginTransaction();
		try {
			String userName = httpRequest.getParameter("userName");
			String albumName = httpRequest.getParameter("albumName");
			String blobKey = httpRequest.getParameter("blobKey");
			Key albumKey = KeyFactory.createKey("Album", userName + albumName);
			Entity album = datastore.get(albumKey);
			List<String> list = (ArrayList<String>) album.getProperty("list");
			if (list == null) {
				list = new ArrayList<String>();
			}
			System.out.println("list size -----22222----------" + list.size());
			list.add(blobKey);
			System.out.println("list size ------33333-------" + list.size());
			album.setProperty("list", list);
			datastore.put(album);
			txn.commit();
		} finally {
			if (txn.isActive()) {
				txn.rollback();
			}
		}
	}

	@POST
	@Path("/createactivity")
	public void createActivity(@Context HttpServletRequest httpRequest)
			throws Exception {

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		String userName = httpRequest.getParameter("userName");
		String planName = httpRequest.getParameter("planName");
		String activityTitle = httpRequest.getParameter("title");
		String address = httpRequest.getParameter("address");
		String day = httpRequest.getParameter("day");

		String notes = httpRequest.getParameter("notes");
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
	}

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

	}

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

	}

	@POST
	@Path("/createfood")
	public void createFood(@Context HttpServletRequest httpRequest)
			throws Exception {

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		String userName = httpRequest.getParameter("userName");
		String planName = httpRequest.getParameter("planName");
		String restaurant = httpRequest.getParameter("title");
		String address = httpRequest.getParameter("address");
		String day = httpRequest.getParameter("day");
		String notes = httpRequest.getParameter("notes");
		System.out.println("in worker" + planName + " " + restaurant);
		Key userKey = KeyFactory.createKey("User", userName);
		Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
		Key foodKey = KeyFactory.createKey(planKey, "Activity", restaurant);
		Entity food = new Entity(foodKey);

		food.setProperty("title", restaurant);
		food.setProperty("day", day);
		food.setProperty("address", address);
		food.setProperty("notes", notes);
		System.out.println(food);
		datastore.put(food);
	}
}
