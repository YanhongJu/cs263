package travelplanapp.travelplanapp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;



@Path("/search")
public class Search {
	@POST
	@Path("/activity")
	public void searchActivityPost(@FormParam("searchCity") String searchCity,			
			@Context HttpServletRequest request,@Context HttpServletResponse response) throws Exception {		
		String planName = request.getParameter("planName");			
		response.sendRedirect("/searchactivity.jsp?query="+searchCity+"planName="+planName);
		

	}
	
	@POST
	@Path("/food")
	public void searchFoodPost(@FormParam("searchCity") String searchCity,			
			@Context HttpServletRequest request,@Context HttpServletResponse response) throws Exception {		
		String planName = request.getParameter("planName");			
		response.sendRedirect("/searchfood.jsp?query="+searchCity+"planName="+planName);
		

	}

}
