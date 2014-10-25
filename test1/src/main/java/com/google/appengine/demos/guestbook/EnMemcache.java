package com.google.appengine.demos.guestbook;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

import java.io.IOException;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.memcache.ErrorHandlers;


public class EnMemcache  extends HttpServlet {
	public void doPost (HttpServletRequest req, HttpServletResponse res)  throws ServletException, IOException{
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
	    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	    String key = req.getParameter("key");
	    String value = req.getParameter("value");
	    
	    String v = (String) syncCache.get(key);
	    if (v == null) {
	    	syncCache.put(key, value); // populate cache
		}
	    res.sendRedirect("/memCache.jsp?key=" + key);	    
	}
	 
	    
	    

}
