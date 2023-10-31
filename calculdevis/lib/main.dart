import 'package:flutter/material.dart';
import 'package:calculdevis/poutrelleTable.dart';
import 'package:calculdevis/hourdisTable.dart';
import 'package:calculdevis/TitreDevis.dart';
import 'package:calculdevis/TotalPage.dart';
import 'package:calculdevis/poutrelleOptionTable.dart';
import 'package:calculdevis/agglosOptionsTable.dart';
import 'package:calculdevis/hourdisOptionTable.dart';
import 'package:calculdevis/otherOptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:calculdevis/Fifthpage.dart';
import 'package:calculdevis/Remise.dart';
import 'firebase_options.dart';
import 'package:calculdevis/agglosTable.dart';
import 'package:calculdevis/Transport.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    initialRoute: '/firstScreen',
    routes: {
      '/firstScreen': (context) => const HomePage(),
      '/secondScreen': (context) => TitreDevis(),
      '/thirdScreen': (context) => poutrelleTablePage(),
      '/fourthScreen': (context) => HourdisTablePage(),
      '/fifthScreen': (context) => FifthPage(),
      '/sixthScreen': (context) => SixthPage(),
      '/poutrelleOption': (context) => PoutrelleOption(),
      '/hourdisOption' : (context) => HourdisOption(),
      '/othersOption' : (context) => OtherSettingsPage(),
      '/seventhScreen': (context) => AggloTablePage(),
      '/agglosOption' : (context) => AgglosOption(),
      '/remiseScreen' : (context) => RemiseSettingsPage(),
      "/TransportPage": (context) => TransportSettingsPage(),
    },
  ));
}




class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        
        body: Container(
          color: const Color(0xAAB8D6C7),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child:Column(
          
         children: [
            Expanded(
              flex: 8,
              child: Image.asset(
                'assets/images/homePage.png', // Replace with your image path
                fit: BoxFit.fitWidth, // To fix image in box
              ),
            ),
            Expanded(
                flex: 4,
                child: Column(
                  
                  children: [
                    const Text(
                      "Welcome to the Devis Generator!",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                      
                    ),
                    const Text(
                      "Créer un devis au format PDF",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                      
                    ),
                    const SizedBox(height: 70),
                    Center(
                      child: SizedBox(
                        
                        height: 60,
                        width: 270,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/secondScreen');
                            },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side: const BorderSide(width: 4, color: Color(0x11B8D6C7)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Text(
                                  "Generate Devis",
                                  style: TextStyle(fontSize: 25, color: Colors.white),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
             
          ],
      ),),
        
      ),
    );  
  }

 
}
