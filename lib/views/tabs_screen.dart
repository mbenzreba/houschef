import 'package:flutter/material.dart';
import '../models/recipes.dart';



import '../widgets/main_drawer.dart';
import '../views/favorites_screen.dart';
import '../views/recent_recipe_screen.dart';
import '../views/categories_screen.dart';
import './favorites_screen.dart';





class TabsScreen extends StatefulWidget {

  final List<Recipe> favoriteMeals;

  TabsScreen(this.favoriteMeals);

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
        'page': CategoriesScreen(),
        'title': 'Categories',
      },
      {
        'page': FavoritesScreen(widget.favoriteMeals), 
        'title': 'Favorites',
      },
      {
        'page': RecentRecipes(), 
        'title': 'Recent',
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
        title: Text(_pages[_selectedPageIndex]['title']),
      ),

      drawer: MainDrawer(),

      body: _pages[_selectedPageIndex]['page'],

      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category), 
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.favorite), 
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.history), 
            label: 'Recents',
          ),
        ],
      ),
    );
  }
}