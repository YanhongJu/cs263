package travelplanapp.travelplanapp;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
/*import com.google.gson.Gson;
import com.google.gson.GsonBuilder;*/


public class CreatePlanWorker extends HttpServlet{
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		System.out.println("!!!!!!!!!!!!!");	
		UserService userService = UserServiceFactory.getUserService();
		User userName = userService.getCurrentUser();
		//String userName = request.getParameter("userName").trim();
		String planName = request.getParameter("planName");
		String date = request.getParameter("date");
		System.out.println(userName+planName+date);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();	
	   
	    Key parentKey = KeyFactory.createKey("User", userName.toString());
	    Key planKey = KeyFactory.createKey(parentKey,"Plan", planName);	    
		Entity plan = new Entity(planKey);
		plan.setProperty("date",date);   
		datastore.put(plan);	        
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {		
		String userName = request.getParameter("userName").trim();
		String planName = request.getParameter("planName").trim();
				
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();	   
	    Key parentKey = KeyFactory.createKey("User", userName);
	    Key planKey = KeyFactory.createKey(parentKey,"Plan", planName);	    
		Entity plan;
		/*try {
			plan = datastore.get(planKey);
			Gson gson = new GsonBuilder().setPrettyPrinting().create();
			String jsonEntity = gson.toJson(plan);			
			PrintWriter out = response.getWriter();
			out.print(jsonEntity);
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();			
		}		 */
		
		
    }
}
