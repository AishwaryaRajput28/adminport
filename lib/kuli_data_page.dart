import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KuliDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kuli Data"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('kuli').get(), // Retrieve all Kuli documents
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Error message
          }
          if (snapshot.hasData) {
            final kuliList = snapshot.data!.docs;

            if (kuliList.isEmpty) {
              return Center(child: Text("No Kuli data found")); // Message when no data
            }

            return ListView.builder(
              itemCount: kuliList.length,
              itemBuilder: (context, index) {
                final kuli = kuliList[index].data() as Map<String, dynamic>; // Retrieve document data
                
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        kuli['profileImage'] ?? 'https://example.com/default-image.png', // Provide a default image
                      ),
                      // Add a placeholder if the image fails to load
                    ),
                    title: Text(kuli['name'] ?? "Unnamed Kuli"), // Provide a fallback name
                    subtitle: Text(
                      "Phone: ${kuli['phone'] ?? 'N/A'}\n"
                      "Email: ${kuli['email'] ?? 'N/A'}\n"
                      "Station: ${kuli['station'] ?? 'N/A'}",
                      // Display Kuli's phone, email, and station
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          }
          return Center(child: Text("No Kuli data found")); // Message when no data
        },
      ),
    );
  }
}
