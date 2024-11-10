import 'package:flutter/material.dart';
import 'package:my_first_project/account_page.dart';
import 'kuli_data_page.dart';
import 'traveler_data_page.dart';
import 'bookings_data_page.dart';
import 'kulioftheyearpage.dart';
import 'booking_details.dart';
import 'feedback_page.dart'; // Import the Feedback page
import 'payment_details.dart'; // Import the Payment Details page
import 'account_page.dart'; // Import the Accounts page

class AdminPortal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Zomato-like app bar color
        title: Center(
          child: Text(
            "Admin Portal",
            style: TextStyle(
              fontSize: 24, // Set the font size as needed
              fontWeight: FontWeight.bold, // Optional: Make title bold
            ),
          ),
        ),
      ),
      backgroundColor: Colors.pink[50], // Set the background color to light pink
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Two columns for alignment
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                shrinkWrap: true,
                children: [
                  // Kuli Data Card
                  buildCard(
                    context,
                    "View Kuli Data",
                    Icons.people,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KuliDataPage()),
                    ),
                  ),

                  // Traveler Data Card
                  buildCard(
                    context,
                    "View Traveler Data",
                    Icons.directions_walk,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TravelerDataPage()),
                    ),
                  ),

                  // Bookings Data Card
                  buildCard(
                    context,
                    "View Bookings Data",
                    Icons.receipt,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingsDataPage()),
                    ),
                  ),

                  // Kuli of the Year Card
                  buildCard(
                    context,
                    "Kuli of the Year",
                    Icons.star,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KuliOfTheYearPage()),
                    ),
                  ),

                  // Payment Details Card
                  buildCard(
                    context,
                    "View Payment Details",
                    Icons.payment,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentDetailsPage()),
                    ),
                  ),
                  
                  // View Booking Details Card
                  buildCard(
                    context,
                    "View Booking Details",
                    Icons.assignment,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingDetails()),
                    ),
                  ),

                  // View Feedback Card
                  buildCard(
                    context,
                    "View Feedback",
                    Icons.feedback,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackPage()),
                    ),
                  ),

                  // Account Data Card
                  buildCard(
                    context,
                    "View Accounts",
                    Icons.account_balance,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountPage()), // Navigate to AccountsPage
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, String title, IconData icon, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: iconColor),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
