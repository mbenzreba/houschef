///   Filename        :   recipe_step.dart
///   Date            :   4/11/2021
///   Description     :   This file contains the widgets used for displaying the contents of the favorites page.
///                       From here a user can select from a list of recipes saved to immediately begin cooking



import 'dart:io';
import 'dart:async';

import 'package:chef/models/recipes.dart';
import 'package:chef/views/recipe_detail_screen.dart';
import 'package:flutter/material.dart';


// Import for MethodChannel
import 'package:flutter/services.dart';




/// Class                 : RecipeStep
/// Description           : This class instantiates the recipe step class used for dispalying the contents of a recipe step that 
///                         will go hand in hand with text to speech technology
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

  // initState() used to intialze the data necessary to run the recipe_step page
  @override
  void initState() {
    _startCooking(this.recipe["url"]);
    _tellAssistant();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => _getLatestStep());
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }


  // METHOD         :   _startCooking
  // PARMETERS      :   void
  // RETURNS        :   Future
  // DESCRIPTION    :   This method is called upon when the user wishes to enable the application to begin interacting with the user. From here a recipe steps are parsed
  //                    one step at a time and notifies the user that the application has begin intialized the text to speech functionality of the app.
  Future<void> _startCooking(String recipeUrl) async {
    Map<dynamic, dynamic> content = new Map<dynamic, dynamic>();
    try {
      content = await platform.invokeMethod('startCooking', recipeUrl);
    } on PlatformException catch (e) {
      content["step"] = "Failed to start cooking";
    }

    // setState() a method called upon whenever the data of the page changes
    setState(() {
      _currentStep = content["step"];
    });
  }



  // METHOD         :   _tellAssistant
  // PARMETERS      :   void
  // RETURNS        :   Future
  // DESCRIPTION    :   This method is called upon when the user wishes to communicate directly with the text to speech functionality.
  //                    From here we invoke a method channel that will be used to communicate with the underlying JAVA code
  //                    used to operate the text to speech operation for understanding user input.
  Future<void> _tellAssistant() async {
    Map<dynamic, dynamic> content;
    try {
      content = await platform.invokeMethod('tellAssistant');
    } on PlatformException catch (e) {
      content["step"] = "Failed to tell assistant";
    }

    // setState() a method called upon whenever the data of the page changes
    setState(() {
      _currentStep = content["step"];
    });
  }


  // METHOD         :   _getLatestStep
  // PARMETERS      :   void
  // RETURNS        :   Future
  // DESCRIPTION    :   This method is called upon when the user wishes to have the text to speech functionality enabled.
  //                    From here we invoke a method channel that will be used to communicate with the underlying JAVA code
  //                    used to operate the text to speech operation.
  Future<void> _getLatestStep() async {
    Map<dynamic, dynamic> content;
    try {
      content = await platform.invokeMethod('getLatestStep');
    } on PlatformException catch (e) {
      content["step"] = "Failed to tell assistant";
    }
    
    // setState() a method called upon whenever the data of the page changes
    setState(() {
      _currentStep = content["step"];
    });
    
  }

  Future<void> _cancelCooking() async {
    try {
      await platform.invokeMethod('cancelCooking');
    } on PlatformException catch (e) {
      
    }

    // setState() a method called upon whenever the data of the page changes
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
