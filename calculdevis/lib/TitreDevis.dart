import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calculdevis/Poutrelle.dart';
import 'package:calculdevis/Hourdis.dart';
import 'package:calculdevis/Agglos.dart';
import 'package:calculdevis/my_drawer_header.dart';
import 'package:calculdevis/DrawerList.dart';

class TitreDevis extends StatefulWidget {
  const TitreDevis({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TitreDevisState createState() => _TitreDevisState();
}

class _TitreDevisState extends State<TitreDevis> {
  TextEditingController _steController = TextEditingController();
  TextEditingController _planController = TextEditingController();
  TextEditingController _entrepriseController = TextEditingController();
  TextEditingController _chantierController = TextEditingController();
  TextEditingController _batimentController = TextEditingController();

  SharedPreferences? prefs;

    
  Future<void> _fetchPoutrelles() async {
    await Poutrelle.retrievePoutrellesFromSharedPreferences();
    
    setState(() {}); // Update the state to refresh the DataTable
  }
  Future<void> _fetchHourdis() async {
    await Hourdis.retrieveHourdisFromSharedPreferences();
    
    setState(() {});
  }
  //fetch agglos future function

  Future<void> _fetchAgglos() async {
    await Agglos.retrieveAgglosFromSharedPreferences();
    setState(() {});
  }

  
  @override
  void initState() {
    
 _fetchPoutrelles();
 _fetchHourdis();
 _fetchAgglos();
  
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Devis Generator',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xAAB8D6C7),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
             SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  child: Center(
                    child: Text(
                      "Titre de Devis!",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                ),
              ),

              _buildTextField(_steController, 'STE DE BATIMENT & BETON MOULE'),
              _buildTextField(_planController, 'PLAN'),
              _buildTextField(_entrepriseController, 'ENTREPRISE'),
              _buildTextField(_chantierController, 'CHANTIER'),
              _buildTextField(_batimentController, 'BATIMENT'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String ste = _steController.text;
                    String plan = _planController.text;
                    String entreprise = _entrepriseController.text;
                    String chantier = _chantierController.text;
                    String batiment = _batimentController.text;

                    String formattedTitle =
                        'D E V I S  $ste  $plan  $entreprise  $chantier  $batiment';

                    prefs = await SharedPreferences.getInstance();
                    if (prefs == null) return;

                    await prefs!.setString('titreDevis', formattedTitle);

                    Navigator.pushNamed(context, '/remiseScreen');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Suivant', style: TextStyle(fontSize: 19)),
                ),
              ),
              
            ],
            
          ),
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
    );
  }


  Widget _buildTextField(TextEditingController controller, String hintText) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.5), 
          
          fontSize: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

}


