cs263 Project  TravelPlan

http://starlit-tube-728.appspot.com/

1. Welcome Page
Sign in:    You can sign in with your googl account by clicking the sign in link on the upper right corner.
            If you click other links without signning in, you will also be direced to the sign in page.
Sign out:   After sign in, you can see a welcom information and also a sign out link. You can click to sign out.
PlanATrip:  Create a new plan
MyPlans:    View and update plans
MyAlbum:    Create/delete/view albums

2. New Trip Page
Enter the name of your trip.  Name can not be empty or same with exsited plan. You will get an alert about this.
Choose the start date of your trip.

3. Add plan details
   four tabs:  activities, food & drinks, hotel, flight
   activity:  search for interesting places OR enter activity information directly
   food & drinks: search for restaurants  OR enter restaurant information directly
   hotel: enter hotel information
   flight: enter flight informaion.  If you want an alert email about the flight, you need to enter a valid time as requested. Also you need to check the checkbox. You will get an alert email 3 hours before the flight.
The right half page show the plan summary. Every time you add a new activity, the summary should be updated.

4. Search Result Page
At this page, you will see the results listed on the left page. Also there are markers on the google map.
In order to add a place or restaurant to your plan, you can either click the photo or click the marker. Then you can click the "Add to plan" link in the information window.  In the following page, you can enter other information about this plan.

5. Show all plans
All the existed plan are listed and sorted by date.  You can click the delete button to delete the whole plan or Click the plan name to see the details of the plan.

6. Show all details of a plan
All the details about this plan are listed. The details are ordered by day number.
You can update the detail by cliking the activity name or delete by cliking the button. Also you can add a new activity by cliking the link on the buttom.

7. Show all albums
All the created albums are shown in this page. The album cover should be the first photo in this album. If there is no photo in this album, the album shows" No available image"
.   
You can click the album to view all photos. Also you can click the "add new album" link to create a new album.

8. Create new Album
Enter the name of your album. Name can not be empty or same with exsited album.

9. Gallery Page
Show all the photos in a slid format. You can click the "add photo" link to add photos to this gallery or click "delete photo" link to a photo deletion page.

10. Photo deletion Page
list all the photos and each photo has a delete button. You  can delete any one photo per time. 











==========12/01==============

What have been done:

 Show the photos in one albums as slides
 
 What to do next:

1. Allow users to add comments and title for each photo
2. Fix the bugs in the photo album
 
==========11/23==============

What have been done:

1. Allow user to create their photo album and upload images 
2. store the images in blobstore
3. create entity corresponding to the images
4. Allow users to check their albums

What to do next:

1. Show the photos in one albums as slides
2. Allow users to add comments and title for each photo

==========11/16==============

What have been done:

1. Allow users to check and update their existed plan
2. Allow users to add hotel and flight information

What to do next:

1. Allow user to create their photo album

==========11/14==============

What have been done:

1. Fix the bug in showing photos
2. Enable the links for user to add activity from search result

What to do next:

1. Allow user to check their existed plan
2. Allow user to update their existed plan.

==========11/09==============

What have been done:

1. Show photos for search results

What to do next:

1. Fix the bug in showing photos
2. allow users to add an activity or food in a certain plan by clicking the search result.

==========11/07==============

What have been done:

1. Allow users to add plan details(food and activity), store details in datastore
2. read plan details from datastore
3. Allow users to search activities or food in a certian place,  show results in google map

What to do next:

1. Show details(title, picture,rate) of search results(food or activity) in a list
2. allow users to add an activity or food in a certain plan by clicking the search result.



==========11/02==============

What have been done:

1. Welcom page
2. Login and logout using google account
3. Create a new trip plan and push into datastore 

What to do next:

Allow users to create details of the plan including finding something to do and something tasty.
