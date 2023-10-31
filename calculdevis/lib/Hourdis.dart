import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';



class Hourdis {
  String type;
  int number;
  double price;

  Hourdis(this.type, this.number): price = 0.0 {
     initializePrice().then((prix) {
      price = prix;
    });
  }

  static List<Hourdis> hourdisList = [];

  static void addHourdis(String type, int number, double price) {
    Hourdis newHourdis = Hourdis(type, number);
    hourdisList.add(newHourdis);
  }

  static void addHourdisObject(Hourdis newHourdis) {
    hourdisList.add(newHourdis);
  }


   Future<double> initializePrice() async {
    return await getPriceFromFirestore(type);
  }

  static Future<double> getPriceFromFirestore(String type) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('HourdisOption') // Replace with your collection name
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
    return number * price;
  }


      static Future<double> getRemiseValueFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('remiseSettings') // Replace with your collection name
          .doc('settings')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double remiseValue = double.parse( data['hourdisRemise']) ?? 0.0;
        //print remise 
        return remiseValue;
      } else {
        return 0.0; // Default value if document doesn't exist
      }
    } catch (e) {
      return 0.0; // Default value in case of an error
    }
  }


  static Future<void> saveHourdisToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> hourdisData = hourdisList.map((hourdis) {
      return {
        'type': hourdis.type,
        'number': hourdis.number,
        'price': hourdis.price,
      };
    }).toList();
    await prefs.setString('hourdisList', jsonEncode(hourdisData));
  }




  static Future<void> retrieveHourdisFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hourdisString = prefs.getString('hourdisList');
    if (hourdisString != null) {
      List<dynamic> hourdisData = jsonDecode(hourdisString);
      hourdisList = hourdisData.map((data) {
        return Hourdis(
          data['type'],
          data['number'],
         
        );
      }).toList();
    }
  }
   static Future<double> calculateTotalTransportCost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double costPerMeter = prefs.getDouble('transportHourdis') ?? 0.0;
    double totalCost = 0.0;

    for (var hourdis in hourdisList) {
      
      totalCost += costPerMeter * hourdis.number;
    }

      return totalCost;
  }
}
