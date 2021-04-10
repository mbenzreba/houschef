import './views/test_recipe_detail_screen.dart';
import 'package:flutter/material.dart';



import './dummy_data.dart';
import './views/about_screen.dart';
import './views/filters_screen.dart';
import './views/recipe_detail_screen.dart';
import './views/tabs_screen.dart';
import './models/recipes.dart'; 
import './views/recipe_step.dart';
import './views/recipe_search_screen.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';

import './dal/RecipeDAL.dart';
import './dal/RecipeDataModel.dart';

void main() {
  runApp(MyApp());
  
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const platform = const MethodChannel("com.example.chef/load");

  RecipeDAL dal;

  Future<void> _loadModels() async {
    bool areThreadsLaunched;
    try {
      areThreadsLaunched = await platform.invokeMethod('loadModels');
    } on PlatformException catch (e) {
      areThreadsLaunched = false;
    }
  }

  @override
  void initState() {

    _loadModels();
    dal = new RecipeDAL(); 
    dal.CreateDatabase();

  }


  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Recipe> _availableMeals = DUMMY_MEALS;
  List<Recipe> _favoritedRecipes = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((recipe) {
        if (_filters['gluten'] && !recipe.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !recipe.isLactoseFree) {
          return false;
        }
        if (_filters['vegetarian'] && !recipe.isVegetarian) {
          return false;
        }
        if (_filters['vegan'] && !recipe.isVegan) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String recipeId) {
    final exsitingIndex =
        _favoritedRecipes.indexWhere((recipe) => recipe.id == recipeId);

    if (exsitingIndex >= 0) {
      setState(() {
        _favoritedRecipes.removeAt(exsitingIndex);
      });
    } else {
      setState(() {
        _favoritedRecipes.add(
          DUMMY_MEALS.firstWhere((recipe) => recipe.id == recipeId));
      });
    }
  }



  bool _isRecipeFavorite(String id) {
    return _favoritedRecipes.any((recipe) => recipe.id == id);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HousChef',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.blue,
        textTheme: ThemeData.light().textTheme.copyWith(
            body1: TextStyle(
              color: Color.fromRGBO(20, 50, 50, 1),
            ),
            body2: TextStyle(
              color: Color.fromRGBO(20, 50, 50, 1),
            ),
            title: TextStyle(
              fontSize: 24,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home always marks the entry point of our application
      home: TabsScreen(_favoritedRecipes),
      routes: {
        RecipeDetailScreen.routeName: (ctx) => RecipeDetailScreen(_toggleFavorite, _isRecipeFavorite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
        AboutScreen.routeName: (ctx) => AboutScreen(),
        RecipeStep.routeName: (ctx) => RecipeStep(Map<dynamic, dynamic>()),
        RecipeSearchScreen.routeName: (ctx) => RecipeSearchScreen(),
        //TestRecipeScreen.routeName: (ctx) => TestRecipeScreen(),
    
      },

      onGenerateRoute: (settings) {
        print(settings.arguments);
        return MaterialPageRoute(
          builder: (ctx) => TabsScreen(_favoritedRecipes),
        );
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => TabsScreen(_favoritedRecipes),
        );
      },
    );
  }
}
