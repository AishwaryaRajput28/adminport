import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Colors.red, // Zomato-like theme color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No feedback data available."));
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                final feedbackData = doc.data() as Map<String, dynamic>;

                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Feedback Information
                        Text(
                          "Feedback Information",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        SizedBox(height: 8),
                        Text("Traveler Name: ${feedbackData['travelerName'] ?? 'N/A'}"),
                        Text("Traveler ID: ${feedbackData['travelerId'] ?? 'N/A'}"),
                        Text("Kuli Name: ${feedbackData['kuliName'] ?? 'N/A'}"),
                        Text("Kuli ID: ${feedbackData['kuliId'] ?? 'N/A'}"),
                        Text("Rating: ${feedbackData['rating'] ?? 'N/A'}"),
                        Text("Feedback: ${feedbackData['feedbackText'] ?? 'N/A'}"),
                        Text("Service Date: ${feedbackData['serviceDate'] != null ? (feedbackData['serviceDate'] as Timestamp).toDate().toString() : 'N/A'}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
