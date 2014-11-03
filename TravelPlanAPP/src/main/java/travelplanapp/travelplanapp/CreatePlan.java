package travelplanapp.travelplanapp;
import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

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

@Path("/newplan")
public class CreatePlan {
	@POST
	@Path("/enqueue")
	
	@Consumes("application/x-www-form-urlencoded")
	public void doPost(@FormParam("planName") String planName,
			@FormParam("YYYY") String yyyy, @FormParam("MM") String mm,
			@FormParam("DD") String dd,
			@Context HttpServletResponse servletResponse) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String date = yyyy + "-" + mm + "-" + dd;
		Queue queue = QueueFactory.getDefaultQueue();		
        queue.add(withUrl("/createplanworker").param("planName", planName).param("date",date));
        //response.sendRedirect("/done.html");
		System.out.println(userName + planName + date);
		servletResponse.sendRedirect("/plandetails.jsp?planName="+planName+"&date="+date);
		
	}
}
