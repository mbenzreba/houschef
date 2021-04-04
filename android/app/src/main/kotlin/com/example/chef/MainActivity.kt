package com.example.chef

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.mbenzreba.RecipePatternFinder.RecipeWordTree

class MainActivity: FlutterActivity() {


    /***************************************************************************************************/
    /******************************* INTERACTIVE VOICE ASSISTANT CHANNEL *******************************/
    /***************************************************************************************************/


    // Channel for communicating with the assistant
    private val ASSISTANT_CHANNEL = "com.example.chef/assistant"

    // Channel for communicating with web scraping
    private val SEARCH_CHANNEL = "com.example.chef/search"


    /**
     * 
     */
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Configure ASSISTANT_CHANNEL
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ASSISTANT_CHANNEL).setMethodCallHandler {
            call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "startCooking") {
                result.success(startCooking(call.arguments))
            }
            else if (call.method == "tellAssistant") {
                result.success(tellAssistant())
            }
            else {
                result.notImplemented()
            }
        }

        // Configure SEARCH_CHANNEL
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SEARCH_CHANNEL).setMethodCallHandler {
            call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "search") {
                result.success(search(call.arguments))
            }
            else {
                result.notImplemented()
            }
        }
    }



    /**
     * 
     */
    private fun startCooking(recipeUrl: Any) : String {
        // TODO: Write the actual function
        // Scrape the recipe from the url and get the details
        // Save these details to some SmartRecipe.kt
        // Inside SmartRecipe, do what you have to do...
        // Then, return the first step from SmartRecipe as a plain string!!
        return "Want to visit a ${recipeUrl}"
    }



    /**
     * 
     */
    private fun tellAssistant() : String {
        return "I told the assistant..."
    }



    /***************************************************************************************************/
    /************************************** ONLINE SEARCH CHANNEL **************************************/
    /***************************************************************************************************/


    private fun search(terms: Any) : HashMap<Int, HashMap<String, Any>> {
        var outerHashMap : HashMap<Int, HashMap<String, Any>> = HashMap<Int, HashMap<String, Any>> ()

        // Add the 1st inner hashmap
        var innerHashMap : HashMap<String, Any> = HashMap<String, Any> ()
        val bytes1 = "Youngster".toByteArray()
        innerHashMap.put("name", "Youngster")
        innerHashMap.put("bytes", bytes1)

        outerHashMap.put(1, innerHashMap)

        // Add the 1st inner hashmap 
        var innerHashMap2 : HashMap<String, Any> = HashMap<String, Any> ()
        val bytes2 = "Elder".toByteArray()
        innerHashMap2.put("name", "Elder")
        innerHashMap2.put("bytes", bytes2)

        outerHashMap.put(2, innerHashMap2)

        return outerHashMap
    }

    



    
}

