///   Filename        :   add_recipe_screen.dart
///   Date            :   4/11/2021
///   Description     :   This file contains the widgets used for displaying the add a recipe screen
///                       




import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';
import '../dal/RecipeDAL.dart';
import '../dal/RecipeDataModel.dart';


// CLASS            : AddRecipes
// DESCRIPTION      : This class instantiates the add a recipe screen. Here a user can manually enter a recipe by giving it a title and list of steps 
//                    so that the system can intgrate it with the text to speech functionality 
class AddRecipes extends StatefulWidget {
  @override
  _AddRecipes createState() => _AddRecipes();
}



class _AddRecipes extends State<AddRecipes> {

  String title;
  String steps;

  TextEditingController _controller;


  // Initalize the state of the page
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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


  // METHOD           : saveSteps
  // PARAMETERS       : String value
  // RETURN           : void
  // DESCRIPTION      : This function takes a value of type string and assigns it to a global value of steps.
  void saveSteps(String value) {
    steps = value;
    print("Saved our steps!!");
  }


  // METHOD           : saveTitle
  // PARAMETERS       : String value 
  // RETURN           : void
  // DESCRIPTION      : This function takes a value of type string and assigns it to a global value of title.
  void saveTitle(String value) {
    title = value;
    print("Saved our title!!");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body:Column(
      
      children:  <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                    ),
         ),
         Padding(
           padding: EdgeInsets.all(14),
           child: TextField(
            style: TextStyle(fontSize: 25),
            onSubmitted: saveTitle,
            decoration: InputDecoration(labelText: 'Enter recipe name'), 
            textInputAction: TextInputAction.done,
          ),),

          SizedBox(height: 50),

          Expanded(
            child: 
            Padding(
              padding: EdgeInsets.all(14),
              child:TextField(
              onSubmitted: saveSteps,
            style: TextStyle(fontSize: 25),
            maxLines: 15,
            decoration: InputDecoration(labelText: 'Enter your recipe'), 
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            
            ),)
            
          ),


      ],),
    
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        children: [

        SpeedDialChild(
          child: Icon(Icons.save),
          label: "Add this recipe",
          backgroundColor: Colors.blue,
          onTap: () {
            
            if(this.title != null && this.steps != null){
              RecipeDataModel model = new RecipeDataModel(title: this.title, url: '', imgUrl: '', steps: this.steps, ingredients: '');

              WriteRecipe(model);
            }

          }
        ),
        ],
      ),
        
    );
  }
  
  
}



