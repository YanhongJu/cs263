package travelplanapp.travelplanapp;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@Path("/jerseyws")
public class RestTest {

    @GET
    @Path("/test")
    public String testMethod() {
        return "this is a test";
    }
    
    @POST
    @Path("/test2")
    public String doPost(@FormParam("activityTitle") String activityTitle,			
			@Context HttpServletRequest request) throws Exception {
		
		String planName = request.getParameter("planName");
		System.out.println(planName+" "+activityTitle);
		return activityTitle+planName;
		// servletResponse.sendRedirect("/activity.html");

	}
}