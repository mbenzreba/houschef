import 'package:flutter/material.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';



class RecentRecipes extends StatefulWidget {
  @override
  _RecentRecipesState createState() => _RecentRecipesState();
}



class _RecentRecipesState extends State<RecentRecipes> {
  static const platform = const MethodChannel("com.example.chef/assistant");

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child:
            ElevatedButton(child: 
              Text("Call methodchannel"),
              onPressed: () => _startCooking('url.com'),
              onLongPress: _tellAssistant,
            )
        ),
        Center(child: Text(_content),)
      ]
    );
  }

  // Get battery level.
}



