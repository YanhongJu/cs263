package travelplanapp.travelplanapp;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/**
 * AlbumTaskDispatcher is a class in charge of dispatching tasks related to
 * Album and photos. The methods in this class consume HTTP POST requests
 * including create/delete albums, add/delete photos and dispatch tasks to
 * process these request, add tasks to task queue. *
 * 
 * @author Yanhong Ju
 * @version 1.0
 * @since 1.0
 */
@Path("/album")
public class AlbumTaskDispatcher {

	/**
	 * Consumes a HttpRequest with submitted form including information about
	 * albumName and notes and produce a newAlbum task using the information.
	 * Add task to task queue and the redirect the httpResponse to pages where
	 * users can upload photos.
	 * 
	 *
	 * @param albumName
	 *            the name of the album to be created
	 * @param notes
	 *            notes about the new album *
	 * @param response
	 *            HttpResponse to redirect
	 * @since 1.0
	 */
	@POST
	@Path("/newalbum")
	@Consumes("application/x-www-form-urlencoded")
	public void newalbum(@FormParam("albumName") String albumName,
			@FormParam("notes") String notes,
			@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/albumworker/createalbum")
				.param("albumName", albumName).param("notes", notes)
				.param("userName", userName.toString()));		
		response.sendRedirect("/addphoto.jsp?albumName=" + albumName);

	}

	/**
	 * Consumes a HttpRequest with information about albumName and produce a
	 * deleteAlbum task using the information. Add task to task queue and the
	 * redirect the httpResponse to pages where users can view all albums.
	 * 
	 *
	 * @param albumName
	 *            the name of the album to be deleted
	 * @param response
	 *            HttpResponse to redirect
	 * @since 1.0
	 */

	@POST
	@Path("/deletealbum")
	public void deleteAlbum(@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {

		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		Queue queue = QueueFactory.getDefaultQueue();
		String albumName = request.getParameter("albumName");
		queue.add(withUrl("/context/albumworker/deletealbum").param(
				"albumName", albumName).param("userName", userName.toString()));
		
		System.out.println("=============delete");
		Thread.sleep(120);
		response.sendRedirect("/album.jsp");
	}

	/**
	 * Consumes a HttpRequest with information about uploaded photos, get
	 * BlobKeys for all uploaded photos. Produce one task for each blobkey and
	 * add tasks to task queue. Redirect the httpResponse to pages where users
	 * can view all photos in this gallery.
	 * 
	 * @param request
	 *            httpRequest to be processed
	 * @param response
	 *            HttpResponse to redirect
	 * @since 1.0
	 */
	@POST
	@Path("/upload")
	public void newPhoto(@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		BlobstoreService blobstoreService = BlobstoreServiceFactory
				.getBlobstoreService();
		UserService userService = UserServiceFactory.getUserService();
		String userName = userService.getCurrentUser().toString();
		Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(request);
		String albumName = request.getParameter("albumName");
		if (blobs == null || blobs.size() == 0)
			response.sendRedirect("/album.jsp");
		else {
			List<BlobKey> blobKey = blobs.get("myFile");

			if (blobKey == null) {
				response.sendRedirect("/");
			} else {

				Queue queue = QueueFactory.getDefaultQueue();

				for (BlobKey k : blobKey) {
					queue.add(withUrl("/context/albumworker/addphoto")
							.param("userName", userName)
							.param("albumName", albumName)
							.param("blobKey", k.getKeyString()));
				}
				Thread.sleep(100);

			}
			response.sendRedirect("/gallery.jsp?albumName=" + albumName);
		}

	}

	/**
	 * Consumes a HttpRequest with albumName and blobKey of the photo to be
	 * deleted. Produce one deletePhoto task and add task to
	 * task queue. Redirect the httpResponse to pages where users can view all
	 * photos in the current album.
	 * 
	 * @param request
	 *            httpRequest to be processed
	 * @param response
	 *            HttpResponse to redirect
	 * @since 1.0
	 */
	@POST
	@Path("/deletephoto")
	public void deletePhoto(@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		
		UserService userService = UserServiceFactory.getUserService();
		String userName = userService.getCurrentUser().toString();
		String albumName = request.getParameter("albumName");
		String blobKey = request.getParameter("blobKey");
		
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/albumworker/deletephoto")
				.param("userName", userName).param("albumName", albumName)
				.param("blobKey", blobKey));
		

		Thread.sleep(100);
		response.sendRedirect("/deletephoto.jsp?albumName=" + albumName);
	}

}
