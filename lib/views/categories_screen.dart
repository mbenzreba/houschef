import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../widgets/category_item.dart';


class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(  
      padding: const EdgeInsets.all(25),
      // This is where we first create a map to list of the dummy data
      children: DUMMY_CATEGORIES
      .map(
        (catData) => CategoryItem(
          catData.id,
          catData.title, 
          catData.color,
          ),
      )
      .toList(),
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 200, 
      childAspectRatio: 3 / 2, 
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      ),
    );
  
  }
}