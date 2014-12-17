package travelplanapp.travelplanapp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;

/**
 * SearchDispatcher is a class in charge of dispatching search tasks. The
 * methods in this class consume HTTP POST requests including searching for
 * activities, searching for food and redirect the response to search results
 * page.
 * 
 * @author Yanhong Ju
 * @version 1.0
 * @since 1.0
 */
@Path("/search")
public class SearchDispatcher {

	/**
	 * Consumes a HttpRequest with searchCity,planName. Redirect the user to
	 * page showing all activities in that city.
	 * 
	 * @param searchCity
	 *            City name to search for activities
	 * @param request
	 *            httpRequest to be processed
	 * @param response
	 *            httpRequest to be redirected
	 * @since 1.0
	 */
	@POST
	@Path("/{type}")
	public void searchActivityPost(@PathParam("type") String type,
			@FormParam("searchCity") String city,
			@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		String planName = request.getParameter("planName");
		String date = request.getParameter("date");
		if(type.equals("activity"))
			response.sendRedirect("/searchactivity.jsp?query=" + city
				+ "&planName=" + planName + "&date=" + date);
		if(type.equals("food"))
			response.sendRedirect("/food.jsp?query=" + city
				+ "&planName=" + planName + "&date=" + date);		
	}

	/**
	 * Consumes a HttpRequest with searchCity, planName. Redirect the user to
	 * page showing all foods in that city.
	 * 
	 * @param searchCity
	 *            City name to search for activities
	 * @param request
	 *            httpRequest to be processed
	 * @param response
	 *            httpRequest to be redirected
	 * @since 1.0
	 */

	/*@POST
	@Path("/food")
	public void searchFoodPost(@FormParam("searchCity") String searchCity,
			@Context HttpServletRequest request,
			@Context HttpServletResponse response) throws Exception {
		String planName = request.getParameter("planName");
		String date = request.getParameter("date");
		response.sendRedirect("/searchfood.jsp?query=" + searchCity
				+ "&planName=" + planName + "&date=" + date);
	}*/

}
