import 'dart:io';

import 'package:chef/models/recipes.dart';
import 'package:flutter/material.dart';










class RecipeStep extends StatefulWidget {
  static const routeName = '/recipe-step';
  final String recipeStep;

  RecipeStep(this.recipeStep);

  @override
  _RecipeStepState createState() => _RecipeStepState();
}






class _RecipeStepState extends State<RecipeStep> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Houschef', style: Theme.of(context).textTheme.title,),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,

      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
            child: Text(
            'Recipe step goes here', 
              style: Theme.of(context).textTheme.title,
            ),),

            RaisedButton(
              child: Text('Previous Step'), 
              onPressed: null),

            RaisedButton(
            child: Text('Next Step'),
            onPressed: null,),

            RaisedButton(
              child: Text('Cancel'),
              onPressed: null),  
      ],
    )
    ); 
    
  }

  
}
