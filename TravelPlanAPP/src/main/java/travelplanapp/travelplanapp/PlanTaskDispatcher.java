package travelplanapp.travelplanapp;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.util.Date;

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

/**
 * PlanTaskDispatcher is a class in charge of dispatching tasks related to Trip
 * plan and plan details. The methods in this class consume HTTP POST
 * requests including create/delete/update plan, add/delete/update plan details
 * and dispatch tasks to process these request, add tasks to task queue. *
 * 
 * @author Yanhong Ju
 * @version 1.0
 * @since 1.0
 */

@Path("/enqueue")
public class PlanTaskDispatcher {

	/**
	 * Consumes a HttpRequest with submitted form including information about
	 * Plan Name and start Date, generate Date String and produce a new
	 * createPlan task using the information. Add task to task queue and the
	 * redirect the httpResponse to pages where users add plan details.
	 * 
	 *
	 * @param planName
	 *            the name of the plan to be created
	 * @param yyyy
	 *            four-digit year of the start date
	 * @param mm
	 *            two-digit month of the start date
	 * @param dd
	 *            two-digit day of the start date
	 * @param response
	 *            HttpResponse to redirect
	 * @since 1.0
	 */

	@POST
	@Path("/newplan")
	@Consumes("application/x-www-form-urlencoded")
	public void newPlan(@FormParam("planName") String planName,
			@FormParam("YYYY") String yyyy, @FormParam("MM") String mm,
			@FormParam("DD") String dd, @Context HttpServletResponse response)
			throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String date = yyyy + "-" + mm + "-" + dd;
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/planworker/createplan")
				.param("planName", planName).param("date", date)
				.param("userName", userName.toString()));
		response.sendRedirect("/activity.jsp?planName=" + planName + "&date="
				+ date);

	}

	/**
	 * Consumes HttpRequest including information about plan name, start date
	 * and a submitted form including information about activity tile, address,
	 * day and notes and produce a new create activity task using the
	 * information. Add task to task queue and the redirect the response to
	 * pages where users add another activity.
	 * 
	 *
	 * @param title
	 *            the title of the activity to be created
	 * @param address
	 *            address for the activity
	 * @param notes
	 *            notes about the activity
	 * @param day
	 *            day number of this activity
	 * @param request
	 *            httpRequest to be processed
	 * @param response
	 *            httpResponse to redirect
	 * @since 1.0
	 */

	@POST
	@Path("/newactivity")
	public void newActivity(@FormParam("activityTitle") String title,
			@FormParam("address") String address,
			@FormParam("notes") String notes, @FormParam("day") String day,
			@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");
		String date = request.getParameter("date");

		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/activityworker/createactivity")
				.param("planName", planName).param("title", title)
				.param("address", address).param("day", day)
				.param("notes", notes).param("userName", userName.toString()));
		Thread.sleep(100);

		response.sendRedirect("/activity.jsp?planName=" + planName + "&date="
				+ date);
	}

	/**
	 * Consumes HttpRequest including information about plan name, start date
	 * and a submitted form including information about flight title, address,
	 * day and flight time. Check if user wants a reminder email.If yes,
	 * calculate time for sending email and produce a email task and set the
	 * execution time. Add create activity task to task queue and the redirect
	 * the response to pages where users add another activity.
	 * 
	 *
	 * @param title
	 *            the title of the activity to be created
	 * @param address
	 *            address for the activity
	 * @param notes
	 *            notes about the activity
	 * @param day
	 *            day number of this activity
	 * @param notice
	 *            whether user wants a reminder email about the flight
	 * @param request
	 *            httpRequest to be processed
	 * @param response
	 *            httpResponse to redirect
	 * @since 1.0
	 */
	@POST
	@Path("/newflight")
	public void newFlight(@FormParam("activityTitle") String title,
			@FormParam("address") String address,
			@FormParam("notes") String notes, @FormParam("day") String day,
			@FormParam("notice") String notice,
			@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");
		String date = request.getParameter("date");

		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/activityworker/createactivity")
				.param("planName", planName).param("title", title)
				.param("address", address).param("day", day)
				.param("notes", notes).param("userName", userName.toString()));

		if (notice!=null && notice.equals("on")) {

			long remindTime = getRemindTime(date, day, notes);
			if (remindTime > 0)
				queue.add(withUrl("/context/mailworker/mail")
						.param("userName", userName.toString())
						.param("title", title).param("address", address)
						.param("notes", notes).etaMillis(remindTime));
		}
		/*if(notice == null)
			queue.add(withUrl("/context/mailworker/mail")
					.param("userName", userName.toString())
					.param("title", title).param("address", address)
					.param("notes", notes));*/
		Thread.sleep(100);

		response.sendRedirect("/activity.jsp?planName=" + planName + "&date="
				+ date);
	}

	@SuppressWarnings("deprecation")
	private long getRemindTime(String date, String day, String time) {
		boolean validTime = true;

		Date d = new Date();
		String[] dateList = date.split("-");
		int year = Integer.parseInt(dateList[0]);
		int month = Integer.parseInt(dateList[1]);
		int dayNum = Integer.parseInt(dateList[2]);
		String[] timeList = time.split(":");

		if (timeList.length != 2)
			validTime = false;
		int hour = 0;
		int minute = 0;
		try {
			hour = Integer.parseInt(timeList[0]);
			minute = Integer.parseInt(timeList[1]);
			if (hour < 0 || hour > 23 || minute < 0 || minute > 59)
				validTime = false;
		} catch (NumberFormatException e) {
			validTime = false;
		}
		if (validTime) {
			d.setYear(year - 1900);
			d.setMonth(month - 1);
			d.setDate(dayNum);
			d.setHours(hour);
			d.setMinutes(minute);
			int x = Integer.parseInt(day);
			// d=new Date(d.getTime()+(24*60*60*1000*x)-3*60*60*1000);
			d = new Date(d.getTime() + (24 * 60 * 60 * 1000 * (x - 1)));
			long remindTime = d.getTime() + 5 * 60 * 60 * 1000;
			return remindTime;
		}

		return -1;
	}

	/**
	 * Consumes HttpRequest including information about plan name, start date
	 * and a submitted form including information about activity tile, address,
	 * day and notes and produce a update activity task using the information.
	 * Add task to task queue and the redirect the response to pages where users
	 * can view the whole plan.
	 * 
	 * @param title
	 *            the title of the activity to be created
	 * @param address
	 *            address for the activity
	 * @param notes
	 *            notes about the activity
	 * @param day
	 *            day number of this activity
	 * @param request
	 *            httpRequest to be processed
	 * @param response
	 *            httpResponse to redirect
	 * @since 1.0
	 */
	@POST
	@Path("/updateactivity")
	public void updateActivity(@FormParam("activityTitle") String title,
			@FormParam("address") String address,
			@FormParam("notes") String notes, @FormParam("day") String day,
			@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");
		String startDate = request.getParameter("startDate");

		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/activityworker/createactivity")
				.param("planName", planName).param("title", title)
				.param("address", address).param("day", day)
				.param("notes", notes).param("userName", userName.toString()));
		Thread.sleep(100);
		response.sendRedirect("/plandetails.jsp?planName=" + planName
				+ "&startDate=" + startDate);
	}

	/**
	 * Consumes HttpRequest including information about plan name, start
	 * date,activity tile and produce a delete activity task using the
	 * information. Add task to task queue and the redirect the response to
	 * pages where users can view the whole plan.	 *
	 *
	 * @param request
	 *            httpRequest to be processed
	 * @param response
	 *            httpResponse to redirect
	 * @since 1.0
	 */
	@POST
	@Path("/deleteactivity")
	public void deleteActivity(@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");
		String title = request.getParameter("title");
		String startDate = request.getParameter("startDate");
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/activityworker/deleteactivity")
				.param("planName", planName).param("title", title)
				.param("userName", userName.toString()));
		Thread.sleep(100);
		response.sendRedirect("/plandetails.jsp?planName=" + planName
				+ "&startDate=" + startDate);
	}

	/**
	 * Consumes HttpRequest including information about plan name and produce a
	 * delete plan task using the information. Add task to task queue and the
	 * redirect the response to pages where users can view all the plans.
	 *	 *
	 * @param request
	 *            httpRequest to be processed
	 * @param response
	 *            httpResponse to redirect
	 * @since 1.0
	 */
	@POST
	@Path("/deleteplan")
	public void deletePlan(@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		String planName = request.getParameter("planName");

		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(withUrl("/context/planworker/deleteplan").param("planName",
				planName).param("userName", userName.toString()));
		Thread.sleep(150);
		response.sendRedirect("/allplans.jsp");
		// servletResponse.sendRedirect("/activity.html");

	}

}
