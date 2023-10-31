import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Agglos {
  String type;
  int quantity;
  double price;

  Agglos(this.type,  this.quantity) : price = 0.0 {
    initializePrice().then((price) {
      this.price = price;
    });
  }

  // List to store Agglos
  static List<Agglos> agglos = [];

  // Method to add a new Agglo to the list
  static void addAgglo(String type,  int quantity) {
    Agglos newAgglo = Agglos(type,  quantity);
    agglos.add(newAgglo);
  }

  static void addAggloObject(Agglos newAgglo) {
    agglos.add(newAgglo);
  }

  static Future<void> saveAgglosToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> agglosData = agglos.map((agglo) {
      return {
        'type': agglo.type,
        'quantity': agglo.quantity,
        'price': agglo.price,
      };
    }).toList();
    await prefs.setString('agglosList', jsonEncode(agglosData));
  }

  Future<double> initializePrice() async {
    return await getPriceFromFirestore(type);
  }

   static Future<double> getPriceFromFirestore(String type) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('AgglosOption') // Replace with your collection name
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
    return  price * quantity;
  }

 
  // Method to retrieve Agglos list from SharedPreferences
  static Future<void> retrieveAgglosFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agglosString = prefs.getString('agglosList');
    if (agglosString != null) {
      List<dynamic> agglosData = jsonDecode(agglosString);
      agglos = agglosData.map((data) {
        return Agglos(
          data['type'],
          data['quantity'],
        );
      }).toList();
    }
  }


   static Future<double> getRemiseValueFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('remiseSettings') // Replace with your collection name
          .doc('settings')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double remiseValue = double.parse( data['agglosRemise']) ?? 0.0;
        //print remise 
        return remiseValue;
      } else {
        return 0.0; // Default value if document doesn't exist
      }
    } catch (e) {
      return 0.0; // Default value in case of an error
    }
  }


  static Future<double> calculateTotalTransportCost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double costPerMeter = prefs.getDouble('transportHourdis') ?? 0.0;
    double totalCost = 0.0;

    for (var agglo in agglos) {
      
      totalCost += costPerMeter * agglo.quantity;
    }

      return totalCost;
  }

  // Additional methods for fetching unit prices and calculating total costs if needed
}
