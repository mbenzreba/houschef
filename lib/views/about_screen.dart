///   Filename        :   about_screen.dart
///   Date            :   4/11/2021
///   Description     :   This file contains the widgets used for displaying the about screen
///     

import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';


// CLASS            :   AboutScreen
// DESCRIPTION      :   This class instantiates the content for the about screen
class AboutScreen extends StatelessWidget {

  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('CRUUTON'),
      ),
      drawer: MainDrawer(),
      body: Center(
      child:Text('Elder, Jimmy, Ethan & Mo'),
     ), 
    );
  }
}