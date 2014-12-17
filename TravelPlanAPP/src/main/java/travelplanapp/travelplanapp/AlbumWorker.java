package travelplanapp.travelplanapp;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Transaction;

/**
 * AlbumWorker is a class in charge of implementing tasks related to albums and
 * photos. The methods in this class consume HTTP POST requests from task
 * dispatcher and add/delete albums, add/delete photos by
 * creating/deleting/updating Album entity.
 * 
 * @author Yanhong Ju
 * @version 1.0
 * @since 1.0
 */
@Path("/albumworker")
public class AlbumWorker {

	/**
	 * Consumes a HttpRequest with userName,albumName,and notes about an album.
	 * Create an entity of type Album using albumName and userName as Key. Set
	 * the properties of this entity including userName,albumName,and notes.
	 * Create an empty which will be used to store blobkeys of all photos as a
	 * list.
	 * 
	 * @param request
	 *            httpRequest to be processed
	 * @since 1.0
	 */
	@POST
	@Path("/createalbum")
	public void createAlbum(@Context HttpServletRequest request)
			throws Exception {
		String userName = request.getParameter("userName");
		String albumName = request.getParameter("albumName");
		String notes = request.getParameter("notes");
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

	/**
	 * Consumes a HttpRequest with userName,albumName,and blobKey of a photo.
	 * Add blobkey to the list in the Album Entity.
	 * 
	 * @param request
	 *            httpRequest to be processed
	 * @since 1.0
	 */
	@POST
	@Path("/addphoto")
	public void upload(@Context HttpServletRequest request) throws Exception {
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();

		Transaction txn = datastore.beginTransaction();
		try {
			String userName = request.getParameter("userName");
			String albumName = request.getParameter("albumName");
			String blobKey = request.getParameter("blobKey");
			Key albumKey = KeyFactory.createKey("Album", userName + albumName);
			Entity album = datastore.get(albumKey);
			List<String> list = (ArrayList<String>) album.getProperty("list");
			if (list == null) {
				list = new ArrayList<String>();
			}
			list.add(blobKey);
			album.setProperty("list", list);
			datastore.put(album);
			txn.commit();
		} finally {
			if (txn.isActive()) {
				txn.rollback();
			}
		}
	}

	/**
	 * Consumes a HttpRequest with userName,albumName and delete the entity
	 * corresponding to this userName and albumName.
	 *
	 * @param request
	 *            httpRequest to be processed
	 * @since 1.0
	 */
	@POST
	@Path("/deletealbum")
	public void deleteAlbum(@Context HttpServletRequest request)
			throws Exception {
        System.out.println("delete---------");
		String userName = request.getParameter("userName");
		String albumName = request.getParameter("albumName");
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key albumKey = KeyFactory.createKey("Album", userName + albumName);
		datastore.delete(albumKey);
	}

	/**
	 * Consumes a HttpRequest with userName,albumName and blobKey. Get the Album
	 * entity corresponding to this userName and albumName, delete the blobKey
	 * from the list.
	 *
	 * @param request
	 *            httpRequest to be processed
	 * @since 1.0
	 */
	@POST
	@Path("/deletephoto")
	public void deletePhoto(@Context HttpServletRequest request)
			throws Exception {
		BlobstoreService blobstoreService = BlobstoreServiceFactory
				.getBlobstoreService();
		
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		String userName = request.getParameter("userName");
		String albumName = request.getParameter("albumName");
		String blobKey = request.getParameter("blobKey");
		Key albumKey = KeyFactory.createKey("Album", userName + albumName);
		Entity album = datastore.get(albumKey);
		List<String> list = (ArrayList<String>) album.getProperty("list");		
		if (list.contains(blobKey))
			list.remove(blobKey);
		album.setProperty("list", list);
		datastore.put(album);
		
		BlobKey key = new BlobKey(blobKey);
		blobstoreService.delete(key);

	}

}
