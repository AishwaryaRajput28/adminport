import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KuliDataPage extends StatefulWidget {
  @override
  _KuliDataPageState createState() => _KuliDataPageState();
}

class _KuliDataPageState extends State<KuliDataPage> {
  late Future<List<Map<String, dynamic>>> _kuliData;

  @override
  void initState() {
    super.initState();
    _kuliData = fetchKuliData();
  }

  Future<List<Map<String, dynamic>>> fetchKuliData() async {
    List<Map<String, dynamic>> kuliList = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('kuli').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        kuliList.add(data);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return kuliList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kuli Data"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _kuliData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Kuli data available"));
          } else {
            List<Map<String, dynamic>> kuliData = snapshot.data!;
            return ListView.builder(
              itemCount: kuliData.length,
              itemBuilder: (context, index) {
                var kuli = kuliData[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: kuli['profileImage'] != null
                        ? Image.network(kuli['profileImage'])
                        : Icon(Icons.person),
                    title: Text(kuli['name'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Station: ${kuli['station'] ?? 'Unknown'}'),
                        Text('Experience: ${kuli['experience'] ?? 'N/A'} years'),
                        Text('Email: ${kuli['email'] ?? 'N/A'}'),
                        Text('Phone: ${kuli['phone'] ?? 'N/A'}'),
                        Text('Address: ${kuli['address'] ?? 'N/A'}'),
                        Text('DOB: ${(kuli['dob'] as Timestamp).toDate().toString()}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
