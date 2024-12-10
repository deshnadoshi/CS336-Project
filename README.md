# CS336-Project
## Group 17 - Deshna Doshi, Palak Singh, Maria Jaral, Jasmine Hanjra

Design Specifications/Simplifying Assumptions: 
- Customers and employees (administrators and customer representatives) are given different login credentials.
- We assume that only customers are allowed to register an account.
- Registration requires a unique username and email.
- We assume that the username and password required to login to your mySQLServer is 'root' and 'root'. If this is not the case, please edit the ApplicationDB.java class to use your username and password. 
- We have used the 'COLLATE' command to make the password case sensitive. For example, trains123 is not the same as TRAINS123.
- To simplify transactions, we assume that sales aren't complete until the day of the reservation. As such, the Monthly Sales Report refers to the month of the reservation rather than the month the reservation was created.
- Each reservation has the following possible statuses: CONFIRMED, CHANGED, CANCELLED. The default status is CONFIRMED. If a customer representative changes train schedule information, the reservation status corresponding to that train schedule will be set to CHANGED. If a customer representative deletes a train schedule of a customer cancels their reservation, the reservations status will be set to CANCELLED.
- We determine the top five transit lines per month on the administrator dashboard. We display only the months for which reservations were made. In the sample data, there may not always be months that have more than 5 transit lines that are booked. In such a case, we rank the number of transit lines that are booked in that month. 
- Due to the 10 minute time limit, the demo video does not display any edge cases or invalid input entries, such as incorrect password. All of these cases have be thoroughly tested and the code has been checked to confirm that it does not produce an error.
- We make some simplifying assumptions about allowing customer representatives to change train schedules. For example, if a customer representative changes train schedule information after a customer has already made a booking for that train schedule, we do not change the customer's reservation. We simply update the reservation's status to CHANGED, indicating that the customer must make note of changes made to the train schedule. For example, if a customer representative changes the fare of a train to $80 after a customer has previously made a reservation with the previous fare of $50, we will not be increasing the customer's fare. However, any new reservations a customer makes will take into account this new fare.
- In some cases, to navigate to the dashboard (for admin and customer representatives) you might have to click the 'back' arrow multiple times. We recommend using ctrl-click to open up links from the dashboard onto a new page to avoid doing this.
- Please navigate to the following URL to access the web application: http://localhost: {your configured HTTP port number} /RailwayBooking/. For example, we used HTTP Port 8081, so the URL is: http://localhost:8081/RailwayBooking/. 

#### *Valid Customer Login Information:*

Username: dd1035 | Password: trains123


#### *Valid Customer Representative Login Information*

Username: jane | Password: trains


#### *Valid Administrator Login Information*

Username: admin | Password: admin


