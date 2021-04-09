import 'package:flutter/material.dart';




import '../models/recipes.dart';
import '../widgets/recipe_item.dart';









class FavoritesScreen extends StatefulWidget {

  final List<Recipe> favoriteMeals;

  FavoritesScreen(this.favoriteMeals);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}



class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    
    if (widget.favoriteMeals.isEmpty) {
      return Center(
      child: Text('You have no favorites yet - start adding some!'),
    );
    }
    else {
      return ListView.builder(
        itemBuilder: (ctx, index) {
        return RecipeItem(
          id: widget.favoriteMeals[index].id,
          title: widget.favoriteMeals[index].title, 
          imageURL: widget.favoriteMeals[index].imageURL, 
          duration: widget.favoriteMeals[index].duration, 
          complexity: widget.favoriteMeals[index].complexity, 
          affordability: widget.favoriteMeals[index].affordability,
        );  
      }, 
      itemCount: widget.favoriteMeals.length,
      );
    }
    
  }
}