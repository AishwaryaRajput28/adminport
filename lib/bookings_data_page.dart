import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingsDataPage extends StatelessWidget {
  // Reference to the 'bookingDone' collection in Firestore
  final CollectionReference bookingDoneCollection =
      FirebaseFirestore.instance.collection('bookingDone');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Bookings Data")), // Center title in AppBar
        backgroundColor: Color(0xFFF40000), // Zomato Red color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookingDoneCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No booking data available"));
          }

          // Display the booking data in a list view
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var bookingData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              // Using null-aware access for each field
              String travelerName = bookingData['travelerName'] ?? 'N/A';
              String kuliId = bookingData['kuliId'] ?? 'N/A';
              String kuliName = bookingData['kuliName'] ?? 'N/A';
              String travelerId = bookingData['travelerId'] ?? 'N/A';
              String status = bookingData['status'] ?? 'N/A';
              String price = bookingData['price']?.toString() ?? '0';
              String bookingTimestamp = bookingData['bookingTimestamp']?.toString() ?? 'N/A';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 8, // More shadow for a more elegant look
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                color: Colors.white, // Background color for the card
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.white, size: 20), // Traveler Icon
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Traveler Name: $travelerName",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF40000), // Zomato Red for text
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.card_membership, color: Colors.white, size: 20), // Kuli ID Icon
                          SizedBox(width: 8),
                          Text("Kuli ID: $kuliId", style: TextStyle(fontSize: 16, color: Color(0xFF333333))),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.person_outline, color: Colors.white, size: 20), // Kuli Name Icon
                          SizedBox(width: 8),
                          Text("Kuli Name: $kuliName", style: TextStyle(fontSize: 16, color: Color(0xFF333333))),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.card_membership, color: Colors.white, size: 20), // Traveler ID Icon
                          SizedBox(width: 8),
                          Text("Traveler ID: $travelerId", style: TextStyle(fontSize: 16, color: Color(0xFF333333))),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.white, size: 20), // Status Icon
                          SizedBox(width: 8),
                          Text("Status: $status", style: TextStyle(fontSize: 16, color: Color(0xFF333333))),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.money, color: Colors.white, size: 20), // Price Icon
                          SizedBox(width: 8),
                          Text("Price: ₹$price", style: TextStyle(fontSize: 16, color: Color(0xFF333333))),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.white, size: 20), // Timestamp Icon
                          SizedBox(width: 8),
                          Text("Booking Timestamp: $bookingTimestamp", style: TextStyle(fontSize: 16, color: Color(0xFF333333))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
