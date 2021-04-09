import 'package:flutter/material.dart';




import '../dal/RecipeDAL.dart';
import '../dal/RecipeDataModel.dart';
import '../models/recipes.dart';
import '../widgets/recipe_item.dart';









class FavoritesScreen extends StatelessWidget {

  final List<Recipe> favoriteMeals;

  FavoritesScreen(this.favoriteMeals);

  @override
  Widget build(BuildContext context) {
    
    if (favoriteMeals.isEmpty) {
      return Center(
      child: Text('You have no favorites yet - start adding some!'),
    );
    }
    else {
      return ListView.builder(
        itemBuilder: (ctx, index) {
        return RecipeItem(
          id: favoriteMeals[index].id,
          title: favoriteMeals[index].title, 
          imageURL: favoriteMeals[index].imageURL, 
          duration: favoriteMeals[index].duration, 
          complexity: favoriteMeals[index].complexity, 
          affordability: favoriteMeals[index].affordability,
        );  
      }, 
      itemCount: favoriteMeals.length,
      );
    }
    
  }


  Future<List<RecipeDataModel>> fetchRecipes(){

    RecipeDAL dal = new RecipeDAL();

    return dal.getRecipes();
  }
}