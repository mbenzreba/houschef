// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// import '../dummy_data.dart';
// import '../views/recipe_step.dart';

// class RecipeDetailScreen extends StatelessWidget {
//   static const routeName = '/recipe-detail';

//   // final Function toggleFavorite;
//   // final Function isFavorite;

//   // RecipeDetailScreen(this.toggleFavorite, this.isFavorite);

//   Widget buildSectionTitle(BuildContext context, String text) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Text(
//         text,
//         style: Theme.of(context).textTheme.title,
//       ),
//     );
//   }

//   Widget buildContainer(Widget child) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       margin: EdgeInsets.all(10),
//       padding: EdgeInsets.all(10),
//       // remember to add Media Query so i can size this to any phone
//       height: 200,
//       width: 300,
//       child: child,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {



    

//     final recipeId = ModalRoute.of(context).settings.arguments as String;
//     final selectedRecipe =
//         DUMMY_MEALS.firstWhere((meal) => meal.id == recipeId);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           '${selectedRecipe.title}',
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               height: 300,
//               width: double.infinity,
//               child: Image.network(
//                 selectedRecipe.imageURL,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             buildSectionTitle(context, 'Ingredients'),
//             buildContainer(
//               ListView.builder(
//                 itemBuilder: (ctx, index) => Card(
//                   color: Theme.of(context).accentColor,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 5,
//                     ),
//                     child: Text(
//                       selectedRecipe.ingredients[index],
//                     ),
//                   ),
//                 ),
//                 itemCount: selectedRecipe.ingredients.length,
//               ),
//             ),
//             buildSectionTitle(context, 'Steps'),
//             buildContainer(
//               ListView.builder(
//                 itemBuilder: (ctx, index) => Column(
//                   children: [
//                     ListTile(
//                       leading: CircleAvatar(
//                         child: Text('# ${index + 1}'),
//                       ),
//                       title: Text(
//                         selectedRecipe.steps[index],
//                       ),
//                     ),
//                     Divider(),
//                   ],
//                 ),
//                 itemCount: selectedRecipe.steps.length,
//               ),
//             ),

//           ],
//         ),
//       ),


//       floatingActionButton: SpeedDial(
//         animatedIcon: AnimatedIcons.menu_close,
//         children: [

//         SpeedDialChild(
//           child: Icon(Icons.navigation),
//           label: "Start Recipe",
//           backgroundColor: Colors.green,
//           onTap: () {
//            Navigator.of(context).pushNamed(
//              RecipeStep.routeName
//            );
//           }
//         ),

//         // SpeedDialChild(
//         //   child: Icon(isFavorite(recipeId) ? Icons.favorite : Icons.favorite_border,),
//         //   label: "Favourite",
//         //   backgroundColor: Colors.red,
//         //   onTap: () => toggleFavorite(recipeId),
//         // ),

//       ],),
//       // floatingActionButton: FloatingActionButton(
//       //   child: Icon(
//       //     isFavorite(recipeId) ? Icons.favorite : Icons.favorite_border,
//       //   ),
//       //   onPressed: () => toggleFavorite(recipeId),
//       // ),
//     );
//   }
// }
