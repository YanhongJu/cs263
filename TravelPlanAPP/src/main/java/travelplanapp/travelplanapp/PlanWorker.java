/*public class CreatePlanWorker extends HttpServlet{
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
		try {
			plan = datastore.get(planKey);
			Gson gson = new GsonBuilder().setPrettyPrinting().create();
			String jsonEntity = gson.toJson(plan);			
			PrintWriter out = response.getWriter();
			out.print(jsonEntity);
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();			
		}		 
		
		
    }*/