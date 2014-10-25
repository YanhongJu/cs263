package com.google.appengine.demos.guestbook;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class ReadDataServlet extends HttpServlet {
	@Override
	  public void doGet(HttpServletRequest req, HttpServletResponse resp)
	      throws IOException {	      
	      resp.sendRedirect("/testdata.jsp?=" + "TaskData");
	    
	  }
}
