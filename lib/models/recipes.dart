///     Filename        :     main.dart
///     Date            :     4/11/2021
///     Desciption      :     This file contains the Recipe class specification. Here a recipe object is describe with its given attributes and constructor
///

import 'package:flutter/foundation.dart';


class Recipe {

  final String id;
  final String title;
  final String imageURL;
  final List<String> ingredients;
  final List<String> steps;




 const Recipe({
    @required this.id, 
    @required this.title, 
    @required this.imageURL, 
    @required this.ingredients, 
    @required this.steps
  });
  
}