import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TravelerDataPage extends StatelessWidget {
  // Function to delete a specific Traveler document
  Future<void> deleteTraveler(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('travelers').doc(documentId).delete();
    } catch (e) {
      print("Error deleting Traveler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Traveler Data"),
        centerTitle: true, // Center the title
        backgroundColor: Colors.redAccent, // Zomato-like red accent color
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
                final travelerDoc = travelerList[index];
                final traveler = travelerDoc.data() as Map<String, dynamic>;

                // Fetch fields with null checks
                final travelerName = traveler['travelerName'] ?? 'Unknown';
                final phone = traveler['phone'] ?? 'N/A';
                final email = traveler['email'] ?? 'N/A';

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners for a sleek look
                  ),
                  color: Colors.red[50], // Light red background for cards
                  child: ListTile(
                    leading: Icon(
                      Icons.travel_explore, // Replace with a relevant icon
                      size: 40,
                      color: Colors.redAccent, // Zomato-like icon color
                    ),
                    title: Text(
                      travelerName,
                      textAlign: TextAlign.center, // Center the title
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                    subtitle: Text(
                      "Phone: $phone\nEmail: $email",
                      textAlign: TextAlign.center, // Center the subtitle text
                      style: TextStyle(color: Colors.black87), // Dark text for readability
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent), // Red delete icon
                      onPressed: () async {
                        bool? confirmDelete = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Delete Traveler"),
                            content: Text("Are you sure you want to delete this traveler?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text("Delete", style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        );
                        if (confirmDelete == true) {
                          deleteTraveler(travelerDoc.id);
                        }
                      },
                    ),
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
