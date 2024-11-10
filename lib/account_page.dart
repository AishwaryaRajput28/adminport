import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuli Accounts'),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('accounts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Show loading indicator while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Check if there is no data or the documents are empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No account data available'),
            );
          }

          // Display data in a list
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              final accountData = doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.only(bottom: 16.0),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.red.withOpacity(0.3),
                    width: 2.0,
                  ),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display Kuli data fields
                      Text(
                        "Kuli ID: ${accountData['kuliId'] ?? 'N/A'}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Kuli Name: ${accountData['kuliName'] ?? 'N/A'}"),
                      Text("Phone Number: ${accountData['phoneNumber'] ?? 'N/A'}"),
                      Text("UPI Name: ${accountData['upiName'] ?? 'N/A'}"),

                      // Check if the scanner image URL is available
                      if (accountData['scannerImage'] != null)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              accountData['scannerImage'],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                print("Error loading image: $exception"); // Log the error
                                return Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ),
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
