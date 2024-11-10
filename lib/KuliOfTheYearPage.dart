import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KuliOfTheYearPage extends StatefulWidget {
  @override
  _KuliOfTheYearPageState createState() => _KuliOfTheYearPageState();
}

class _KuliOfTheYearPageState extends State<KuliOfTheYearPage> {
  Map<String, dynamic>? kuliOfTheYear; // To store Kuli of the Year data

  @override
  void initState() {
    super.initState();
    fetchKuliOfTheYear(); // Fetch Kuli of the Year data when the page loads
  }

  // Function to fetch Kuli data and determine the Kuli of the Year
  Future<void> fetchKuliOfTheYear() async {
    try {
      final kuliCollection = FirebaseFirestore.instance.collection('kuli');
      final bookingsCollection = FirebaseFirestore.instance.collection('bookingsDone');
      final ratingsCollection = FirebaseFirestore.instance.collection('ratings');

      QuerySnapshot kuliSnapshot = await kuliCollection.get();
      QuerySnapshot bookingSnapshot = await bookingsCollection.get();
      QuerySnapshot ratingsSnapshot = await ratingsCollection.get();

      Map<String, dynamic> kuliMetrics = {};

      // Calculate metrics for each Kuli
      for (var kuliDoc in kuliSnapshot.docs) {
        final kuliId = kuliDoc.id;
        final kuliData = kuliDoc.data() as Map<String, dynamic>;

        // Initialize metrics
        double totalPrice = 0;
        int totalBookings = 0;
        double totalRating = 0;
        int ratingCount = 0;

        // Calculate total earnings and bookings
        for (var bookingDoc in bookingSnapshot.docs) {
          if (bookingDoc['kuliId'] == kuliId) {
            totalPrice += bookingDoc['price'] ?? 0;
            totalBookings++;
          }
        }

        // Calculate average rating
        for (var ratingDoc in ratingsSnapshot.docs) {
          if (ratingDoc['kuliId'] == kuliId) {
            totalRating += ratingDoc['rating'] ?? 0;
            ratingCount++;
          }
        }

        double averageRating = ratingCount > 0 ? totalRating / ratingCount : 0;

        // Store metrics for each Kuli
        kuliMetrics[kuliId] = {
          'data': kuliData,
          'totalPrice': totalPrice,
          'totalBookings': totalBookings,
          'averageRating': averageRating,
        };
      }

      // Determine Kuli of the Year based on metrics
      kuliOfTheYear = kuliMetrics.values.reduce((topKuli, currentKuli) {
        if (currentKuli['totalPrice'] > topKuli['totalPrice'] ||
            (currentKuli['totalPrice'] == topKuli['totalPrice'] &&
             currentKuli['totalBookings'] > topKuli['totalBookings']) ||
            (currentKuli['totalPrice'] == topKuli['totalPrice'] &&
             currentKuli['totalBookings'] == topKuli['totalBookings'] &&
             currentKuli['averageRating'] > topKuli['averageRating'])) {
          return currentKuli;
        }
        return topKuli;
      });

      setState(() {}); // Update the UI with the selected Kuli of the Year
    } catch (e) {
      print("Error fetching Kuli of the Year: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kuli of the Year"),
        backgroundColor: Colors.redAccent, // Zomato-like red color
        centerTitle: true,
      ),
      body: kuliOfTheYear == null
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Center(
                child: Card(
                  elevation: 8, // Shadow for depth
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Kuli of the Year",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(height: 20),
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: kuliOfTheYear!['data']['profileImageUrl'] != null
                              ? NetworkImage(kuliOfTheYear!['data']['profileImageUrl'])
                              : null,
                          backgroundColor: Colors.grey.shade300, // Fallback color if image URL is null
                        ),
                        SizedBox(height: 15),
                        Text(
                          kuliOfTheYear!['data']['name'] ?? "N/A",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Total Earnings: ₹${kuliOfTheYear!['totalPrice']}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "Total Bookings: ${kuliOfTheYear!['totalBookings']}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "Average Rating: ${kuliOfTheYear!['averageRating'].toStringAsFixed(1)}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: fetchKuliOfTheYear,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Refresh Data",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
