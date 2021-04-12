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

  bool firstTime = false;

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
        firstTime = true;
      } else {
        selectedRecipe = content;
      }
       
    });
  }

  ListView createRecipeWidgets() {
    
    

    recipeMap.forEach((key, value) => urls.add(value['url']));
    
     return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
        itemCount: recipeMap.length,
        itemBuilder: (ctx, index) => GestureDetector(
                  onTap: () {
                    titleOrSteps = true;
                    
                    _search(urls[index]);
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => TestRecipeScreen(title: recipeMap[index]['title'], incomingRecipe: selectedRecipe)));
                  },
                  child: Card(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                          15),
                        ),


                        elevation: 6,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[

                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),

                  child: Image.network(
                    recipeMap[index]['imgUrl'],
                    errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                      return Image.asset('assets/images/notfound.jpg');
                    }, 
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                ),

                Positioned(

                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: 250,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      vertical: 5, 
                      horizontal: 20
                    ),

                    child: Text(
                      recipeMap[index]['title'],
                      style: TextStyle(
                        fontSize: 26, 
                        color: Colors.white
                      ),

                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                    
                  ),
                  
                ),
                Padding(padding: EdgeInsets.all(10),
                child: Text('Retrieved from allrecipes.com', style: TextStyle(fontSize: 16, color: Colors.black),),)
                
              ],
            ),

            

          ],
        ),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Text(
                    //       recipeMap[index]['title'],
                    //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    //       ),

                    //       Text('Retrieved from allrecipes.com', style: TextStyle(fontSize: 12),),
                    //     ], 
                    //   ),
                      
                    // ),
                  ),
        ),
      );
    
      
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
                //!recipeMap.isNotEmpty && firstTime == false ? createRecipeWidgets() : Center(child: Text('Sorry! The recipe entered does not exist'))
                createRecipeWidgets()
              ],
            ),
          ),
        ),
      );


    
  }
}