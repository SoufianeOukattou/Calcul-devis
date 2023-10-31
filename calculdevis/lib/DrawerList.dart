import 'package:flutter/material.dart';

class DrawerList extends StatefulWidget {
  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            ListTile(
              leading: Icon(Icons.home), // Icon for Accueil
              title: Text('Accueil'),
              onTap: () {
                Navigator.pushNamed(context, '/firstScreen');
              },
            ),
                      
            ListTile(
              leading: Icon(Icons.settings), // Icon for Poutrelle
              title: Text('Poutrelle Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/poutrelleOption');
              },
            ),
             ListTile(
                leading: Icon(Icons.settings), // Icon for Hourdis
                title: Text('Hourdis Settings'),
                onTap: () {
                  Navigator.pushNamed(context, '/hourdisOption');
                },
              ),
              ListTile(
              leading: Icon(Icons.settings), // Icon for Poutrelle
              title: Text('Agglos Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/agglosOption');
              },
            ),
              ListTile(
                leading: Icon(Icons.settings), // Use the more_horiz icon as the leading icon
                title: Text('Other Settings'), // Replace with your desired title
                onTap: () {
                  // Navigate to the other settings page
                  Navigator.pushNamed(context, '/othersOption'); // Replace with your navigation route
                },
              ),
              ListTile(
                leading: Icon(Icons.settings), // Use the more_horiz icon as the leading icon
                title: Text('Remise'), // Replace with your desired title
                onTap: () {
                  // Navigate to the other settings page
                  Navigator.pushNamed(context, '/remiseScreen'); // Replace with your navigation route
                },
              ),
              
        ],
      ),
    );
  }
}