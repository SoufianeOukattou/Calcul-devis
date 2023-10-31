import 'package:flutter/material.dart';
import 'package:calculdevis/Agglos.dart'; // Import your Agglos class
import 'package:calculdevis/my_drawer_header.dart';
import 'package:calculdevis/DrawerList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController _quantityController = TextEditingController();

String? _selectedType;

class AggloTablePage extends StatefulWidget {
  @override
  _AggloTablePageState createState() => _AggloTablePageState();
}

class _AggloTablePageState extends State<AggloTablePage> {
  Set<Agglos> _selectedRows = Set<Agglos>();

  void _showAddAggloDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Agglo'),
          content: _AddAggloForm(),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String type = _selectedType ?? 'Type A';
                    int quantity = int.parse(_quantityController.text);

                    Agglos newAgglo = Agglos(type, quantity);
                    Agglos.addAggloObject(newAgglo);
                    Agglos.saveAgglosToSharedPreferences();
                  },
                  child: Text('Add'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .popUntil((route) => route.settings.name == '/fourthScreen');
                    Navigator.pushNamed(context, '/seventhScreen');
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Agglo Table',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xAAB8D6C7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 580,
              child: Expanded(
                flex: 48,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      showBottomBorder: true,
                      headingRowColor:
                          MaterialStateProperty.resolveWith((states) => Colors.green),
                      columns: [
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Prix unitaire')),
                        DataColumn(label: Text('Prix total')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: Agglos.agglos.map((agglo) {
                        int index = Agglos.agglos.indexOf(agglo);
                        return DataRow(
                          selected: _selectedRows.contains(agglo),
                          color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                            } else if (index.isEven) {
                              return Colors.grey.withOpacity(0.3);
                            }
                            return null;
                          }),
                          cells: [
                            DataCell(Text(agglo.type)),
                            DataCell(Text(agglo.quantity.toString())),
                            DataCell(Text(agglo.price.toString())),
                            DataCell(Text(agglo.calculateCost().toString())),
                            DataCell(IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  Agglos.agglos.removeAt(index);
                                  Agglos.saveAgglosToSharedPreferences();
                                });
                              },
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/fourthScreen');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Précedent', style: TextStyle(fontSize: 19)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/TransportPage');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Suivant', style: TextStyle(fontSize: 19)),
                ),
              ],
            ),
          ],
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAggloDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

class _AddAggloForm extends StatefulWidget {
  @override
  __AddAggloFormState createState() => __AddAggloFormState();
}

class __AddAggloFormState extends State<_AddAggloForm> {
  final List<String> aggloTypes = []; // Replace with your types

  @override
  void initState() {
    super.initState();
    fetchAggloTypes();
  }

  Future<List<String>> getAggloTypesFromFirestore() async {
    List<String> aggloTypes = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AgglosOption').get();
      aggloTypes = querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>?)?['type'] as String? ?? '')
          .toList();
    } catch (e) {
      print('Error fetching agglo types from Firestore: $e');
    }

    return aggloTypes;
  }

  Future<void> fetchAggloTypes() async {
    aggloTypes.clear();
    List<String> fetchedTypes = await getAggloTypesFromFirestore();
    setState(() {
      aggloTypes.addAll(fetchedTypes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedType,
            items: aggloTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value;
              });
            },
            decoration: InputDecoration(labelText: 'Type'),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _quantityController,
            decoration: InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          // Add more TextFormField widgets for additional fields
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
