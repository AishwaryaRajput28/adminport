import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseOptions,
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
      home: KuliTravelerDataScreen(),
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
    List<Map<String, dynamic>> kuli = await fetchKuliData();
    List<Map<String, dynamic>> traveler = await fetchTravelerData();
    setState(() {
      kuliData = kuli;
      travelerData = traveler;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: kuliData.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kuli Data:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: kuliData.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(kuliData[index]['name'] ?? 'No name'),
                                subtitle: Text('ID: ${kuliData[index]['id'] ?? 'No ID'}'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: travelerData.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Traveler Data:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: travelerData.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(travelerData[index]['name'] ?? 'No name'),
                                subtitle: Text('ID: ${travelerData[index]['id'] ?? 'No ID'}'),
                              );
                            },
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
}
