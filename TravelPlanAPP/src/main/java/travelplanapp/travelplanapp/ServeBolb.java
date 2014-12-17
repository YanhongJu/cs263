package travelplanapp.travelplanapp;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class ServeBolb extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws IOException {

		String userName = req.getParameter("userName");
		String albumName = req.getParameter("albumName");
		Key albumKey = KeyFactory.createKey("Album", userName + albumName);

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Entity album = null;
		try {
			album = datastore.get(albumKey);
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (album != null) {

			List<String> list = (List<String>) album.getProperty("list");

			if (list != null) {

				BlobKey key = new BlobKey(list.get(0));
				System.out.println();				
				blobstoreService.serve(key, res);

			} else
				res.sendRedirect("/welcom.jsp");			
		} else
			res.sendRedirect("/welcom1.jsp");

	}
}