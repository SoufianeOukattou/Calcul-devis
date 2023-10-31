import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
       color: Color(0xFF031801),
      width: double.infinity,
      height: 300,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 100,
            width: 100, // Set equal width and height to maintain a fixed circle shape
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                image: AssetImage('assets/images/logo.jpeg'),
                fit: BoxFit.cover,
                ),
            ),
            ),


          Text(
            "SBBM",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            "société de bâtiment et de béton moulé",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}