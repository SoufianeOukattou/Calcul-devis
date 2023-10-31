import 'package:flutter/material.dart';
import 'package:calculdevis/Poutrelle.dart';
import 'package:calculdevis/my_drawer_header.dart';
import 'package:calculdevis/DrawerList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


TextEditingController _longueurController = TextEditingController();
TextEditingController _nbEtrierController = TextEditingController();
TextEditingController _nombreController = TextEditingController();

String? _selectedType;


class poutrelleTablePage extends StatefulWidget {
  @override
  _poutrelleTablePageState createState() => _poutrelleTablePageState();
}

class _poutrelleTablePageState extends State<poutrelleTablePage> {
  Set<Poutrelle> _selectedRows = Set<Poutrelle>();

  void _showAddpoutrelleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add poutrelle'),
          content: _AddpoutrelleForm(),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String type = _selectedType ?? '157';
                    double longueur = double.parse(_longueurController.text);
                    int nbEtrier = int.parse(_nbEtrierController.text);
                    int nombre = int.parse(_nombreController.text);
                   

                    Poutrelle newPoutrelle = Poutrelle(type, longueur, nbEtrier,nombre);
                    Poutrelle.addPoutrelleObject(newPoutrelle);
                    Poutrelle.savePoutrellesToSharedPreferences();
                  },
                  child: Text('Add'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.settings.name == '/secondScreen');
                    Navigator.pushNamed(context, '/thirdScreen');
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
          'Poutrelle Table', // Set a static title for the AppBar
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
              height:580,
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
                     
                      DataColumn(label: Text('type')),
                      DataColumn(label: Text('Longueur')),
                      DataColumn(label: Text('Etrier')),
                      DataColumn(label: Text('nombre')),
                      DataColumn(label: Text('Prix Unitaire')),
                      DataColumn(label: Text('Prix Total')),
                      DataColumn(label: Text('Actions')),
                    ],
                    
                    rows: Poutrelle.poutrelles.map((pout) {
                      int index = Poutrelle.poutrelles.indexOf(pout);
                      return DataRow(
                        selected: _selectedRows.contains(pout),
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
                          DataCell(Text(pout.type)),
                          DataCell(Text(pout.longueur.toString())),
                          DataCell(Text(pout.nbEtrier.toString())),
                          DataCell(Text(pout.nombre.toString())),
                          DataCell(Text(pout.prix.toString())),
                          DataCell(Text(pout.calculateCost().toString())),
                          //datacell with delete icon
                          DataCell(IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                Poutrelle.poutrelles.removeAt(index);
                                 
                                Poutrelle.savePoutrellesToSharedPreferences();
                               
                              });
                            },
                          )),
                          // Add more DataCell widgets for additional columns
                        ],
                        // onSelectChanged: (bool? selected) {
                        //   setState(() {
                        //     if (selected ?? false) {
                        //       _selectedRows.add(pout);
                        //     } else {
                        //       _selectedRows.remove(pout);
                        //     }
                        //   });
                        // },
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
                      Navigator.pushNamed(context, '/remiseScreen');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Précedent', style: TextStyle(fontSize: 19)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/fourthScreen');
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
        onPressed: () => _showAddpoutrelleDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
class _AddpoutrelleForm extends StatefulWidget {
  @override
  __AddpoutrelleFormState createState() => __AddpoutrelleFormState();
}

class __AddpoutrelleFormState extends State<_AddpoutrelleForm> {
  final List<String> poutrelleTypes = []; // Replace with your types

  @override
  void initState() {
    super.initState(); // Call the superclass's initState first
    fetchPoutrelleTypes(); // Fetch poutrelle types when the widget initializes
  }

  Future<List<String>> getPoutrelleTypesFromFirestore() async {
    List<String> poutrelleTypes = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('PoutrelleOption').get();
      poutrelleTypes = querySnapshot.docs
    .map((doc) => (doc.data() as Map<String, dynamic>?)?['type'] as String? ?? '')
    .toList();

    } catch (e) {
      print('Error fetching poutrelle types from Firestore: $e');
    }

    return poutrelleTypes;
  }

  Future<void> fetchPoutrelleTypes() async {
    poutrelleTypes.clear(); // Clear the list before fetching to avoid duplicates
    List<String> fetchedTypes = await getPoutrelleTypesFromFirestore();
    setState(() {
      poutrelleTypes.addAll(fetchedTypes); // Add fetched types to the list
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
            items: poutrelleTypes.map((type) {
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
            controller: _longueurController,
            decoration: InputDecoration(labelText: 'Longueur'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _nbEtrierController,
            decoration: InputDecoration(labelText: 'Etrier'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _nombreController,
            decoration: InputDecoration(labelText: 'Nombre'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
         
          // Add a SizedBox at the bottom to create space between the last field and the buttons
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
