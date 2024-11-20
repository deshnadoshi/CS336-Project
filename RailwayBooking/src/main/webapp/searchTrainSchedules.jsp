<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    HttpSession currentsession = request.getSession(false);
    if (currentsession == null || currentsession.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Search Train Schedules</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h2>Search Train Schedules</h2>
	<form action="searchTrainSchedules.jsp" method="post">
	    <label for="origin">Origin Station:</label>
	    <select id="origin" name="origin" required>
	        <option value="">Select Origin</option>
	        <%
	            try {
	                ApplicationDB db = new ApplicationDB();
	                Connection con = db.getConnection();
	                Statement stmt = con.createStatement();
	                ResultSet rs = stmt.executeQuery("SELECT station_id, name FROM stations");
	
	                while (rs.next()) {
	                    int stationId = rs.getInt("station_id");
	                    String stationName = rs.getString("name");
	        %>
	                    <option value="<%= stationId %>"><%= stationName %></option>
	        <%
	                }
	                rs.close();
	                stmt.close();
	                con.close();
	            } catch (Exception e) {
	                out.println("Error: " + e.getMessage());
	            }
	        %>
	    </select><br><br>
	
	    <label for="destination">Destination Station:</label>
	    <select id="destination" name="destination" required>
	        <option value="">Select Destination</option>
	        <%
	            try {
	                ApplicationDB db = new ApplicationDB();
	                Connection con = db.getConnection();
	                Statement stmt = con.createStatement();
	                ResultSet rs = stmt.executeQuery("SELECT station_id, name FROM stations");
	
	                while (rs.next()) {
	                    int stationId = rs.getInt("station_id");
	                    String stationName = rs.getString("name");
	        %>
	                    <option value="<%= stationId %>"><%= stationName %></option>
	        <%
	                }
	                rs.close();
	                stmt.close();
	                con.close();
	            } catch (Exception e) {
	                out.println("Error: " + e.getMessage());
	            }
	        %>
	    </select><br><br>
	
	    <label for="date">Date of Travel:</label>
	    <input type="date" id="date" name="date" required><br><br>
	
	    <label for="sortBy">Sort By:</label>
	    <select id="sortBy" name="sortBy" required>
	        <option value="">Select Sorting Option</option>
	        <option value="departureTime_asc">Departure Time: Earliest to Latest</option>
	        <option value="departureTime_desc">Departure Time: Latest to Earliest</option>
	        <option value="arrivalTime_asc">Arrival Time: Earliest to Latest</option>
	        <option value="arrivalTime_desc">Arrival Time: Latest to Earliest</option>
	        <option value="fare_asc">Fare: Low to High</option>
	        <option value="fare_desc">Fare: High to Low</option>
	    </select><br><br>
	
	    <input type="submit" value="Search">
	</form>

    <h3>Search Results</h3>
    <div class="search-results">
	<%
	    String origin = request.getParameter("origin");
	    String destination = request.getParameter("destination");
	    String date = request.getParameter("date");
	    String sortBy = request.getParameter("sortBy");
	
	    // Default order by (if no sorting selected)
	    String orderByClause = "";
	
	    if (sortBy != null) {
	        switch (sortBy) {
	            case "departureTime_asc":
	                orderByClause = "ORDER BY ts.train_departure_time ASC";
	                break;
	            case "departureTime_desc":
	                orderByClause = "ORDER BY ts.train_departure_time DESC";
	                break;
	            case "arrivalTime_asc":
	                orderByClause = "ORDER BY ts.train_arrival_time ASC";
	                break;
	            case "arrivalTime_desc":
	                orderByClause = "ORDER BY ts.train_arrival_time DESC";
	                break;
	            case "fare_asc":
	                orderByClause = "ORDER BY ts.fare ASC";
	                break;
	            case "fare_desc":
	                orderByClause = "ORDER BY ts.fare DESC";
	                break;
	        }
	    }
	
	    if (origin != null && destination != null && date != null) {
	        try {
	            ApplicationDB db = new ApplicationDB();
	            Connection con = db.getConnection();
	
	            // Query to fetch trains that match the selected origin, destination, and date
	            String query = "SELECT ts.line_name, ts.fare, ts.train_arrival_time, ts.train_departure_time, " +
	                           "s1.name AS origin_name, s2.name AS destination_name " +
	                           "FROM trainschedules ts " +
	                           "JOIN stations s1 ON ts.origin_stop_station_id = s1.station_id " +
	                           "JOIN stations s2 ON ts.destination_stop_station_id = s2.station_id " +
	                           "WHERE ts.origin_stop_station_id = ? AND ts.destination_stop_station_id = ? " +
	                           orderByClause;
	
	            PreparedStatement ps = con.prepareStatement(query);
	            ps.setInt(1, Integer.parseInt(origin));
	            ps.setInt(2, Integer.parseInt(destination));
	            ResultSet rs = ps.executeQuery();
	
	            List<Map<String, Object>> trainSchedules = new ArrayList<>();
	            while (rs.next()) {
	                Map<String, Object> schedule = new HashMap<>();
	                schedule.put("lineName", rs.getString("line_name"));
	                schedule.put("originName", rs.getString("origin_name"));
	                schedule.put("destinationName", rs.getString("destination_name"));
	                schedule.put("trainArrivalTime", rs.getString("train_arrival_time"));
	                schedule.put("trainDepartureTime", rs.getString("train_departure_time"));
	                schedule.put("fare", String.valueOf(rs.getInt("fare")));
	
	                // Get stops for the train
	                String lineName = rs.getString("line_name");
	                String stopsQuery = "SELECT s.name AS station_name, sa.stop_arrival_time, sa.stop_departure_time " +
	                                     "FROM stops_at sa " +
	                                     "JOIN stations s ON sa.station_id = s.station_id " +
	                                     "WHERE sa.line_name = ? ORDER BY sa.stop_arrival_time";
	
	                PreparedStatement stopsStmt = con.prepareStatement(stopsQuery);
	                stopsStmt.setString(1, lineName);
	                ResultSet stopsRs = stopsStmt.executeQuery();
	
	                List<Map<String, String>> stops = new ArrayList<>();
	                while (stopsRs.next()) {
	                    Map<String, String> stop = new HashMap<>();
	                    stop.put("stationName", stopsRs.getString("station_name"));
	                    stop.put("arrivalTime", stopsRs.getString("stop_arrival_time"));
	                    stop.put("departureTime", stopsRs.getString("stop_departure_time"));
	                    stops.add(stop);
	                }
	
	                schedule.put("stops", stops); // Store stops directly as a List of Maps
	                stopsRs.close();
	                stopsStmt.close();
	
	                trainSchedules.add(schedule);
	            }
	
	            // Output the train schedule with stops
	            for (Map<String, Object> schedule : trainSchedules) {
	    %>
	                <div class="train-schedule">
	                    <h3><%= schedule.get("lineName").toString().toUpperCase() %></h3>
	                    <p><strong>Origin:</strong> <%= schedule.get("originName") %></p>
	                    <p><strong>Destination:</strong> <%= schedule.get("destinationName") %></p>
	                    <p><strong>Departure:</strong> <%= schedule.get("trainDepartureTime") %></p>
	                    <p><strong>Arrival:</strong> <%= schedule.get("trainArrivalTime") %></p>
	                    <p><strong>Fare:</strong> $<%= schedule.get("fare") %></p>
	
	                    <h4>Train Stops:</h4>
	                    <ul>
	                        <%
	                            // Display all stops for the train
	                            List<Map<String, String>> stops = (List<Map<String, String>>) schedule.get("stops");
	                            for (Map<String, String> stop : stops) {
	                        %>
	                            <li><%= stop.get("stationName") %> - Arrival: <%= stop.get("arrivalTime") %> - Departure: <%= stop.get("departureTime") %></li>
	                        <%
	                            }
	                        %>
	                    </ul>
	                    
						<form action="reserveTrain.jsp" method="post">
							<input type="hidden" name="lineName" value="<%= schedule.get("lineName") %>">
							<input type="hidden" name="origin" value="<%= schedule.get("originName") %>">
							<input type="hidden" name="destination" value="<%= schedule.get("destinationName") %>">
							<input type="hidden" name="date" value="<%= date %>">
							<input type="hidden" name="departureTime" value="<%= schedule.get("trainDepartureTime") %>">
							<input type="hidden" name="arrivalTime" value="<%= schedule.get("trainArrivalTime") %>">
							<input type="hidden" name="fare" value="<%= schedule.get("fare") %>">
							<input type="submit" value="Reserve">
						</form>
	                    
	                </div>
	    <%
	            }
	            rs.close();
	            ps.close();
	            con.close();
	        } catch (Exception e) {
	            out.println("Error: " + e.getMessage());
	        }
	    } else {
	    %>
	            <p>No results found. Please select origin, destination, and date.</p>
	    <%
	    }
	%>
    </div>
</body>
</html>
