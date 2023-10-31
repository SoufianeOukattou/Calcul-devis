import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FifthPage extends StatefulWidget {
  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  TextEditingController _controleTechniqueController = TextEditingController();
  TextEditingController _treilleSourdeensController = TextEditingController();

  SharedPreferences? prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Fifth Page',
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
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Center(
                    child: Text(
                      "Enter Values",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                ),
              ),
              _buildTextField(
                  _controleTechniqueController, 'Controle Technique'),
              _buildTextField(
                  _treilleSourdeensController, 'Treille Soudee'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/TransportPage');
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
                    onPressed: () async {
                      double controleTechnique = double.tryParse(
                              _controleTechniqueController.text) ?? 0.0;
                      double treilleSourdeens = double.tryParse(
                              _treilleSourdeensController.text) ?? 0.0;

                      prefs = await SharedPreferences.getInstance();
                      if (prefs == null) return;

                      await prefs!.setDouble('ControleTechnique', controleTechnique);
                      await prefs!.setDouble('TreilleSoudee', treilleSourdeens);

                      Navigator.pushNamed(context, '/sixthScreen');
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
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
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
