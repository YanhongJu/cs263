package travelplan.travelplan;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;



import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;

@Path("/login")
public class LoginModule {

	@POST
	@Path("/verify")
	public String verify(@FormParam("userName") String userName,
			@FormParam("password") String password) {
		System.out.println(userName);
		System.out.println(password);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key userKey = KeyFactory.createKey("User", userName);

		Entity signedUser;

		try {
			signedUser = datastore.get(userKey);
			if (password.equals(signedUser.getProperty("password"))) {
				RegisteredUser u = new RegisteredUser();
				u.setUserEmail(userName);
				u.setPassword(password);
				Gson gson = new GsonBuilder().setPrettyPrinting().create();
				String jsonUser = gson.toJson(u);
				System.out.println(jsonUser);
				return jsonUser;
				/* resp.sendRedirect("welcom.html"); */
			} else
				/* resp.sendRedirect("login.html"); */
				return "!";
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			/* resp.sendRedirect("login.html"); */
			return "exception";
		}

	}

}