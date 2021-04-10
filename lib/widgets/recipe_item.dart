import 'package:flutter/material.dart';



import '../models/recipes.dart';
import '../views/recipe_detail_screen.dart';




class RecipeItem extends StatelessWidget {

  final String id;
  final String title;
  final String imageURL;


  RecipeItem({
    @required this.id,
    @required this.title, 
    @required this.imageURL, 
  });




  void selectRecipe(BuildContext context) {
    Navigator.of(context).pushNamed(
      RecipeDetailScreen.routeName,
      arguments: id,
    )
    .then((result) {
      if (result !=null) {
        //removeRecipe(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectRecipe(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
          15),
        ),

        elevation: 6,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[

                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),

                  child: Image.network(
                    imageURL,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                ),

                Positioned(

                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: 250,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      vertical: 5, 
                      horizontal: 20
                    ),

                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 26, 
                        color: Colors.white
                      ),

                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )

              ],
            ),

            

          ],
        ),
      ),
      
    );
  }
}