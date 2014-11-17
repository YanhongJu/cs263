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
		servletResponse.sendRedirect("/activity.jsp?planName="+planName+"&date="+date);
        //servletResponse.sendRedirect("/activity.html");
		
	}
	
	
	@POST
	@Path("/newactivity")	
	public void newActivity(@FormParam("activityTitle") String title,
			@FormParam("address") String address,
			@FormParam("notes") String notes, @FormParam("day") String day,
			@Context HttpServletRequest request,@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");	
		String date = request.getParameter("date");	
		
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/worker/createactivity")
				.param("planName", planName)				
				.param("title", title).param("address", address)
				.param("day", day).param("notes", notes)
				.param("userName", userName.toString()));
		Thread.sleep(100);		
		response.sendRedirect("/activity.jsp?planName="+planName+"&date="+date);
	}
	
	@POST
	@Path("/updateactivity")	
	public void updateActivity(@FormParam("activityTitle") String title,
			@FormParam("address") String address,
			@FormParam("notes") String notes, @FormParam("day") String day,
			@Context HttpServletRequest request,@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");	
		String startDate = request.getParameter("startDate");	

		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/worker/createactivity")
				.param("planName", planName)				
				.param("title", title).param("address", address)
				.param("day", day).param("notes", notes)
				.param("userName", userName.toString()));
		Thread.sleep(100);
		response.sendRedirect("/plandetails.jsp?planName="+planName+"&startDate="+startDate);
	}
	
	
	@POST
	@Path("/deleteactivity")	
	public void deleteActivity(@Context HttpServletRequest request,@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");	
		String title = request.getParameter("title");
		String startDate = request.getParameter("startDate");
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/worker/deleteactivity")
				.param("planName", planName)
				.param("title", title)
				.param("userName", userName.toString()));
		Thread.sleep(50);
		System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!");
		response.sendRedirect("/plandetails.jsp?planName="+planName+"&startDate="+startDate);
		// servletResponse.sendRedirect("/activity.html");

	}
	
	@POST
	@Path("/deleteplan")	
	public void deletePlan(@Context HttpServletRequest request,@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");			
		
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/worker/deleteplan")
				.param("planName", planName)				
				.param("userName", userName.toString()));
		Thread.sleep(100);
		response.sendRedirect("/allplans.jsp");
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
