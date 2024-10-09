import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TravelerDataPage extends StatefulWidget {
  @override
  _TravelerDataPageState createState() => _TravelerDataPageState();
}

class _TravelerDataPageState extends State<TravelerDataPage> {
  late Future<List<Map<String, dynamic>>> _travelerData;

  @override
  void initState() {
    super.initState();
    _travelerData = fetchTravelerData();
  }

  Future<List<Map<String, dynamic>>> fetchTravelerData() async {
    List<Map<String, dynamic>> travelerList = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('traveler').get();
      print("Number of traveler documents fetched: ${querySnapshot.docs.length}"); // Debug print
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("Fetched Traveler data: $data"); // Debug print
        travelerList.add(data);
      }
    } catch (e) {
      print('Error fetching traveler data: $e');
    }
    return travelerList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Traveler Data"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _travelerData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Traveler data available"));
          } else {
            List<Map<String, dynamic>> travelerData = snapshot.data!;
            return ListView.builder(
              itemCount: travelerData.length,
              itemBuilder: (context, index) {
                var traveler = travelerData[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: traveler['profileImage'] != null
                        ? Image.network(traveler['profileImage'])
                        : Icon(Icons.person),
                    title: Text(traveler['name'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${traveler['email'] ?? 'N/A'}'),
                        Text('Phone: ${traveler['phone'] ?? 'N/A'}'),
                        // Add more fields as needed
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      ),
    );
  }
}
