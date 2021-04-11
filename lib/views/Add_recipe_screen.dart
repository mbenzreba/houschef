import 'package:flutter/material.dart';

// Import for MethodChannel
import 'package:flutter/services.dart';



class AddRecipes extends StatefulWidget {
  @override
  _AddRecipes createState() => _AddRecipes();
}



class _AddRecipes extends State<AddRecipes> {
  @override
  
  Widget build(BuildContext context) {
    return Column(
      children:  <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                    ),
         ),
         Padding(
           padding: EdgeInsets.all(14),
           child: TextField(
            style: TextStyle(fontSize: 25),
            //onSubmitted: ,
            decoration: InputDecoration(labelText: 'Enter recipe name'), 
            textInputAction: TextInputAction.done,
          ),),

          SizedBox(height: 50),

          Expanded(
            child: 
            Padding(
              padding: EdgeInsets.all(14),
              child:TextField(
            //onSubmitted: ,
            style: TextStyle(fontSize: 25),
            maxLines: 15,
            decoration: InputDecoration(labelText: 'Enter your recipe'), 
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            
            ),)
            
          ),


      ],
      
      );
  }
  

  

  
}



