///     Filename        :     Recipe.dart
///     Date            :     4/11/2021
///     Desciption      :     This file contains the Recipe class specification. Here a recipe object is describe with its given attributes and constructor
///


import 'package:flutter/foundation.dart';


class Recipe {
  final String title;
  final String url;
  final String imageUrl;
  final String html;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({this.title, this.url, this.imageUrl, this.html, this.ingredients, this.steps});
}