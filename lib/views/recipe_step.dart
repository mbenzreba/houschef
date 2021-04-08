import 'dart:io';

import 'package:chef/models/recipes.dart';
import 'package:flutter/material.dart';


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

  _RecipeStepState(this.recipe);

  @override
  void initState() {
    _startCooking(this.recipe["url"]);
  }

  Future<void> _startCooking(String recipeUrl) async {
    String content = "Start cooking!";
    try {
      content = await platform.invokeMethod('startCooking', recipeUrl);
    } on PlatformException catch (e) {
      content = "Failed to start cooking";
    }

    setState(() {
      _currentStep = content;
    });
  }


  Future<void> _tellAssistant() async {
    String content;
    try {
      content = await platform.invokeMethod('tellAssistant');
    } on PlatformException catch (e) {
      content = "Failed to tell assistant";
    }

    setState(() {
      _currentStep = content;
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
            child: Text(
              _currentStep, 
              style: Theme.of(context).textTheme.headline6,
            ),),

            ElevatedButton(
              child: Text('Previous Step'), 
              onPressed: null),

            ElevatedButton(
            child: Text('Next Step'),
            onPressed: _tellAssistant,),

            ElevatedButton(
              child: Text('Cancel'),
              onPressed: null),  
      ],
    )
    ); 
    
  }

  
}
