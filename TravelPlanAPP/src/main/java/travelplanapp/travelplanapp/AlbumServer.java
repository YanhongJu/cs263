package travelplanapp.travelplanapp;

import java.util.ArrayList;
import java.util.List;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;


/**
 * AlbumServer is a class in charge of serving data about albums and photos in
 * album. The methods in this class consume HTTP GET requests and return data in
 * JSON Format.
 * 
 * @author Yanhong Ju
 * @version 1.0
 * @since 1.0
 */

@Path("/album")
public class AlbumServer {

	/**
	 * Consumes a HttpRequest with information about albumName. Produce a JSON
	 * String containing image imageUrl and Blobkey of each photo in this album.
	 * 
	 *
	 * @param albumName
	 *            the name of the album to be created
	 * @param response
	 *            HttpResponse to redirect
	 * @return JSON String containing image imageUrl and Blobkey
	 * @since 1.0
	 */

	@GET
	@Path("/getone/{albumName}")
	public String getGallery(@PathParam("albumName") String albumName)
			throws Exception {
		System.out.println("-----------albumName-------" + albumName);
		UserService userService = UserServiceFactory.getUserService();
		String userName = userService.getCurrentUser().toString();
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key albumKey = KeyFactory.createKey("Album", userName + albumName);
		Entity album = datastore.get(albumKey);
		ImagesService imagesService = ImagesServiceFactory.getImagesService();
		List<String> list = (List<String>) album.getProperty("list");
		if(list == null)
			return "{\"results\":[]}";
		
		String json = "{\"results\":[";
		for (String s : list) {
			BlobKey blobKey = new BlobKey(s);
			String imageUrl = null;
			try {
				imageUrl = imagesService.getServingUrl(blobKey, 800, false);
				json += "{";
				json += ("\"imageUrl\":\"" + imageUrl + "\",");
				json += ("\"blobKey\":\"" + s);
				json += "\"},";
			} catch (java.lang.IllegalArgumentException e) {
			}

		}
		json = json.substring(0, json.length() - 1);
		json += "]}";		
		return json;
	}

	/**
	 * Consumes a HttpRequest for all albums. Produce a JSON String containing
	 * all albums' albumName,notes and imageUrl of first photo. 	 *
	 * 
	 * @return JSON String containing image imageUrl and Blobkey
	 * @since 1.0
	 */

	@GET
	@Path("/allalbums")
	public String getAllAlbums() throws Exception {

		UserService userService = UserServiceFactory.getUserService();
		ImagesService imagesService = ImagesServiceFactory.getImagesService();
		User userName = userService.getCurrentUser();
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Filter propertyFilter = new FilterPredicate("UserName",
				FilterOperator.EQUAL, userName.toString());
		Query q = new Query("Album").setFilter(propertyFilter);
		PreparedQuery pq = datastore.prepare(q);

		String json = "{\"results\":[";

		
		for (Entity entity : pq.asIterable()) {

			List<String> list = (ArrayList<String>) entity.getProperty("list");
			String imageUrl = null;
			if (list != null) {
				for (int i = 0; i < list.size();) {
					BlobKey blobKey = new BlobKey(list.get(i));
					try {
						imageUrl = imagesService.getServingUrl(blobKey);
						break;
					} catch (java.lang.IllegalArgumentException e) {
						i++;
					}
				}
			}
			if (imageUrl == null)
				imageUrl = "images/no_image.png";
			json += "{";
			json += ("\"albumName\":\"" + entity.getProperty("albumName") + "\",");
			json += ("\"notes\":\"" + entity.getProperty("notes") + "\",");
			json += ("\"imageUrl\":\"" + imageUrl);
			json += "\"},";

		}
		if (json.charAt(json.length() - 1) == ',')
			json = json.substring(0, json.length() - 1);
		json += "]}";		
		return json; 
	}
}
