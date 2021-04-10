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