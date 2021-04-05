import 'package:flutter/foundation.dart';


// class Recipe {
//     var title: String = null
//     var url: String = null
//     var imgUrl: String = null
//     var html: String = null
//     var steps: MutableList<String> = null
//     var ingredients: MutableList<String> = null
//     var cookTime = 0;
// }
// 



class Recipe {
  final String title;
  final String url;
  final String imageUrl;
  final String html;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({this.title, this.url, this.imageUrl, this.html, this.ingredients, this.steps});
}