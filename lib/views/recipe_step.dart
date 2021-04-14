import 'dart:io';
import 'dart:async';

import 'package:chef/models/recipes.dart';
import 'package:flutter/material.dart';
import 'package:chef/views/recipe_detail_screen.dart';


// Import for MethodChannel
import 'package:flutter/services.dart';







class RecipeStep extends StatefulWidget {
  static const routeName = '/recipe-step';
  //final String recipeStep;

  final Map<dynamic,dynamic> recipe;

  RecipeStep(this.recipe);

  @override
  _RecipeStepState createState() => _RecipeStepState(recipe);
}






class _RecipeStepState extends State<RecipeStep> {

  static const platform = const MethodChannel("com.example.chef/assistant");

  String _currentStep = "";
  final Map<dynamic, dynamic>  recipe;

  Map<String, dynamic> highlightMap;

  Timer timer;

  _RecipeStepState(this.recipe);

  @override
  void initState() {
    if (this.recipe["url"] == "") {
      _startCookingLocal();
    }
    else {
      _startCooking(this.recipe["url"]);
    }
    
    _tellAssistant();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => _getLatestStep());
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future<void> _startCooking(String recipeUrl) async {
    Map<dynamic, dynamic> content = new Map<dynamic, dynamic>();
    try {
      content = await platform.invokeMethod('startCooking', recipeUrl);
    } on PlatformException catch (e) {
      content["step"] = "Failed to start cooking";
    }

    setState(() {
      _currentStep = content["step"];
    });
  }

  Future<void> _startCookingLocal() async {
    Map<dynamic, dynamic> content = new Map<dynamic, dynamic>();
    try {
      content = await platform.invokeMethod('startCookingLocal', this.recipe["steps"][0]);
    } on PlatformException catch (e) {
      content["step"] = "Failed to start cooking";
    }

    setState(() {
      _currentStep = content["step"];
    });
  }


  Future<void> _tellAssistant() async {
    Map<dynamic, dynamic> content;
    try {
      content = await platform.invokeMethod('tellAssistant');
    } on PlatformException catch (e) {
      content["step"] = "Failed to tell assistant";
    }

    setState(() {
      _currentStep = content["step"];
    });
  }


  Future<void> _getLatestStep() async {
    Map<dynamic, dynamic> content;
    try {
      content = await platform.invokeMethod('getLatestStep');
    } on PlatformException catch (e) {
      content["step"] = "Failed to tell assistant";
    }

    setState(() {
      _currentStep = content["step"];
    });
    
    /*
    setState(() {
      _currentStep = content["step"];
      // highlightMap = content;
    }); */
  }

  Future<void> _cancelCooking() async {
    try {
      await platform.invokeMethod('cancelCooking');
    } on PlatformException catch (e) {
      // ...
    }

    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => TestRecipeScreen()));
    });
  }


  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Houschef', style: Theme.of(context).textTheme.headline6,),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,

      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
              _currentStep, 
              style: Theme.of(context).textTheme.headline6,
            ),
            ),
            ),

/*
            ElevatedButton(
              child: Text('Previous Step'), 
              onPressed: null),

            ElevatedButton(
            child: Text('Next Step'),
            onPressed: _tellAssistant,), */

            Center(
              child: ElevatedButton(
              child: Text('Cancel'),
              onPressed: _cancelCooking),
              ),

      ],
    )
    ); 
    
  }

  
}
