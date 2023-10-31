import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgglosOption extends StatefulWidget {
  @override
  _AgglosOptionState createState() => _AgglosOptionState();
}

class _AgglosOptionState extends State<AgglosOption> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Agglos Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final type = _typeController.text;
                final price = double.parse(_priceController.text);

                if (type.isNotEmpty && price > 0) {
                  // Check if the type already exists
                  final existingSettings = await FirebaseFirestore.instance
                      .collection('AgglosOption')
                      .where('type', isEqualTo: type)
                      .get();

                  if (existingSettings.docs.isNotEmpty) {
                    // Type already exists, show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Type "$type" already exists.'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Type does not exist, add the setting
                    await FirebaseFirestore.instance.collection('AgglosOption').add({
                      'type': type,
                      'price': price,
                    });

                    Navigator.of(context).pop();
                    _typeController.clear();
                    _priceController.clear();
                  }
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSetting(String documentId) async {
    await FirebaseFirestore.instance.collection('AgglosOption').doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agglos Settings Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('AgglosOption').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final settings = snapshot.data!.docs;

          return DataTable(
            columns: [
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Action')),
            ],
            rows: settings.map((setting) {
              final data = setting.data() as Map<String, dynamic>;
              final documentId = setting.id;
              return DataRow(cells: [
                DataCell(Text(data['type'])),
                DataCell(Text(data['price'].toString())),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteSetting(documentId);
                    },
                  ),
                ),
              ]);
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
