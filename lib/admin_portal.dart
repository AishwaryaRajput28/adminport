import 'package:flutter/material.dart';
import 'kuli_data_page.dart'; // Import the Kuli data page
import 'traveler_data_page.dart'; // Import the Traveler data page (if used)


class AdminPortal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Portal"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button to view Kuli Data
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KuliDataPage()), // Navigate to KuliDataPage
                );
              },
              child: const Text("View Kuli Data"),
            ),

            SizedBox(height: 20), // Space between buttons

            // Button to view Traveler Data
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TravelerDataPage()), // Navigate to TravelerDataPage
                );
              },
              child: const Text("View Traveler Data"),
            ),
          ],
        ),
      ),
    );
  }
}
