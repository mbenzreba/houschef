import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

import 'RecipeDataModel.dart';


//CLASS       : RecipeDAL 
//DESCRIPTION : Handles the connection, reading, and writing from the local recipes database
//              Inspiration from Dart tutorial : https://flutter.dev/docs/cookbook/persistence/sqlite
class RecipeDAL {
  
  String dbName;

  Future<Database> db;

  RecipeDAL({this.dbName});


  //METHOD      : Connect
  //DESCRIPTION : establishes a connection to the database and creates the recipe table
  Future<void> Connect() async {
    
    //flutter widget safety 
    WidgetsFlutterBinding.ensureInitialized();

    db = openDatabase(
      
      //get the datavase path and join 
      join(await getDatabasesPath(), 'recipedatabase.db'),
      //
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE IF NOT EXISTS recipes(title TEXT, url TEXT, imgUrl TEXT, steps TEXT, ingredients TEXT)",
        );
      },
      version: 1,
    );
  }

  //METHOD      : getDbInstance
  //RETURNS     : Future<Database> - representing the reference to the local db
  //DESCRIPTION : Async function to grab a reference to the db
  Future<Database> getDbInstance() async {

    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'recipedatabase.db');

    //use await keyword to ensure concurrency
    return await openDatabase(path, version: 1);

  }

  
  //METHOD      : insertRecipe
  //PARAMETERS  : RecipeDataModel recipeDataModel
  //RETURNS     : Future<void>
  //DESCRIPTION : Takes a recipedatamodel and inserts it into the local db
  Future<void> insertRecipe(RecipeDataModel recipeDataModel) async {
    
    final Database tempDb = await db; 

    await this.Connect();

    await tempDb.insert(
      'recipes',
      recipeDataModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  //METHOD      : getRecipes()
  //RETURNS     : Future<List<RecipeDataModel>>
  //DESCRIPTION : get a future list of all recipes in the db
  Future<List<RecipeDataModel>> getRecipes() async {

    final Database tempDb = await db;

    // Query the table for all The Recipes.
    final List<Map<String, dynamic>> maps = await tempDb.query('recipes');

    Set<Map> set = new Set.from(maps);
    set.forEach((maps) => print(maps.toString()));   


    // Convert the List<Map<String, dynamic> into a List<>.
    return List.generate(maps.length, (i) {
      return RecipeDataModel(
        title: maps[i]['title'],
        url: maps[i]['url'],
        imgUrl: maps[i]['imgUrl'],
        steps: maps[i]['steps'],
        ingredients: maps[i]['ingredients'],
      );
    });
  }

  //METHOD      : deleteRcipes
  //PARAMETERS  : String name
  //RETURNS     : Future<void>
  //DESCRIPTION : Deletes a recipe by name
  Future<void> deleteRecipe(String name) async {
    // Get a reference to the database.
    final tempDb= await db;

    await tempDb.delete(
      'recipes',
      where: "name = ?",
      whereArgs: [name],
    );
  }

  //METHOD      : WipeDb()
  //DESCRIPTION : drops the only db table
  Future<void> wipeDb() async {

    final tempDb= await db;
    await tempDb.execute("DROP TABLE recipes");
  }
}
