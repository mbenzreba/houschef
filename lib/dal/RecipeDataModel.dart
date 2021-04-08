import '';


class RecipeDataModel {
  final String title;
  final String url;
  final String imgUrl;
  final String steps;
  final String ingredients;

  RecipeDataModel({this.title, this.url, this.imgUrl, this.steps, this.ingredients});


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