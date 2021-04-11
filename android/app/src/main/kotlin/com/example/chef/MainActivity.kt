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

import android.content.Intent

import android.util.Log

class MainActivity: FlutterActivity() {

    var currentlyCooking: Recipe = Recipe()
    var currentStep: Int = 0
    var houschef: Houschef? = null
    var stepContent: String = ""
    var loader: PreParser = PreParser(false)

    var stepHolder: StepHolder = StepHolder()


    /***************************************************************************************************/
    /******************************* INTERACTIVE VOICE ASSISTANT CHANNEL *******************************/
    /***************************************************************************************************/


    // Channel for communicating with the assistant
    private val ASSISTANT_CHANNEL = "com.example.chef/assistant"

    // Channel for communicating with web scraping
    private val SEARCH_CHANNEL = "com.example.chef/search"

    // Channel for communicating with Apache OpenNLP models
    private val LOAD_CHANNEL = "com.example.chef/load"


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
            else if (call.method == "startCooking_SPH") {
                result.success(tellAssistant())
            }
            else if (call.method == "getLatestStep") {
                result.success(getLatestStep())
            }
            else if (call.method == "cancelCooking") {
                houschef = null
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

        // Configure LOAD_CHANNEL
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LOAD_CHANNEL).setMethodCallHandler {
            call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "loadModels") {
                result.success(loadModels())
            }
            else if (call.method == "areModelsLoaded") {
                result.success(loader.areModelsLoaded())
            }
            else if (call.method == "searchFullDetails") {
                result.success(searchFullDetails(call.arguments))
            }
            else {
                result.notImplemented()
            }
        }
    }


    private fun getLatestStep() : HashMap<String, Any> {
        // Now return the map
        var map: HashMap<String, Any> = HashMap<String, Any>()
        map.put("step", stepHolder.stepContents)
        map.put("highlights", stepHolder.stepHighlights)

        return map
    }



    /**
     * 
     */
    private fun startCooking(args: Any) : HashMap<String, Any> {
        // TODO: Write the actual function
        // Scrape the recipe from the url and get the details
        // Save these details to some SmartRecipe.kt
        // Inside SmartRecipe, do what you have to do...
        // Then, return the first step from SmartRecipe as a plain string!!
        currentlyCooking = Recipe()
        if (args is String) {
            currentlyCooking.url = args
        }
        

        var scraper: Scraper = Scraper()
        currentlyCooking.steps = mutableListOf()
        currentlyCooking.ingredients = mutableListOf()
        currentlyCooking.smartSteps = mutableListOf()

        GlobalScope.launch(Dispatchers.IO) {
            currentlyCooking = scraper.getDetails(currentlyCooking)
        }

        Thread.sleep(4000)

        
        

        // Use Recipe to populate the SmartSteps it keeps track of

        // OpenNLP 
        /* var pp: PreParser = PreParser() */
        var rawRecipe: String = ""

        // Construct entire recipe as one whole string
        for (step in currentlyCooking.steps!!) {
            rawRecipe = rawRecipe + " " + step
        }

        var parses: MutableList<String> = mutableListOf()
        

        parses = loader.rawToParses(rawRecipe)

        for (parse in parses) {
            // Add it to the recipe (r) as a SmartStep
            var ss: SmartStep = SmartStep()
            ss.tree = RecipeWordTreeArborist.get().createTree(parse)
            currentlyCooking.smartSteps?.add(ss!!)
        }
        
        
        


        currentStep = 0

        // Now return the map
        var map: HashMap<String, Any> = HashMap<String, Any>()
        stepHolder.stepContents = currentlyCooking.smartSteps!!.get(0).tree.getSentence()
        map.put("step", stepHolder.stepContents)
        map.put("highlights", stepHolder.stepHighlights)

        return map
    }



    /**
     * 
     */
    private fun tellAssistant() : HashMap<String, Any> {
        houschef = Houschef(this, this, currentlyCooking.steps!!, currentlyCooking.ingredients!!, currentlyCooking, this.stepHolder)
        houschef!!.listenForRequest(100)
        currentStep++
        
        if (houschef!!.currentStep == -1) {
            stepContent = "Ask Houschef to start cooking!"
        }
        else {
            //stepContent = houschef!!.instructions[houschef!!.currentStep]
            stepContent = houschef!!.recipe.smartSteps!!.get(houschef!!.currentStep).tree.getSentence()
        }

        // Now return the map
        var map: HashMap<String, Any> = HashMap<String, Any>()
        map.put("step", stepHolder.stepContents)
        map.put("highlights", stepHolder.stepHighlights)

        return map
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        houschef!!.activityResult(requestCode, resultCode, data)
    }



    /**
     * 
     */
    private fun startCooking_SPH(args: Any) : String {
        // TODO: Write the actual function
        // Scrape the recipe from the url and get the details
        // Save these details to some SmartRecipe.kt
        // Inside SmartRecipe, do what you have to do...
        // Then, return the first step from SmartRecipe as a plain string!!
        currentlyCooking = Recipe()
        if (args is String) {
            currentlyCooking.url = args
        }
        

        var scraper: Scraper = Scraper()
        currentlyCooking.steps = mutableListOf()
        currentlyCooking.ingredients = mutableListOf()
        currentlyCooking.smartSteps = mutableListOf()

        GlobalScope.launch(Dispatchers.IO) {
            currentlyCooking = scraper.getDetails(currentlyCooking)
        }

        Thread.sleep(4000)

        
        

        // Use Recipe to populate the SmartSteps it keeps track of

        // OpenNLP 
        /* var pp: PreParser = PreParser() */
        var rawRecipe: String = ""

        // Construct entire recipe as one whole string
        for (step in currentlyCooking.steps!!) {
            rawRecipe = rawRecipe + " " + step
        }

        var parses: MutableList<String> = mutableListOf()
        
        /* 
        parses = loader.rawToParses(rawRecipe)

        for (parse in parses) {
            // Add it to the recipe (r) as a SmartStep
            var ss: SmartStep = SmartStep()
            ss.tree = RecipeWordTreeArborist.get().createTree(parse)
            currentlyCooking.smartSteps?.add(ss!!)
        }
        */
        
        
        


        currentStep = 0
        return currentlyCooking.steps!!.get(0)
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
                recipe.put("imgUrl", r.imgUrl!!)

                outerHashMap.put(count, recipe)
                count++
            }

            

            
        }
        // NETWORKING ****

        Thread.sleep(3500)

        

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
        Thread.sleep(3500)

        Log.d("DEBUG", "R.steps is " + r.steps)
        Log.d("DEBUG", "R.ingredients is " + r.ingredients)

        details.put("url", r.url!!)
        details.put("steps", r.steps!!)
        details.put("ingredients", r.ingredients!!)

        
        
        return details
    }


    /***************************************************************************************************/
    /************************************** MODEL LOADING CHANNEL **************************************/
    /***************************************************************************************************/


    private fun loadModels(): Boolean {
        
        GlobalScope.launch(newSingleThreadContext("LoadModelsThread")) {
            loader.loadSentenceDetector()
            loader.loadTokenizer()
            loader.loadParser()
        }

        return true;
    }



    
}

