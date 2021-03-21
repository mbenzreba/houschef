import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../widgets/main_drawer.dart';


class FiltersScreen extends StatefulWidget {

  static const routeName = '/filters';
  final Function saveFilters;

  final Map<String, bool> currentFilters;

  FiltersScreen(this.currentFilters, this.saveFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {

  var _glutenFree = false;
  var _vegentarian = false;
  var _vegan = false;
  var _lactoseFree = false;


  @override
  initState() {
    _glutenFree = widget.currentFilters['gluten'];
    _lactoseFree = widget.currentFilters['lactose'];
    _vegan = widget.currentFilters['vegan'];
    _vegentarian = widget.currentFilters['vegetarian'];
    super.initState();
  }

  Widget _buildSwitchListTile(String title, String description, bool currentValue, Function updateValue) {

    return SwitchListTile(
                  title: Text(title),
                  value: currentValue,
                  subtitle: Text(description), 
                  onChanged: updateValue,
                );

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: Text('Your Filters'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), 
          onPressed: () {
            final selectedFilters = {
               'gluten': _glutenFree,
               'lactose': _lactoseFree,
               'vegan': _vegan,
               'vegetarian': _vegentarian,
            };
            widget.saveFilters(selectedFilters);
           },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: <Widget>[

          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection', 
              style: Theme.of(context).textTheme.title,
            ),
          ),

          Expanded(
            child: ListView(
              children: <Widget>[
                
                _buildSwitchListTile('Glutten-free', 'Only inclue glutten-free meals', _glutenFree, (newVal) {
                  setState(() {
                    _glutenFree = newVal;
                  });
                }),

                _buildSwitchListTile('Lactose-free', 'Only inclue lactose-free meals', _lactoseFree, (newVal) {
                  setState(() {
                    _lactoseFree = newVal;
                  });
                }),


                 _buildSwitchListTile('Vegetarian', 'Only inclue vegetarian meals', _vegentarian, (newVal) {
                  setState(() {
                   _vegentarian = newVal;
                  });
                }),

                _buildSwitchListTile('Vegan', 'Only inclue vegan meals', _vegan, (newVal) {
                  setState(() {
                   _vegan = newVal;
                  });
                }),


              ],
            ),
          ),

      ],),
    );

  }
}