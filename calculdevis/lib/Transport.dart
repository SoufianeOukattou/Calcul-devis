import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransportSettingsPage extends StatefulWidget {
  @override
  _TransportSettingsPageState createState() => _TransportSettingsPageState();
}

class _TransportSettingsPageState extends State<TransportSettingsPage> {
  final TextEditingController _transport1Controller = TextEditingController();
  final TextEditingController _transport2Controller = TextEditingController();
  final TextEditingController _transport3Controller = TextEditingController();

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _transport1Controller.text = prefs.getDouble('transportPoutrelle')?.toString() ?? '';
      _transport2Controller.text = prefs.getDouble('transportHourdis')?.toString() ?? '';
      _transport3Controller.text = prefs.getDouble('transportAgglos')?.toString() ?? '';
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('transportPoutrelle', double.tryParse(_transport1Controller.text) ?? 0.0);
    prefs.setDouble('transportHourdis', double.tryParse(_transport2Controller.text) ?? 0.0);
    prefs.setDouble('transportAgglos', double.tryParse(_transport3Controller.text) ?? 0.0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transport prices updated successfully.'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Transport Settings'),
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Color(0xAAB8D6C7),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //titre add margin

                Container(
                  margin: EdgeInsets.only(bottom: 80.0,top: 50), // Add margin to the bottom
                  child: Text(
                    'Transport Settings',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
               
                TextField(
                  controller: _transport1Controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Poutrelle  Transport Price'),
                ),
                TextField(
                  controller: _transport2Controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Hourdis  Transport Price'),
                ),
                TextField(
                  controller: _transport3Controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Agglos  Transport Price'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveSettings,
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
                            Navigator.pushNamed(context, '/seventhScreen');
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
                            Navigator.pushNamed(context, '/fifthScreen');
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
