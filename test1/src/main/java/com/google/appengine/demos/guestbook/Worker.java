package com.google.appengine.demos.guestbook;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class Worker extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String key = request.getParameter("key");
        // Do something with key.        
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();            
        Entity task = new Entity("TaskData",key);
        Date date = new Date();
        task.setProperty("key", key);
        task.setProperty("value", request.getParameter("value"));
        task.setProperty("date",date);     
        datastore.put(task);   
  
    }
}