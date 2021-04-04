import 'dart:typed_data';

import 'package:flutter/material.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';



class RecentRecipes extends StatefulWidget {
  @override
  _RecentRecipesState createState() => _RecentRecipesState();
}



class _RecentRecipesState extends State<RecentRecipes> {
  static const platform = const MethodChannel("com.example.chef/search");

  String _content = 'No methodchannel has been called yet';

  Future<void> _startCooking(String recipeUrl) async {
    String content;
    try {
      content = await platform.invokeMethod('startCooking', recipeUrl);
    } on PlatformException catch (e) {
      content = "Failed to start cooking";
    }

    setState(() {
      _content = content;
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
      _content = content;
    });
  }


  Future<void> _search(terms) async {
    Map<dynamic, dynamic> content;
    String name = "EMPTY_NAME";
    String bytes;
    Uint8List realBytes;
    String actualContent = "Start of method";
    try {
      actualContent = "Entered try";
      content = await platform.invokeMethod('search', terms);
      actualContent = "Returned from platform.invoke";
      actualContent = content.toString();
      Map<dynamic, dynamic> innerMap = content[1] as Map<dynamic, dynamic>;
      //actualContent = content.toString();
      name = innerMap["name"].toString();
      //actualContent = name;
      // bytes = new String.fromCharCodes(innerMap["bytes"]);
      realBytes = innerMap["bytes"];
      //actualContent = realBytes.toString();
    } on PlatformException catch (e) {
    } 
    //on NoSuchMethodError catch (e) {

    //}

    setState(() {
      _content = actualContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child:
            ElevatedButton(child: 
              Text("Call methodchannel"),
              onPressed: () => _search('Mohamed'),
              onLongPress: _tellAssistant,
            )
        ),
        Center(child: Text(_content),)
      ]
    );
  }

  // Get battery level.
}



