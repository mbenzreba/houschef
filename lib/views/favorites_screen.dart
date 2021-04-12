///   Filename        :   favorites_screen.dart
///   Date            :   4/11/2021
///   Description     :   This file contains the widgets used for displaying the contents of the favorites page.
///                       From here a user can select from a list of recipes saved to immediately begin cooking.
///


import 'package:flutter/material.dart';


import '../dal/RecipeDAL.dart';
import '../dal/RecipeDataModel.dart';
import 'recipe_detail_screen.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';



/// Class                 : FavouriteScreen
/// Description           : This class instantiates the favorite screen used to display a list of recipes a 
///                         a user selected to favorite
class FavoritesScreen extends StatefulWidget {


  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();

}



class _FavoritesScreenState extends State<FavoritesScreen> {

  List<RecipeDataModel> list;
  

  Timer timer;


  @override
  Widget build(BuildContext context) {
    
    
    if (list.isEmpty) {
      return Center(
      child: Text('You have no favorites yet - start adding some!'),
    );
    }
    else {
      return ListView.builder(
        itemBuilder: (ctx, index) {
        return InkWell(
      onTap: () {
        Map<String, dynamic> recipeMap = list[index].toMap();
        print(recipeMap);
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => TestRecipeScreen(title: recipeMap['title'], incomingRecipe: recipeMap)));
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
                    list[index].imgUrl,
                    errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                      return Image.asset('assets/images/notfound.jpg');
                    },
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                ),

                Positioned(

                  bottom: 5,
                  
                  child: Container(
                    width: 250,
                    padding: EdgeInsets.symmetric(
                      vertical: 5, 
                      horizontal: 20
                    ),

                    child: Text(
                      list[index].title,
                      style: TextStyle(
                        fontSize: 20, 
                        color: Colors.black
                      ),

                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )

              ],
            ),

            

          ],
        ),
      ),
      
    ); 
        
      }, 
      itemCount: list.length,
      );
    }

    
  }

  //    METHOD      :   initState
  //    PARAMETERS  :   void
  //    RETURNS     :   void
  //    DESCRIPTION :   initializes the state of the screen
  @override
  void initState() {

    super.initState();
    list = new List<RecipeDataModel>();

    GetData();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => GetLatestData());

  }
  


  //    METHOD      :   getLatestData
  //    PARAMETERS  :   void
  //    RETURNS     :   void
  //    DESCRIPTION :   Reads at a specified time to constanly check for the most up to date information regarding a saved recipe
  void GetLatestData(){

    setState(() {
      if(!list.isEmpty){
        list = list;

      }
    });
  }





  //    METHOD      :     GetData
  //    PARAMETERS  :     void
  //    RETURNS     :     Future
  //    DESCRIPTION :     Returns an instance of a future. Using asyc technology we await for a method in the future 
  Future<void> GetData() async {

    RecipeDAL dal = new RecipeDAL();
    
    await dal.Connect();

    list = await dal.getRecipes();
  }
}