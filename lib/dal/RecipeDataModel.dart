//CLASS       : RecipeDataModel
//DESCRIPTION : A datamodel meant to interface with the db by converting to a map

class RecipeDataModel {
  final String title;
  final String url;
  final String imgUrl;
  final String steps;
  final String ingredients;

  RecipeDataModel({this.title, this.url, this.imgUrl, this.steps, this.ingredients});

  //METHOD      : toMap
  //RETURNS     : Map<String, dynamic>
  //DESCRIPTION : Converts the object to a map and returns it
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'imgUrl': imgUrl,
      'steps': steps,
      'ingredients': ingredients,
    };
  }
}