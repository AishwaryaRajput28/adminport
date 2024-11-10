// payment_details.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class PaymentDetailsPage extends StatelessWidget {
  final CollectionReference kuliCollection = FirebaseFirestore.instance.collection('kulis');
  
  get DateFormat => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Details"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: kuliCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          List<DocumentSnapshot> kulies = snapshot.data!.docs;
          return ListView.builder(
            itemCount: kulies.length,
            itemBuilder: (context, index) {
              DocumentSnapshot kuli = kulies[index];
              DateTime lastPayoutDate = DateTime.parse(kuli['lastPayoutDate']);
              double totalEarnings = kuli['totalEarnings'];
              bool isEligible = DateTime.now().difference(lastPayoutDate).inDays >= 15;

              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kuli: ${kuli['name']}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("Total Earnings: ₹$totalEarnings"),
                      Text("Last Payout Date: ${DateFormat.yMMMd().format(lastPayoutDate)}"),
                      SizedBox(height: 10),
                      isEligible
                          ? ElevatedButton(
                              onPressed: () => initiatePayout(context, kuli.id),
                              child: Text("Payout 75%"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            )
                          : Text("Payout not yet eligible", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scanQRCode(); // Function to scan QR code before processing payout
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }

  void initiatePayout(BuildContext context, String kuliId) async {
    // Fetch the Kuli's data from Firestore
    DocumentSnapshot kuliData = await kuliCollection.doc(kuliId).get();
    double totalEarnings = kuliData['totalEarnings'];
    double payoutAmount = totalEarnings * 0.75;

    // Update Firestore with the payout and reset total earnings
    await kuliCollection.doc(kuliId).update({
      'lastPayoutDate': DateTime.now().toIso8601String(),
      'totalEarnings': 0, // Reset earnings after payout
    });

    // Log payout in a separate collection if needed
    await FirebaseFirestore.instance.collection('payouts').add({
      'kuliId': kuliId,
      'payoutAmount': payoutAmount,
      'payoutDate': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payout of ₹$payoutAmount successful for ${kuliData['name']}")),
    );
  }

  void scanQRCode() async {
    // Implement QR scanning functionality here
  }
}
