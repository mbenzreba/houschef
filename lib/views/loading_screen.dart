import 'dart:async';

import 'package:chef/views/recipe_step.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
//import 'package:world_time_app/services/world_time.dart';


import 'package:flutter_spinkit/flutter_spinkit.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';

import '../dal/RecipeDAL.dart';

class Loading extends StatefulWidget {
  final Map<dynamic,dynamic> recipe;
  Loading(this.recipe);
  @override
  _LoadingState createState() => _LoadingState(recipe);
}

class _LoadingState extends State<Loading> {


  
  final Map<dynamic, dynamic>  recipe;
  _LoadingState(this.recipe);

  static const platform = const MethodChannel("com.example.chef/load");
  bool areModelsLoaded = false;
  Timer timer;

  void _areModelsLoaded() async {
    bool result;
    try {
      result = await platform.invokeMethod("areModelsLoaded") as bool;
    } 
    on PlatformException catch (e) {
      result = false;
    }

    setState(() {
      areModelsLoaded = result;
      if (areModelsLoaded) {
        timer.cancel();
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => RecipeStep(recipe)));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    
    timer = Timer.periodic(Duration(seconds: 4), (Timer t) => _areModelsLoaded());
  }

  @override
  void dispose() {
    super.dispose;
    timer.cancel();
  }





  @override
  Widget build(BuildContext context) {
    return  Scaffold (
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(title: Text("Houschef", style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,
     
      ),
      body: Center(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SpinKitRotatingCircle(
            color: Colors.white,
            size: 100.0,
            ),
          Text(
            "Getting everything ready...",
          )
        ]
    ),
    ),

    );
    
  }
}