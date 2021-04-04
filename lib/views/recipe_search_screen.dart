import 'package:flutter/material.dart';







class RecipeSearchScreen extends StatefulWidget {

  static const routeName = '/recipe-search';

  @override
  _RecipeSearcScreenState createState() => _RecipeSearcScreenState();
}

class _RecipeSearcScreenState extends State<RecipeSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter recipe name'), 
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
        ),
      ),


    );
  }
}