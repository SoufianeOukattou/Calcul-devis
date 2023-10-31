import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calculdevis/my_drawer_header.dart';
import 'package:calculdevis/DrawerList.dart';

class RemiseSettingsPage extends StatefulWidget {
  @override
  _RemiseSettingsPageState createState() => _RemiseSettingsPageState();
}

class _RemiseSettingsPageState extends State<RemiseSettingsPage> {
  final TextEditingController _poutrelleRemiseController = TextEditingController();
  final TextEditingController _agglosRemiseController = TextEditingController();
  final TextEditingController _hourdisRemiseController = TextEditingController();

  Future<void> _fetchSettings() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('remiseSettings')
          .doc('settings')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        _poutrelleRemiseController.text = data['poutrelleRemise'];
        _agglosRemiseController.text = data['agglosRemise'];
        _hourdisRemiseController.text = data['hourdisRemise'];
      }
    } catch (e) {
      print('Error fetching remise settings: $e');
    }
  }

  Future<void> _updateSettings() async {
    try {
      await FirebaseFirestore.instance
          .collection('remiseSettings')
          .doc('settings')
          .set({
        'poutrelleRemise': _poutrelleRemiseController.text,
        'agglosRemise': _agglosRemiseController.text,
        'hourdisRemise': _hourdisRemiseController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Settings updated successfully.'),
        ),
      );
    } catch (e) {
      print('Error updating remise settings: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Remise Settings'),
          backgroundColor: Colors.black,
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  MyHeaderDrawer(),
                  DrawerList(),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: Color(0xAAB8D6C7),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _poutrelleRemiseController,
                  decoration: InputDecoration(labelText: 'Poutrelle Remise'),
                ),
                TextField(
                  controller: _agglosRemiseController,
                  decoration: InputDecoration(labelText: 'Agglos Remise'),
                ),
                TextField(
                  controller: _hourdisRemiseController,
                  decoration: InputDecoration(labelText: 'Hourdis Remise'),
                ),
                SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateSettings,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.black, // Set the text color to white
                ),
                child: Text('Save'),
              ),

                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/secondScreen');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Précedent', style: TextStyle(fontSize: 19)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/thirdScreen');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.black,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Suivant', style: TextStyle(fontSize: 19)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
