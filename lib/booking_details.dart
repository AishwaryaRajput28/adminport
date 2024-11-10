import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Details"),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Debugging: Print the data fetched from Firestore
          print("Snapshot data: ${snapshot.data?.docs}");

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No booking data available."));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              final bookingData = doc.data() as Map<String, dynamic>;
              final kuliData = bookingData['kuli'] as Map<String, dynamic>?;
              final travelerData = bookingData['traveler'] as Map<String, dynamic>?;

              // Debugging: Print each document data
              print("Booking Document Data: $bookingData");

              return Card(
                margin: EdgeInsets.only(bottom: 16.0),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.red.withOpacity(0.3), // Border color matching red tone
                    width: 2.0, // Slightly thicker border for visibility
                  ),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kuli Information
                      Text(
                        "Kuli Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Name: ${kuliData?['name'] ?? 'N/A'}"),
                      Text("Kuli ID: ${kuliData?['kuliId'] ?? 'N/A'}"),
                      Text("Phone: ${kuliData?['phone'] ?? 'N/A'}"),
                      Text("Station: ${kuliData?['station'] ?? 'N/A'}"),
                      Text("Luggage Count: ${kuliData?['luggage'] ?? 'N/A'}"),
                      Text(
                        "Service Status: ${kuliData?['serviceStatus'] == true ? 'Available' : 'Unavailable'}",
                        style: TextStyle(color: kuliData?['serviceStatus'] == true ? Colors.green : Colors.red),
                      ),
                      Text("Status: ${kuliData?['status'] ?? 'N/A'}"),
                      if (kuliData?['profileImage'] != null)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(kuliData!['profileImage'], height: 100, width: 100, fit: BoxFit.cover),
                          ),
                        ),
                      SizedBox(height: 16),

                      // Traveler Information
                      Text(
                        "Traveler Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Name: ${travelerData?['name'] ?? 'N/A'}"),
                      Text("Traveler ID: ${travelerData?['travelerId'] ?? 'N/A'}"),
                      Text("Phone Number: ${travelerData?['phone_number'] ?? 'N/A'}"),
                      Text("Destination: ${travelerData?['destination'] ?? 'N/A'}"),
                      Text("Arrival Date: ${travelerData?['arrival_date'] ?? 'N/A'}"),
                      Text("Arrival Time: ${travelerData?['arrival_time'] ?? 'N/A'}"),
                      Text("Train Name: ${travelerData?['train_name'] ?? 'N/A'}"),
                      if (travelerData?['photo_url'] != null)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(travelerData!['photo_url'], height: 100, width: 100, fit: BoxFit.cover),
                          ),
                        ),
                      SizedBox(height: 16),

                      // Booking Details
                      Text(
                        "Booking Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Booking Timestamp: ${bookingData['bookingTimestamp'] ?? 'N/A'}"),
                      Text("Status: ${bookingData['status'] ?? 'N/A'}"),
                      Text("Price: ${bookingData['price'] ?? 'N/A'}"),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
