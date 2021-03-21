import 'package:flutter/material.dart';
import '../views/categories_screen.dart';



import '../models/recipes.dart';
import '../widgets/recipe_item.dart';






class CategoryMealsScreen extends StatefulWidget {

  static const routeName = '/category-meals';

  final List<Recipe> availableMeals;

  CategoryMealsScreen(this.availableMeals);


  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {

  String categoryTitle;
  List<Recipe> displayedMeals;
  var _loadedInitData = false;

  @override
  void initState() {
    
    super.initState();
  }



  @override
  void didChangeDependencies() {

    if (!_loadedInitData) {
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      final categoryId = routeArgs['id'];

      displayedMeals = widget.availableMeals.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();

    _loadedInitData = true;
    }
    
    super.didChangeDependencies();
  }


  void _removeRecipe(String recipeId) {
    setState(() {
      displayedMeals.removeWhere((recipe) => recipe.id == recipeId);
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle
          ),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
        return RecipeItem(
          id: displayedMeals[index].id,
          title: displayedMeals[index].title, 
          imageURL: displayedMeals[index].imageURL, 
          duration: displayedMeals[index].duration, 
          complexity: displayedMeals[index].complexity, 
          affordability: displayedMeals[index].affordability,
        );  
      }, 
      itemCount: displayedMeals.length,
      ),
    );
  }
}