///   Filename        :   tabs_screen.dart
///   Date            :   4/11/2021
///   Description     :   This file contains the widgets used for displaying the contents of the tabs page.
///                       This page is responsible for navigating between the seawrch recipe screen, favourites screen,
///                       and write your recipe screen.
///                       
///

import 'package:flutter/material.dart';
import '../models/recipes.dart';
import 'package:flutter/services.dart';



import '../widgets/main_drawer.dart';
import '../views/favorites_screen.dart';
import 'Add_recipe_screen.dart';
import '../views/recipe_search_screen.dart';
import './favorites_screen.dart';

import './recipe_search_screen.dart';



/// Class                 : TabsScreen
/// Description           : This class instantiates the tabs screen. Composed of a bottom navigation bar this is the primary screen the user is brought to. 
///                         From here the user can choose to navigate to their screen of choice. By default the recipe search screen is the primary screen the user
///                         sees upon launch.
class TabsScreen extends StatefulWidget {

  @override
  _TabsScreenState createState() => _TabsScreenState();
}



class _TabsScreenState extends State<TabsScreen> {

  List<Map<String, Object>> _pages;

  int _selectedPageIndex = 0;

  // Initialize the state of the tabs screen for navigating between screens
  @override
  void initState() {
    
    _pages = [
      {
        'page': RecipeSearchScreen(),
        'title': 'Search Recipe',
      },
      {
        'page': FavoritesScreen(), 
        'title': 'Favorites',
      },
      {
        'page': AddRecipes(), 
        'title': 'Add a Recipe',
      },
    ];

    super.initState();
  }


  // METHOD           :   _selectPage
  // PARAMETERS       :   int index
  // RETURN           :   void
  // DESCRIPTION      :   This method is called upon when a user taps on any one of the tabs to navigate through the app
  //                      It takes an index used to differentiate between screens
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }




  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: Text(_pages[_selectedPageIndex]['title'],
        style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      
    

      drawer: MainDrawer(),

      body: _pages[_selectedPageIndex]['page'],

      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.blue,
        
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.search), 
            label: 'Search',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.favorite), 
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,

            icon: Icon(Icons.add), 
            label: 'Add a Recipe',
          ),
        ],
      ),
    );
  }
}