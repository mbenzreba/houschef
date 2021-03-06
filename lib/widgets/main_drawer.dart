///   Filename        :   main_drawer.dart
///   Date            :   4/11/2021
///   Description     :   This file contains the widgets used for displaying the contents of the Drawer page.
///                       
///


import 'package:flutter/material.dart';

import '../views/about_screen.dart';

class MainDrawer extends StatelessWidget {


  
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
            leading: Icon(
              icon, 
              size: 26,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: tapHandler,
          );
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Colors.black12,
            child: Text('Housechef',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.black
                ),
              ),
          ),

          SizedBox(height: 20,),

          buildListTile(
            'Recipes', 
            Icons.restaurant, 
            () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),

          

          buildListTile(
            'About', 
            Icons.info, 
            () {
              Navigator.of(context).pushReplacementNamed(AboutScreen.routeName);
            },
          ),

        

        ],
      ),
    );
  }
}