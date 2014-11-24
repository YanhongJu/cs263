package travelplanapp.travelplanapp;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;

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
import com.google.gson.Gson;

@Path("/json")
public class TestJson {

	@GET
	@Path("/testone/{albumName}")
	public String test(@PathParam("albumName") String albumName) throws Exception {
		System.out.println("-----------albumName-------" + albumName);
		UserService userService = UserServiceFactory.getUserService();		
		String userName = userService.getCurrentUser().toString();
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key albumKey = KeyFactory.createKey("Album", userName+albumName);
		Entity album = datastore.get(albumKey);
		ImagesService imagesService = ImagesServiceFactory.getImagesService();
		List<String> list = (List<String>) album.getProperty("list");	
		String json = "{\"results\":[";
		for(String s:list){
			BlobKey blobKey = new BlobKey(s);			
			String imageUrl = imagesService.getServingUrl(blobKey);
			json+="{";
			json+=("\"imageUrl\":\""+imageUrl);
			json+="\"},";
		}
		json = json.substring(0, json.length() - 1);
		json += "]}";
		System.out.println(json);
		return json;
	}

	/*
	 * @GET
	 * 
	 * @Path("/testget") protected void testGet(@PathParam("key") String key,
	 * 
	 * @Context HttpServletRequest httpRequest,
	 * 
	 * @Context HttpServletResponse httpRes) throws IOException {
	 * System.out.println("-----------xxx-------"); //String key =
	 * httpRequest.getParameter("key");
	 * System.out.println("-----------key-------" + key);
	 * 
	 * BlobKey blobKey = new BlobKey(key); String imageUrl =
	 * imagesService.getServingUrl(blobKey);
	 * System.out.println("------------url------" + imageUrl);
	 * 
	 * httpRes.setHeader("Content-Type", "text/html");
	 * 
	 * // This is a bit hacky, but it'll work. We'll use this key in an Async //
	 * service to // fetch the image and image information
	 * httpRes.getWriter().println(imageUrl);
	 * 
	 * }
	 */
	@GET
	@Path("/test")
	public String getJsonTest() throws Exception {
		
		
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
		Gson gson = new Gson();

		// convert java object to JSON format,
		// and returned as JSON formatted string

		for (Entity entity : pq.asIterable()) {
			json+="{";
			json+=("\"albumName\":\""+entity.getProperty("albumName")+"\",");
			json+=("\"notes\":\""+entity.getProperty("notes")+"\",");
			
			List<String> list = (ArrayList<String>) entity.getProperty("list");			
			String imageUrl;
			if (list.get(0) != null) {
				BlobKey blobKey = new BlobKey(list.get(0));
				imageUrl = imagesService.getServingUrl(blobKey);
			} else
				imageUrl = "images/no_image.png";
			
			json+=("\"imageUrl\":\""+imageUrl);	

			
			json += "\"},";
		}

		json = json.substring(0, json.length() - 1);
		json += "]}";

		System.out.println(json);
		return json;
		// return "cccc";
	}
}
