import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // Import your firebase_options.dart
import 'admin_login_page.dart'; // Import your Admin Login Page

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that plugin services are initialized
  await Firebase.initializeApp(
    options: firebaseOptions, // Use your constant here
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuli and Traveler Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminLoginPage(), // Change this to your desired initial screen
    );
  }
}

class KuliTravelerDataScreen extends StatefulWidget {
  @override
  _KuliTravelerDataScreenState createState() => _KuliTravelerDataScreenState();
}

class _KuliTravelerDataScreenState extends State<KuliTravelerDataScreen> {
  List<Map<String, dynamic>> kuliData = [];
  List<Map<String, dynamic>> travelerData = [];
  bool isLoading = true; // To show loading spinner

  // Fetch Kuli data
  Future<List<Map<String, dynamic>>> fetchKuliData() async {
    List<Map<String, dynamic>> kuliList = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('kuli').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        kuliList.add(data);
      }
    } catch (e) {
      print('Error fetching Kuli data: $e');
    }
    return kuliList;
  }

  // Fetch Traveler data
  Future<List<Map<String, dynamic>>> fetchTravelerData() async {
    List<Map<String, dynamic>> travelerList = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('traveler').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        travelerList.add(data);
      }
    } catch (e) {
      print('Error fetching Traveler data: $e');
    }
    return travelerList;
  }

  // Load both data sets (Kuli and Traveler)
  Future<void> loadData() async {
    try {
      List<Map<String, dynamic>> kuli = await fetchKuliData();
      List<Map<String, dynamic>> traveler = await fetchTravelerData();
      setState(() {
        kuliData = kuli;
        travelerData = traveler;
        isLoading = false; // Data is loaded
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData(); // Fetch data when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuli & Traveler Data'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show spinner when loading
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView( // Scrollable view to handle large data
                child: Column(
                  children: [
                    // Display Kuli Data
                    kuliData.isEmpty
                        ? Center(child: Text('No Kuli Data Available'))
                        : buildDataSection('Kuli Data', kuliData, 'profileImage'),
                    SizedBox(height: 20),
                    // Display Traveler Data
                    travelerData.isEmpty
                        ? Center(child: Text('No Traveler Data Available'))
                        : buildDataSection('Traveler Data', travelerData, 'photo_url'),
                  ],
                ),
              ),
            ),
    );
  }

  // Function to build Kuli/Traveler Data Section
  Widget buildDataSection(String title, List<Map<String, dynamic>> data, String imageKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true, // Important to use with ListView inside SingleChildScrollView
          physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
          itemCount: data.length,
          itemBuilder: (context, index) {
            var item = data[index];
            return Card(
              child: ListTile(
                leading: item[imageKey] != null
                    ? Image.network(item[imageKey]) // Display image if available
                    : Icon(Icons.person), // Fallback icon
                title: Text(item['name'] ?? 'No name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${item['phone'] ?? 'No phone'}'),
                    if (title == 'Kuli Data')
                      Text('Station: ${item['station'] ?? 'No station'}'),
                    if (title == 'Kuli Data')
                      Text('Status: ${item['status'] ?? 'No status'}'),
                    Text('ID: ${item[title == 'Kuli Data' ? 'kuliId' : 'travelerId'] ?? 'No ID'}'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
