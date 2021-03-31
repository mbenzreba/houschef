import 'package:flutter/material.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';



class RecentRecipes extends StatefulWidget {
  @override
  _RecentRecipesState createState() => _RecentRecipesState();
}



class _RecentRecipesState extends State<RecentRecipes> {
  static const platform = const MethodChannel("com.example.chef/assistant");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is where recent recipes will go'),
    );
  }

  // Get battery level.
}



