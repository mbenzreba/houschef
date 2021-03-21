import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

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