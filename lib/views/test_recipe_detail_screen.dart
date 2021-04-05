
import 'package:flutter/material.dart';
// Import for MethodChannel
import 'package:flutter/services.dart';

// Import for UintList
import 'dart:typed_data';







class TestRecipeScreen extends StatefulWidget {

  String url;
  TestRecipeScreen(this.url);

  static const routeName = '/test-recipe';

  @override
  _TestRecipeScreenState createState() => _TestRecipeScreenState(url);
}

class _TestRecipeScreenState extends State<TestRecipeScreen> {

  String url;
  _TestRecipeScreenState(this.url);

  static const platform = const MethodChannel("com.example.chef/search");

  Map<dynamic, dynamic> selectedRecipe = new Map();
  String _content = "NO CONTENT";

  Future<void> _search(url) async {

    // This is the important one
    // content[0]['title'] to access the title of the recipe 
    // content[0]['url'] to get the url  
    Map<dynamic, dynamic> content;
    String name = "EMPTY_NAME";
    String bytes;
    Uint8List realBytes;

    String title;
    
    String actualContent = "Start of method";
    try {
      actualContent = "Entered try";
      content = await platform.invokeMethod('searchFullDetails', url);
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
      _content = actualContent;
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("name"),
      ),
      body: Container(
      child: Center(
        child: FlatButton(
          onPressed: () => _search(url),
          child: Text(_content),
          ),
        ),
      ),
    );

    
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       '${selectedRecipe.title}',
    //     ),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Container(
    //           height: 300,
    //           width: double.infinity,
    //           child: Image.network(
    //             selectedRecipe.imageURL,
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //         buildSectionTitle(context, 'Ingredients'),
    //         buildContainer(
    //           ListView.builder(
    //             itemBuilder: (ctx, index) => Card(
    //               color: Theme.of(context).accentColor,
    //               child: Padding(
    //                 padding: EdgeInsets.symmetric(
    //                   horizontal: 10,
    //                   vertical: 5,
    //                 ),
    //                 child: Text(
    //                   selectedRecipe.ingredients[index],
    //                 ),
    //               ),
    //             ),
    //             itemCount: selectedRecipe.ingredients.length,
    //           ),
    //         ),
    //         buildSectionTitle(context, 'Steps'),
    //         buildContainer(
    //           ListView.builder(
    //             itemBuilder: (ctx, index) => Column(
    //               children: [
    //                 ListTile(
    //                   leading: CircleAvatar(
    //                     child: Text('# ${index + 1}'),
    //                   ),
    //                   title: Text(
    //                     selectedRecipe.steps[index],
    //                   ),
    //                 ),
    //                 Divider(),
    //               ],
    //             ),
    //             itemCount: selectedRecipe.steps.length,
    //           ),
    //         ),

    //       ],
    //     ),
    //   ),


    //   floatingActionButton: SpeedDial(
    //     animatedIcon: AnimatedIcons.menu_close,
    //     children: [

    //     SpeedDialChild(
    //       child: Icon(Icons.navigation),
    //       label: "Start Recipe",
    //       backgroundColor: Colors.green,
    //       onTap: () {
    //        Navigator.of(context).pushNamed(
    //          RecipeStep.routeName
    //        );
    //       }
    //     ),

    //     SpeedDialChild(
    //       child: Icon(isFavorite(recipeId) ? Icons.favorite : Icons.favorite_border,),
    //       label: "Favourite",
    //       backgroundColor: Colors.red,
    //       onTap: () => toggleFavorite(recipeId),
    //     ),

    //   ],),
    //   // floatingActionButton: FloatingActionButton(
    //   //   child: Icon(
    //   //     isFavorite(recipeId) ? Icons.favorite : Icons.favorite_border,
    //   //   ),
    //   //   onPressed: () => toggleFavorite(recipeId),
    //   // ),
    // );
  }
}