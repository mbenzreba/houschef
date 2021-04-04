import 'package:flutter/material.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';

// Import for UintList
import 'dart:typed_data';





class RecipeSearchScreen extends StatefulWidget {

  static const routeName = '/recipe-search';

  

  // *****
  TextEditingController searchController = TextEditingController();

  @override
  _RecipeSearcScreenState createState() => _RecipeSearcScreenState();
}

class _RecipeSearcScreenState extends State<RecipeSearchScreen> {

  static const platform = const MethodChannel("com.example.chef/search");
  String _content = 'No methodchannel has been called yet';

  Future<void> _search(terms) async {
    Map<dynamic, dynamic> content;
    String name = "EMPTY_NAME";
    String bytes;
    Uint8List realBytes;

    String title;
    String url;
    String actualContent = "Start of method";
    try {
      actualContent = "Entered try";
      content = await platform.invokeMethod('search', terms);
      actualContent = "Returned from platform.invoke";
      actualContent = content.toString();
      //actualContent = content[0]["title"];
      //actualContent = "anotha one";
      //Map<dynamic, dynamic> innerMap = content[1] as Map<dynamic, dynamic>;
      //actualContent = content.toString();
      //name = innerMap["name"].toString();
      //actualContent = name;
      // bytes = new String.fromCharCodes(innerMap["bytes"]);
      //realBytes = innerMap["bytes"];
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  onSubmitted: _search,
                  decoration: InputDecoration(labelText: 'Enter recipe name'), 
                  textInputAction: TextInputAction.next,
                ),
                Text(_content)
              ],
            ),
          ),
        ),
      ),


    );
  }
}