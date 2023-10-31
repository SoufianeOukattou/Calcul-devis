import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';


class Poutrelle {
  String type;
  double longueur;
  int nbEtrier;
  int nombre;
  double prix;
  static int nbEtrierTotal = 0;
  static double PrixUnitaireEtrier = 0.0;

  

   Poutrelle(this.type, this.longueur, this.nbEtrier, this.nombre)
      : prix = 0.0 {
    initializePrix().then((price) {
      prix = price;
    });
  }

  // List to store poutrelles
  static List<Poutrelle> poutrelles = [];

  // Method to add a new poutrelle to the list
  static void addPoutrelle(String type, double longueur, int nbEtrier, int nombre) {
    Poutrelle newPoutrelle = Poutrelle(type, longueur, nbEtrier, nombre);
    poutrelles.add(newPoutrelle);
  }

  static void addPoutrelleObject(Poutrelle newPoutrelle) {
    poutrelles.add(newPoutrelle);
  }

  static Future<void> savePoutrellesToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> poutrellesData = poutrelles.map((poutrelle) {
      return {
        'type': poutrelle.type,
        'longueur': poutrelle.longueur,
        'nbEtrier': poutrelle.nbEtrier,
        'nombre': poutrelle.nombre,
        'prix': poutrelle.prix,
      };
    }).toList();
    await prefs.setString('poutrellesList', jsonEncode(poutrellesData));
  }


   Future<double> initializePrix() async {
      return await getPriceFromFirestore(type);
    }
   static Future<double> getPriceFromFirestore(String type) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('PoutrelleOption') // Replace with your collection name
          .where('type', isEqualTo: type)
          .get();
     
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double priceString = data['price'];
        return priceString;
      } else {
        return 0.0; // Default value if document doesn't exist
      }
    } catch (e) {
      return 0.0;
    }
  }
   double calculateCost() {
    return longueur * prix;
  }
  


  static Future<double> getRemiseValueFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('remiseSettings') // Replace with your collection name
          .doc('settings')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double remiseValue = double.parse( data['poutrelleRemise']) ?? 0.0;
        //print remise 
        return remiseValue;
      } else {
        return 0.0; // Default value if document doesn't exist
      }
    } catch (e) {
      return 0.0; // Default value in case of an error
    }
  }


  // Method to retrieve poutrelles list from SharedPreferences
  static Future<void> retrievePoutrellesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? poutrellesString = prefs.getString('poutrellesList');
    if (poutrellesString != null) {
      List<dynamic> poutrellesData = jsonDecode(poutrellesString);
      poutrelles = poutrellesData.map((data) {
        
        return Poutrelle(
          data['type'],
          data['longueur'],
          data['nbEtrier'],
          data['nombre']
          
        );
      }).toList();
    }
  }

  static Future<double> getEtrierUnitPriceFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('otherSettings')  // Change to your collection name
          .doc('settings')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String etrierUnitPrice = data['prixEtrier'];
        
        return double.parse(etrierUnitPrice);
      } else {
        return 0.0;  // Default value if document doesn't exist
      }
    } catch (e) {
      return 0.0;
    }
  }

  static Future<double> calculateTotalEtrierCost() async {
    double etrierUnitPrice = await getEtrierUnitPriceFromFirestore();
    double totalCost = 0.0;
    nbEtrierTotal = 0;
    PrixUnitaireEtrier = etrierUnitPrice;
    for (var poutrelle in poutrelles) {
      totalCost += poutrelle.nbEtrier * etrierUnitPrice;
      nbEtrierTotal += poutrelle.nbEtrier *2;
    }
      totalCost = totalCost * 2;
    return totalCost;
  }
  static Future<double> calculateTotalTransportCost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double costPerMeter = prefs.getDouble('transportPoutrelle') ?? 0.0;
    double totalCost = 0.0;

    for (var poutrelle in poutrelles) {
      
      totalCost += poutrelle.longueur * costPerMeter * poutrelle.nombre;
    }

      return totalCost;
  }

}
