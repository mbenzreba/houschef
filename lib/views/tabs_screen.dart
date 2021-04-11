import 'package:flutter/material.dart';
import '../models/recipes.dart';
import 'package:flutter/services.dart';



import '../widgets/main_drawer.dart';
import '../views/favorites_screen.dart';
import 'Add_recipe_screen.dart';
import '../views/recipe_search_screen.dart';
import './favorites_screen.dart';

import './recipe_search_screen.dart';

import '../constants.dart';


class TabsScreen extends StatefulWidget {

  @override
  _TabsScreenState createState() => _TabsScreenState();
}



class _TabsScreenState extends State<TabsScreen> {

  List<Map<String, Object>> _pages;

  int _selectedPageIndex = 0;


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