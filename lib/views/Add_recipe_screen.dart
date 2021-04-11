import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';
import '../dal/RecipeDAL.dart';
import '../dal/RecipeDataModel.dart';



class AddRecipes extends StatefulWidget {
  @override
  _AddRecipes createState() => _AddRecipes();
}



class _AddRecipes extends State<AddRecipes> {

  String title;
  String steps;


  Future<void> WriteRecipe(RecipeDataModel model) async {

            RecipeDAL dal = new RecipeDAL();

            await dal.Connect();

            await dal.insertRecipe(model);

            await dal.getRecipes();
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
            onSubmitted: (value) => title,
            decoration: InputDecoration(labelText: 'Enter recipe name'), 
            textInputAction: TextInputAction.done,
          ),),

          SizedBox(height: 50),

          Expanded(
            child: 
            Padding(
              padding: EdgeInsets.all(14),
              child:TextField(
              onSubmitted: (value) => steps,
            style: TextStyle(fontSize: 25),
            maxLines: 15,
            decoration: InputDecoration(labelText: 'Enter your recipe'), 
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            
            ),)
            
          ),


      ],
      

      
      ),
    
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.close_menu,
        children: [

        SpeedDialChild(
          child: Icon(Icons.favorite),
          label: "Start Recipe",
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



