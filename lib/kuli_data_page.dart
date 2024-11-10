import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KuliDataPage extends StatelessWidget {
  // Function to delete a specific Kuli document
  Future<void> deleteKuli(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('kuli').doc(documentId).delete();
    } catch (e) {
      print("Error deleting Kuli: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Kuli Data",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red, // Complementing previous color
      ),
      backgroundColor: Colors.pink[50], // Light pink background
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
              return Center(child: Text("No Kuli data found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))); // Message when no data
            }

            return ListView.builder(
              itemCount: kuliList.length,
              itemBuilder: (context, index) {
                final kuliDoc = kuliList[index];
                final kuli = kuliDoc.data() as Map<String, dynamic>; // Retrieve document data

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white, // Card color for a subtle effect
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.person, // Kuli icon
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      kuli['name'] ?? "Unnamed Kuli",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      "Phone: ${kuli['phone'] ?? 'N/A'}\n"
                      "Email: ${kuli['email'] ?? 'N/A'}\n"
                      "Station: ${kuli['station'] ?? 'N/A'}",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool? confirmDelete = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Delete Kuli"),
                            content: Text("Are you sure you want to delete this Kuli?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text("Delete", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirmDelete == true) {
                          deleteKuli(kuliDoc.id);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text("No Kuli data found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))); // Message when no data
        },
      ),
    );
  }
}
