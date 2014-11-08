package travelplanapp.travelplanapp;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.net.URI;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@Path("/newactivity")
public class CreateActivity {
	@POST
	@Path("/enqueue")
	
	public void doPost(@FormParam("restaurant") String restaurant,
			@FormParam("address") String address,
			@FormParam("notes") String notes, @FormParam("day") String day,
			@Context HttpServletRequest request,@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");
		System.out.println("in queueue" +planName+" "+restaurant+" "+address+" "+notes);
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/worker/createfood")
				.param("planName", planName)
				.param("restaurant", restaurant).param("address", address)
				.param("day", day).param("notes", notes)
				.param("userName", userName.toString()));
		Thread.sleep(100);
		response.sendRedirect("/plandetails.jsp?planName="+planName);
		// servletResponse.sendRedirect("/activity.html");

	}
}
