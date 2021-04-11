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

  static const platform_Two = const MethodChannel("com.example.chef/search");

  bool titleOrSteps = false;

  String _content = 'No methodchannel has been called yet';

  Map<dynamic, dynamic> recipeMap = new Map();
  Map<dynamic, dynamic> selectedRecipe = new Map();
  var urls = [];

  Future<void> _search(value) async {

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
      if (titleOrSteps == false) {
        actualContent = "Entered try";
        content = await platform.invokeMethod('search', value);
        actualContent = "Returned from platform.invoke";
        actualContent = content.toString();
        
      }
      else {
        actualContent = "Entered try";
        content = await platform_Two.invokeMethod('searchFullDetails', value);
        actualContent = "Returned from platform.invoke";
        actualContent = content.toString();
      }
      
    } on PlatformException catch (e) {
    } 
    //on NoSuchMethodError catch (e) {

    //}

    setState(() {
      //_content = actualContent;
      if (titleOrSteps == false) {
        recipeMap = content;
      } else {
        selectedRecipe = content;
      }
       
    });
  }

  ListView createRecipeWidgets() {
    
    

    recipeMap.forEach((key, value) => urls.add(value['url']));
    if (recipeMap != null) {return ListView.builder(
      shrinkWrap: true,
        itemCount: recipeMap.length,
        itemBuilder: (ctx, index) => GestureDetector(
                  onTap: () {
                    titleOrSteps = true;
                    // setState(() {
                    //   _search(urls[index]);
                    // });
                    _search(urls[index]);
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => TestRecipeScreen(title: recipeMap[index]['title'], incomingRecipe: selectedRecipe)));
                  },
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                          recipeMap[index]['title'],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),

                          Text('Retrieved from allrecipes.com', style: TextStyle(fontSize: 12),),
                        ], 
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
           color: Colors.white,
           child: const Center(child: Text('Entry A')),
         ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                SizedBox(height: 20),
                createRecipeWidgets(),
              ],
            ),
          ),
        ),
      );


    
  }
}