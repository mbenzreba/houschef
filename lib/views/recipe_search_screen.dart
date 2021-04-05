import 'package:flutter/material.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';

// Import for UintList
import 'dart:typed_data';

import './test_recipe_detail_screen.dart';



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

  Map<dynamic, dynamic> recipeMap = new Map();
  var urls = [];

  Future<void> _search(terms) async {

    // This is the important one
    // content[0]['title'] to access the title of the recipe 
    // content[0]['url'] to get the url  
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
      //_content = actualContent;
      recipeMap = content;
    });
  }


  ListView createRecipeWidgets() {
    int x = 0;
    

    recipeMap.forEach((key, value) => urls.add(value['url']));
    print(urls);
    if (recipeMap != null) {return ListView.builder(
      shrinkWrap: true,
        itemCount: recipeMap.length,
        itemBuilder: (ctx, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => TestRecipeScreen(urls[index])));
                  },
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        recipeMap[index]['title'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
        ),
      );
    } else {
      return ListView(
        children: <Widget>[
         Container(
           height: 50,
           color: Colors.amber[600],
           child: const Center(child: Text('Entry A')),
         ),
        ],
      );
    }
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
                  textInputAction: TextInputAction.done,
                ),
                //Text(_content)
                createRecipeWidgets(),
              ],
            ),
          ),
        ),
      ),


    );
  }
}