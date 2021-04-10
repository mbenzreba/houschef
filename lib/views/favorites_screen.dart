
import 'package:flutter/material.dart';




import '../dal/RecipeDAL.dart';
import '../dal/RecipeDataModel.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';


class FavoritesScreen extends StatefulWidget {


  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();

}



class _FavoritesScreenState extends State<FavoritesScreen> {

  List<RecipeDataModel> list;



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
        return Text('Recipe'); 
          
      }, 
      itemCount: list.length,
      );
    }

    
  }


  @override
  void initState() {

    super.initState();
    list = new List<RecipeDataModel>();
    GetData();


  }
 

  Future<void> GetData() async {

    RecipeDAL dal = new RecipeDAL();
    
    await dal.Connect();

    list = await dal.getRecipes();
    
    
  }



}