import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
//import 'package:world_time_app/services/world_time.dart';


import 'package:flutter_spinkit/flutter_spinkit.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';

import '../dal/RecipeDAL.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  bool programReady = false;
  static const platform = const MethodChannel("com.example.chef/load");

  RecipeDAL dal;
  Timer timer;

  Future<void> _areModelsLoaded() async {
    bool areThreadsLaunched;
    try {
      areThreadsLaunched = await platform.invokeMethod('areModelsLoaded');
    } on PlatformException catch (e) {
      areThreadsLaunched = false;
    }

    setState(() {
      programReady = areThreadsLaunched;
    });
  }

  @override
  void initState() {

    _areModelsLoaded();
    dal = new RecipeDAL(); 
    //dal.CreateDatabase();

   // timer = Timer.periodic(Duration(seconds: 2), (Timer t) => _getLatestStep());
  }



  // Future<void> _checkModels() async {
  //   bool content;
  //   try {
  //     content = await platform.invokeMethod('getLatestStep');
  //   } on PlatformException catch (e) {
  //     content["step"] = "Failed to tell assistant";
  //   }

  //   setState(() {
  //     _currentStep = content["step"];
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return  Scaffold (
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(title: Text("Houschef", style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,
     
      ),
      body: Center(
      child: SpinKitRotatingCircle(
            color: Colors.white,
            size: 100.0,
            ),
    ),);
    
  }
}