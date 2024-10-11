import 'package:flutter/material.dart';
import 'kuli_data_page.dart'; // Import the Kuli data page
import 'traveler_data_page.dart'; // Import the Traveler data page
import 'admin_registration_page.dart'; // Not used in this example
import 'admin_login_page.dart'; // Not used in this example

class AdminPortal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Portal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kuli Data Card
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KuliDataPage()), // Navigate to KuliDataPage
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.people, size: 50, color: Colors.blue),
                        SizedBox(height: 10),
                        Text(
                          "View Kuli Data",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20), // Space between cards

              // Traveler Data Card
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TravelerDataPage()), // Navigate to TravelerDataPage
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.directions_walk, size: 50, color: Colors.green),
                        SizedBox(height: 10),
                        Text(
                          "View Traveler Data",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
