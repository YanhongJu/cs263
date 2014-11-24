package travelplanapp.travelplanapp;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
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
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@Path("/album")
public class AlbumController {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();
/*
	@GET
	@Path("/blobserve")
	public void blobServer(@Context HttpServletRequest request,
			@Context HttpServletResponse servletResponse) throws Exception {
		
		String userName = request.getParameter("userName");	
		String albumName = request.getParameter("albumName");		
		Key albumKey = KeyFactory.createKey("Album", userName + albumName);

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Entity album = datastore.get(albumKey);
		if(album!=null){
			System.out.println("yyyyy1");
			List<String> list = (List<String>) album.getProperty("list");
			
			if (list != null) {
				
				BlobKey key = new BlobKey(list.get(0));
				System.out.println();
				servletResponse.setContentType("application/x-download");
				servletResponse.setHeader("Content-Disposition", "attachment; filename=ddd.pdf");
				blobstoreService.serve(key, servletResponse);
				
			} else
				servletResponse.sendRedirect("/welcom.jsp");
				//System.out.println("xxxx");
		}
		else servletResponse.sendRedirect("/welcom1.jsp");
		

	}
*/
	@POST
	@Path("/newalbum")
	@Consumes("application/x-www-form-urlencoded")
	public void newalbum(@FormParam("albumName") String albumName,
			@FormParam("notes") String notes,
			@Context HttpServletResponse servletResponse) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();

		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/worker/createalbum")
				.param("albumName", albumName).param("notes", notes)
				.param("userName", userName.toString()));

		servletResponse.sendRedirect("/addphoto.jsp?albumName=" + albumName);
		// servletResponse.sendRedirect("/activity.html");

	}

	@POST
	@Path("/upload")
	public void newPhoto(@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		String userName = userService.getCurrentUser().toString();
		Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(request);
		String albumName = request.getParameter("albumName");
		if (albumName == null)
			response.sendRedirect("/welcom.jsp");
		else {
			List<BlobKey> blobKey = blobs.get("myFile");

			if (blobKey == null) {
				response.sendRedirect("/");
			} else {

				Queue queue = QueueFactory.getDefaultQueue();

				System.out.println("NUmber of sfdfdfddddddddddddd" + blobKey.size());
				for (BlobKey k : blobKey) {
					queue.add(withUrl("/context/worker/addphoto")
							.param("userName", userName)
							.param("albumName", albumName)
							.param("blobKey", k.getKeyString()));
				}
				Thread.sleep(100);

			}
			
			response.sendRedirect("/onealbum.jsp?albumName="+albumName);
			/*response.sendRedirect("/context/album/blobserve?userName="
					+ userName + "&albumName=" + albumName);*/
		}

	}

}
