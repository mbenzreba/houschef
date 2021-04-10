import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

import 'RecipeDataModel.dart';

class RecipeDAL {
  
  String dbName;

  Future<Database> db;

  RecipeDAL({this.dbName});

  Future<void> Connect() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();

    db = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'recipedatabase.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE IF NOT EXISTS recipes(title TEXT, url TEXT, imgUrl TEXT, steps TEXT, ingredients TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<Database> getDbInstance() async {

    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'recipedatabase.db');

    return await openDatabase(path, version: 1);

  }

  // Define a function that inserts dogs into the database
  Future<void> insertRecipe(RecipeDataModel recipeDataModel) async {
  
    final Database tempDb = await db; 

    await tempDb.insert(
      'recipes',
      recipeDataModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  Future<List<RecipeDataModel>> getRecipes() async {

    final Database tempDb = await db;

    // Query the table for all The Recipes.
    final List<Map<String, dynamic>> maps = await tempDb.query('recipes');

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


  Future<void> deleteRecipe(String name) async {
    // Get a reference to the database.
    final tempDb= await db;

    // Remove the Dog from the Database.
    await tempDb.delete(
      'recipes',
      // Use a `where` clause to delete a specific dog.
      where: "name = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }
}
