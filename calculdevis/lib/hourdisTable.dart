import 'package:flutter/material.dart';
import 'package:calculdevis/Hourdis.dart';
import 'package:calculdevis/my_drawer_header.dart';
import 'package:calculdevis/DrawerList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
TextEditingController _numberController = TextEditingController();
String? _selectedType;


class HourdisTablePage extends StatefulWidget {
  @override
  _HourdisTablePageState createState() => _HourdisTablePageState();
}

class _HourdisTablePageState extends State<HourdisTablePage> {
  Set<Hourdis> _selectedRows = Set<Hourdis>();





  void _showAddHourdisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Hourdis'),
          content: _AddHourdisForm(),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String type = _selectedType ?? '157';
                    int number = int.parse(_numberController.text);

                    Hourdis newHourdis = Hourdis(type, number);
                    Hourdis.addHourdisObject(newHourdis);
                    Hourdis.saveHourdisToSharedPreferences();
                  },
                  child: Text('Add'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.settings.name == '/thirdScreen');
                    Navigator.pushNamed(context, '/fourthScreen');
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Hourdis Table',
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
                      headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.green),
                      columns: [
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Number')),
                        DataColumn(label: Text('Prix Unitaire')),
                        DataColumn(label: Text('Prix Total')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: Hourdis.hourdisList.map((hourdis) {
                        int index = Hourdis.hourdisList.indexOf(hourdis);
                        return DataRow(
                          selected: _selectedRows.contains(hourdis),
                          color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                            } else if (index.isEven) {
                              return Colors.grey.withOpacity(0.3);
                            }
                            return null;
                          }),
                          cells: [
                            DataCell(Text(hourdis.type)),
                            DataCell(Text(hourdis.number.toString())),
                            DataCell(Text(hourdis.price.toString())),
                            DataCell(Text(hourdis.calculateCost().toString())),
                            DataCell(IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  Hourdis.hourdisList.removeAt(index);
                                  
                                  Hourdis.saveHourdisToSharedPreferences();
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
                    onPressed: ()  {
                     Navigator.pushNamed(context, '/thirdScreen');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Précedent', style: TextStyle(fontSize: 19)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/seventhScreen');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 18),
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
        onPressed: () => _showAddHourdisDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

class _AddHourdisForm extends StatefulWidget {
  @override
  __AddHourdisFormState createState() => __AddHourdisFormState();
}

class __AddHourdisFormState extends State<_AddHourdisForm> {
  final List<String> hourdisTypes = []; // Replace with your types



   @override
  void initState() {
    super.initState(); // Call the superclass's initState first
    fetchHourdisTypes(); // Fetch poutrelle types when the widget initializes
  }


  Future<List<String>> getHourdisTypesFromFirestore() async {
  List<String> hourdisTypes = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('HourdisOption').get();
    hourdisTypes = querySnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>?)?['type'] as String? ?? '')
        .toList();
  } catch (e) {
    print('Error fetching hourdis types from Firestore: $e');
  }

  return hourdisTypes;
}

Future<void> fetchHourdisTypes() async {
  hourdisTypes.clear(); // Clear the list before fetching to avoid duplicates
  List<String> fetchedTypes = await getHourdisTypesFromFirestore();
  setState(() {
    hourdisTypes.addAll(fetchedTypes); // Add fetched types to the list
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
            items: hourdisTypes.map((type) {
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
            controller: _numberController,
            decoration: InputDecoration(labelText: 'Number'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
         
        ],
      ),
    );
  }
}
