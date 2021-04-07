package com.example.chef

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.mbenzreba.RecipePatternFinder.RecipeWordTree
import com.mbenzreba.RecipePatternFinder.PreParser
import com.mbenzreba.RecipePatternFinder.RecipeWordTreeArborist

import android.os.Handler
import android.os.Looper
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.*
import kotlinx.coroutines.Dispatchers

import android.util.Log

class MainActivity: FlutterActivity() {

    var currentlyCooking: Recipe = Recipe()


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
            else if (call.method == "searchFullDetails") {
                result.success(searchFullDetails(call.arguments))
            }
            else {
                result.notImplemented()
            }
        }
    }



    /**
     * 
     */
    private fun startCooking(args: Any) : String {
        // TODO: Write the actual function
        // Scrape the recipe from the url and get the details
        // Save these details to some SmartRecipe.kt
        // Inside SmartRecipe, do what you have to do...
        // Then, return the first step from SmartRecipe as a plain string!!
        currentlyCooking = Recipe()
        if (args is String) {
            currentlyCooking.url = args
            currentlyCooking.title = args
        }
        

        var scraper: Scraper = Scraper()
        currentlyCooking.steps = mutableListOf()
        currentlyCooking.ingredients = mutableListOf()
        currentlyCooking = scraper.getDetails(currentlyCooking)

        // Use Recipe to populate the SmartSteps it keeps track of

        // OpenNLP 
        var pp: PreParser = PreParser()
        var rawRecipe: String = ""

        // Construct entire recipe as one whole string
        for (step in currentlyCooking.steps!!) {
            rawRecipe = rawRecipe + " " + step
        }

        var parses: MutableList<String> = pp.rawToParses(rawRecipe)
        for (parse in parses) {
            // Add it to the recipe (r) as a SmartStep
            var ss: SmartStep = SmartStep()
            ss.tree = RecipeWordTreeArborist.get().createTree(parse)
            currentlyCooking.smartSteps?.add(ss!!)
        }



        return currentlyCooking.smartSteps?.get(0)!!.tree.getSentence()
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


    private fun search(terms: Any) : HashMap<Int, HashMap<String, String>> {
        var outerHashMap : HashMap<Int, HashMap<String, String>> = HashMap<Int, HashMap<String, String>> ()

        var scraper : Scraper = Scraper()
        var scrapeData: List<Recipe>? = null

        // NETWORKING ****

        GlobalScope.launch(Dispatchers.IO) {
            // Scrape
            scrapeData  = scraper.search(terms.toString())

            var count : Int = 0
            for (r in scrapeData!!) {
                var recipe : HashMap<String, String> = HashMap<String, String>()
                recipe.put("title", r.title!!)
                recipe.put("url", r.url!!)

                outerHashMap.put(count, recipe)
                count++
            }

            

            
        }
        // NETWORKING ****

        Thread.sleep(6000)

        

        /* 
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

        outerHashMap.put(2, innerHashMap2) */

        return outerHashMap
        
    }


    private fun searchFullDetails(url: Any) : HashMap<String, Any> {
        var details : HashMap<String, Any> = HashMap<String, Any> ()

        var r: Recipe = Recipe()
        if (url is String) {
            r.url = url
        }

        r.steps = mutableListOf()
        r.ingredients = mutableListOf()
        
        
        var scraper: Scraper = Scraper()

        GlobalScope.launch(Dispatchers.IO) {
            r = scraper.getDetails(r)
            

            
        }
        Log.d("DEBUG", "Got the details fine " + r)
        Thread.sleep(8000)

        Log.d("DEBUG", "R.steps is " + r.steps)
        Log.d("DEBUG", "R.ingredients is " + r.ingredients)
        details.put("steps", r.steps!!)
        details.put("ingredients", r.ingredients!!)

        
        
        return details
    }


    



    
}

