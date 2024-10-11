import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TravelerDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Traveler Data"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('travelers').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.hasData) {
            final travelerList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: travelerList.length,
              itemBuilder: (context, index) {
                final traveler = travelerList[index].data() as Map<String, dynamic>;

                // Fetch fields with null checks
                final travelerName = traveler['travelerName'] ?? 'Unknown'; // Default value for travelerName
                final phone = traveler['phone'] ?? 'N/A'; // Default value for phone
                final email = traveler['email'] ?? 'N/A'; // Default value for email
                final photoUrl = traveler['photoUrl'] ?? ''; // Default value for photoUrl (consider handling empty state)

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: photoUrl.isNotEmpty 
                        ? NetworkImage(photoUrl) 
                        : AssetImage('assets/placeholder.png') as ImageProvider, // Use a placeholder image if photoUrl is empty
                    ),
                    title: Text(travelerName),
                    subtitle: Text(
                      "Phone: $phone\nEmail: $email",
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          }
          return Center(child: Text("No Traveler data found"));
        },
      ),
    );
  }
}
