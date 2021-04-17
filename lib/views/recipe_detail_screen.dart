///   Filename        :   recipe_detail_screen.dart
///   Date            :   4/11/2021
///   Description     :   This file contains the widgets used for displaying the contents of the recipe detail screen page.
///                       From here a user will be displayed the contents of a recipe which consists of their respective 
///                       ingredients and steps.
///
import 'package:chef/views/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path/path.dart';



import 'recipe_step.dart';

import '../dal/RecipeDAL.dart';
import '../dal/RecipeDataModel.dart';



/// Class                 : TestRecipeScreen
/// Parameters            : String title, MAP<dynamic,dynamic> incomingRecipe
/// Description           : This class instantiates the recipe detail screen. This class takes two paramethers a title an a MAP object consisting of 
///                         a recipe ingredients and steps. These two are used to display the content for the user regarding the recipe they've selected
class TestRecipeScreen extends StatefulWidget {

  String title;
  
  Map<dynamic,dynamic> incomingRecipe;

  TestRecipeScreen({this.title, this.incomingRecipe});

  static const routeName = '/test-recipe';

  @override
  _TestRecipeScreenState createState() => _TestRecipeScreenState(title, incomingRecipe);
}

class _TestRecipeScreenState extends State<TestRecipeScreen> {

  
  String title;
  Map<dynamic,dynamic> incomingRecipe;
  _TestRecipeScreenState(this.title, this.incomingRecipe);

  // initState() used to initialize the content of recipe detail page
  @override
  void initState() {
    
    super.initState();
    parseMap();
  }



  // METHOD             : _parseMap
  // PARAMETERS         : void
  // RETURNS            : void
  // DESCRIPTION        : This method is used to parse a recipe step one at a time looking for a specified delimiter.
  void parseMap() {

    List<String> ingredients;
    List<String> steps;

    if (incomingRecipe['ingredients'].toString().contains('^')){
      ingredients = incomingRecipe['ingredients'].toString().split('^');
      incomingRecipe['ingredients'] = ingredients;
    }

    if (incomingRecipe['steps'].toString().contains('^')){
      steps = incomingRecipe['steps'].toString().split('^');
      incomingRecipe['steps'] = steps;
    } 

    else if (incomingRecipe['steps'].runtimeType == String ) {
      String temp = incomingRecipe['steps'];
      incomingRecipe['steps'] = new List<String>();
      incomingRecipe['steps'].add(temp);
    }

  }


  // METHOD             : buildContainer
  // PARAMETERS         : Widget child
  // RETURNS            : Widget
  // DESCRIPTION        : This method recieves a widget and builds a container with the necessary padding and decoration for displaying the widget.
  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 200,
      width: 300,
      child: child,
    );
  }



    // METHOD             : buildSectionTitle
    // PARAMETERS         : BuildContext context, String text
    // RETURNS            : Widget
    // DESCRIPTION        : This method recieves two parameters the first a context of type BuildContext and the second is a 
    //                      title of type String. This method designs a widget that will be used for displaying the recipe title on the page
    Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildSectionTitle(context, 'Ingredients'),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      // ingredients go here
                      
                      incomingRecipe['ingredients'][index],
                    ),
                  ),
                ),
                itemCount: incomingRecipe['ingredients'].length,
              ),
            ),
            buildSectionTitle(context, 'Steps'),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text('# ${index + 1}'),
                      ),
                      title: Text(
                        incomingRecipe['steps'][index],
                      ),
                    ),
                    Divider(),
                  ],
                ),
                itemCount: incomingRecipe['steps'].length,
              ),
            ),

          ],
        ),
      ),


      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [

        SpeedDialChild(
          child: Icon(Icons.navigation),
          label: "Start Recipe",
          backgroundColor: Colors.green,
          onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (ctx) => Loading(incomingRecipe)));
          }
        ),

        SpeedDialChild(
          child: Icon(Icons.favorite_border,),
          label: "Favourite",
          backgroundColor: Colors.red,
          onTap: () {
            // logic for insert goes here 
            String tempUrl = "";
            String tempImageUrl = "";
            String tempIng = "";
            String tempSteps = "";

            if (incomingRecipe['url'] != null)
            {
              tempUrl = incomingRecipe['url'];
            }

            if(incomingRecipe['imgUrl'] != null)
            {
              tempImageUrl = incomingRecipe['imgUrl'];
            }

            if (incomingRecipe['ingredients'] != null) {

              String tmp = "";
              if(incomingRecipe['ingredients'] is List){

                
                for(int i = 0; i < incomingRecipe['ingredients'].length; i++){

                  tmp = tmp + incomingRecipe['ingredients'][i] + "^";
                }
              }
              
              tempIng = tmp;
            }

            if (incomingRecipe['steps'] != null) {

              String tmp = "";
              if(incomingRecipe['steps'] is List){

                
                for(int i = 0; i < incomingRecipe['steps'].length; i++){

                  tmp = tmp + incomingRecipe['steps'][i] + "^";
                }
              }
              
              tempSteps = tmp;
            }

            RecipeDataModel model = new RecipeDataModel(title: this.title, url: tempUrl, imgUrl: tempImageUrl, steps: tempSteps, ingredients: tempIng );
            
            WriteRecipe(model);
            
          },
        ),

      ],),
    );
  }



  // METHOD           : WriteRecipe
  // PARAMETERS       : RecipeDataModel
  // RETURN           : Future
  // DESCRIPTION      : This function returns a future used for establishing a connection to a databse for inserting a recipe
  //                    data model. This is called upon when a user wishes to favorite a recipe or write one of their own.
  Future<void> WriteRecipe(RecipeDataModel model) async {

    RecipeDAL dal = new RecipeDAL();
    
    await dal.Connect();

    await dal.insertRecipe(model);
    
    await dal.getRecipes();
  }
}