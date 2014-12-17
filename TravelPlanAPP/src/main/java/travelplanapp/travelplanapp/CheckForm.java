package travelplanapp.travelplanapp;

import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/**
 * CheckForm is a class in charge of checking if the user input is valid when
 * trying to create a new plan or a new album. The checking result is returned
 * to front end by JSON data.
 * 
 * @author Yanhong Ju
 * @version 1.0
 * @since 1.0
 */

@Path("/checkform")
public class CheckForm {

	/**
	 * Consumes a HttpRequest with planName. Check if this plan name already
	 * exists by checking if a corresponding entity exists. Generate JSON String
	 * for the result and return JSON to the user.
	 * 
	 *
	 * @param planName
	 *            the name of the plan to be created
	 * @return JSON String containing if planName exists
	 * @since 1.0
	 */
	@GET
	@Path("/plan/{planName}")
	public String checkPlan(@PathParam("planName") String planName) {

		UserService userService = UserServiceFactory.getUserService();
		String userName = userService.getCurrentUser().toString();
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key userKey = KeyFactory.createKey("User", userName);
		Key planKey = KeyFactory.createKey(userKey, "Plan", planName);
		try {
			if (datastore.get(planKey) != null) {
				return "{\"result\":\"true\"}";
			} else
				return "{\"result\":\"false\"}";
		} catch (EntityNotFoundException e) {
			return "{\"result\":\"false\"}";
		}

	}

	
	/**
	 * Consumes a HttpRequest with albumName. Check if this album name already
	 * exists by checking if a corresponding entity exists. Generate JSON String
	 * for the result and return JSON to the user.
	 * 
	 *
	 * @param albumName
	 *            the name of the album to be created
	 * @return JSON String containing if albumName exists
	 * @since 1.0
	 */
	
	@GET
	@Path("/album/{albumName}")
	public String checkAlbum(@PathParam("albumName") String albumName) {

		UserService userService = UserServiceFactory.getUserService();
		String userName = userService.getCurrentUser().toString();
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key albumKey = KeyFactory.createKey("Album", userName + albumName);
		try {
			if (datastore.get(albumKey) != null) {
				return "{\"result\":\"true\"}";
			} else
				return "{\"result\":\"false\"}";
		} catch (EntityNotFoundException e) {
			return "{\"result\":\"false\"}";
		}

	}

}
