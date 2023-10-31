import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtherSettingsPage extends StatefulWidget {
  @override
  _OtherSettingsPageState createState() => _OtherSettingsPageState();
}

class _OtherSettingsPageState extends State<OtherSettingsPage> {
  final TextEditingController _ControleTechniqueController = TextEditingController();
  final TextEditingController _TreillesSoudeesController = TextEditingController();
  final TextEditingController _tvaController = TextEditingController();
  final TextEditingController _prixEtrierController = TextEditingController();

  Future<void> _fetchSettings() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('otherSettings')
          .doc('settings')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        _ControleTechniqueController.text = data['ControleTechnique'];
        _TreillesSoudeesController.text = data['TreillesSoudees'];
        _tvaController.text = data['tva'];
        _prixEtrierController.text = data['prixEtrier'];
      }
    } catch (e) {
      print('Error fetching other settings: $e');
    }
  }

  Future<void> _updateSettings() async {
    try {
      await FirebaseFirestore.instance
          .collection('otherSettings')
          .doc('settings')
          .set({
        'ControleTechnique': _ControleTechniqueController.text,
        'TreillesSoudees': _TreillesSoudeesController.text,
        'tva': _tvaController.text,
        'prixEtrier': _prixEtrierController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Settings updated successfully.'),
        ),
      );
    } catch (e) {
      print('Error updating settings: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ControleTechniqueController,
              decoration: InputDecoration(labelText: 'Controle Technique'),
            ),
            TextField(
              controller: _TreillesSoudeesController,
              decoration: InputDecoration(labelText: 'Treilles Soudees'),
            ),
            TextField(
              controller: _tvaController,
              decoration: InputDecoration(labelText: 'TVA'),
            ),
            TextField(
              controller: _prixEtrierController,
              decoration: InputDecoration(labelText: 'Prix unitaire Etrier'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateSettings,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
