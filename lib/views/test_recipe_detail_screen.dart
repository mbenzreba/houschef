
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';



import '../views/recipe_step.dart';





class TestRecipeScreen extends StatefulWidget {

  String title;
  
  Map<dynamic,dynamic> incomingRecipe;

  TestRecipeScreen({this.title, this.incomingRecipe});

  static const routeName = '/test-recipe';

  @override
  _TestRecipeScreenState createState() => _TestRecipeScreenState(title, incomingRecipe);
}

class _TestRecipeScreenState extends State<TestRecipeScreen> {

  
  String title;
  Map<dynamic,dynamic> incomingRecipe;
  _TestRecipeScreenState(this.title, this.incomingRecipe);

  //var steps =[];

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      // remember to add Media Query so i can size this to any phone
      height: 200,
      width: 300,
      child: child,
    );
  }




    Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    //incomingRecipe.forEach((key, value) => steps.add(value['steps']));

    // test scaffold
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       title,
    //     ),
    //   ),
    //   body: Center(child: Text('We Made IT!'),),
    // );
    // 
    
    print(incomingRecipe['steps']);
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print(incomingRecipe['ingredients']);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildSectionTitle(context, 'Ingredients'),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      // ingredients go here
                      incomingRecipe['ingredients'][index],
                    ),
                  ),
                ),
                itemCount: incomingRecipe['ingredients'].length,
              ),
            ),
            buildSectionTitle(context, 'Steps'),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text('# ${index + 1}'),
                      ),
                      title: Text(
                        incomingRecipe['steps'][index],
                      ),
                    ),
                    Divider(),
                  ],
                ),
                itemCount: incomingRecipe['steps'].length,
              ),
            ),

          ],
        ),
      ),


      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [

        SpeedDialChild(
          child: Icon(Icons.navigation),
          label: "Start Recipe",
          backgroundColor: Colors.green,
          onTap: () {
          //  Navigator.of(context).pushNamed(
          //    RecipeStep.routeName
          //  );
           Navigator.push(context, MaterialPageRoute(builder: (ctx) => RecipeStep(incomingRecipe)));
          }
        ),

        // SpeedDialChild(
        //   child: Icon(isFavorite(recipeId) ? Icons.favorite : Icons.favorite_border,),
        //   label: "Favourite",
        //   backgroundColor: Colors.red,
        //   onTap: () => toggleFavorite(recipeId),
        // ),

      ],),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(
      //     isFavorite(recipeId) ? Icons.favorite : Icons.favorite_border,
      //   ),
      //   onPressed: () => toggleFavorite(recipeId),
      // ),
    );
  }
}