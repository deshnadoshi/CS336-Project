# CS336-Project
## Group 17 - Deshna Doshi, Palak Singh, Maria Jaral, Jasmine Hanjra

### Part 2: Login Page

Design Specifications: 
- We have implemented a separate login for Customers and Employees
- We assume that only Customers are allowed to Register
- Registration requires a unique username and email
- We assume that the username and password required to login to your mySQLServer is 'root' and 'root'
- We have used the 'COLLATE' command to make the password case sensitive. For example, trains123 is not the same as TRAINS123
- Please navigate to the following URL to access the web application: http://localhost: {your configured HTTP port number} /RailwayBooking/. For example, we used HTTP Port 8081, so the URL is: http://localhost:8081/RailwayBooking/. 

#### *Valid Customer Login Information:*

Username: dd1035 | Password: trains123


#### *Valid Employee Login Information*

Username: maria | Password: pword123

_Note_: The valid login information mentioned above is automatically populated into the 'customers' and 'employees' tables (via INSERT statements) through our .sql file (create_db.sql). You may import this .sql file directly into mySQL to create the database and table schemas used in this project.

___

### Part 3: Complete Website

Design Specifications: 

- (add in the point about the sales report being the month of the reservation instead of the month the reservation was made)
- (changing username and password to connect to the sql db)
- (demo video doesn't show edge cases/invalid cases, weve tested this already demo video NOT ENUF TIME to fit everything in)
- reservation statsu explanation -- customer rep changes = changed, customer rep deltes trainschedu or user deletes = cancelled
- we're doing top 5 per month
