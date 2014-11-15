package travelplanapp.travelplanapp;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@Path("/enqueue")
public class Enqueue {
	
	
	@POST
	@Path("/newplan")	
	@Consumes("application/x-www-form-urlencoded")
	public void newPlan(@FormParam("planName") String planName,
			@FormParam("YYYY") String yyyy, @FormParam("MM") String mm,
			@FormParam("DD") String dd,
			@Context HttpServletResponse servletResponse) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String date = yyyy + "-" + mm + "-" + dd;
		Queue queue = QueueFactory.getDefaultQueue();			
        queue.add(withUrl("/context/worker/createplan").param("planName", planName).param("date",date).param("userName", userName.toString()));
        System.out.println(userName + planName + date);
		servletResponse.sendRedirect("/plandetails.jsp?planName="+planName+"&date="+date);
        //servletResponse.sendRedirect("/activity.html");
		
	}
	
	
	@POST
	@Path("/newactivity")	
	public void newActivity(@FormParam("activityTitle") String activityTitle,
			@FormParam("address") String address,
			@FormParam("notes") String notes, @FormParam("day") String day,
			@Context HttpServletRequest request,@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");
		System.out.println("in queueue" +planName+" "+activityTitle+" "+address+" "+notes);
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/worker/createactivity")
				.param("planName", planName)
				.param("activityTitle", activityTitle).param("address", address)
				.param("day", day).param("notes", notes)
				.param("userName", userName.toString()));
		Thread.sleep(100);
		response.sendRedirect("/plandetails.jsp?planName="+planName);
		// servletResponse.sendRedirect("/activity.html");

	}
	
	
	@POST
	@Path("/newfood")	
	public void newFood(@FormParam("restaurant") String restaurant,
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
		response.sendRedirect("/food.jsp?planName="+planName);
		// servletResponse.sendRedirect("/activity.html");

	}

}
