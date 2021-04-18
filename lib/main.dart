///     Program         :     housechef
///     Filename        :     main.dart
///     Date            :     4/11/2021
///     Desciption      :     This file contains the void main() method use to lauch the appication.
///                           From here all application wide data is set and initalized along with defining 
///                           proper routing methods for navigation across screens.
///



import 'package:flutter/material.dart';
import './views/Add_recipe_screen.dart';



import './views/about_screen.dart';
import './views/loading_screen.dart';
import './views/tabs_screen.dart';

import './views/recipe_step.dart';
import './views/recipe_search_screen.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';

import './dal/RecipeDAL.dart';


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
    //dal.CreateDatabase();


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
      home: TabsScreen(),
      routes: {
        AboutScreen.routeName: (ctx) => AboutScreen(),
        RecipeStep.routeName: (ctx) => RecipeStep(Map<dynamic, dynamic>()),
        RecipeSearchScreen.routeName: (ctx) => RecipeSearchScreen(),
        
      },

      onGenerateRoute: (settings) {
        print(settings.arguments);
        return MaterialPageRoute(
          builder: (ctx) => TabsScreen(),
        );
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => TabsScreen(),
        );
      },
    );
  }
}
