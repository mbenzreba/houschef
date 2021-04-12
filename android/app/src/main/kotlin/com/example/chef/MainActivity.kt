package com.example.chef

// IMPORTS
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



/**
 * Main activity for method channel passing between Flutter and the underlying Android
 * implementation of the Houschef logic.
 */
class MainActivity: FlutterActivity() {

    /** The recipe we are currently cooking (ie the assistant is currently dictating) */
    var currentlyCooking: Recipe = Recipe()

    /** The current step the assistant is dictating */
    var currentStep: Int = 0

    /** The virtual assistant */
    var houschef: Houschef? = null

    /** The string contents of the step currently being dictated by the assistant */
    var stepContent: String = ""

    /** Used to load in models */
    var loader: PreParser = PreParser(false)

    /** The contents of the step currently being dictated by the assistant */
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
     * Configure the FlutterEngine for message passing on the above channels.
     * 
     * @param[flutterEngine] needed to configure method channels for
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
            else if (call.method == "getLatestStep") {
                result.success(getLatestStep())
            }
            else if (call.method == "startCookingLocal") {
                result.success(startCookingLocal(call.arguments))
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



    /**
     * Gets the latest step being dictated by the assistant.
     * 
     * @return a HashMap of the step and what words to highlight in the step
     */
    private fun getLatestStep() : HashMap<Any, Any> {
        // Now return the map
        var map: HashMap<Any, Any> = HashMap<Any, Any>()
        map.put("step", stepHolder.stepContents)
        map.put("highlights", stepHolder.stepHighlights)

        return map
    }

    

    /**
     * Modifies the state of the activity. Initializes the RecipeWordTrees and information needed
     * to accurately run the assistant.
     */
    private fun startCookingLocal(rawRecipe: Any) : HashMap<String, Any> {

        // TODO: Write the actual function
        // Scrape the recipe from the url and get the details
        // Save these details to some SmartRecipe.kt
        // Inside SmartRecipe, do what you have to do...
        // Then, return the first step from SmartRecipe as a plain string!!
        currentlyCooking = Recipe()

        var singleStep: String = rawRecipe.toString()

        var parses: MutableList<String> = mutableListOf()

        parses = loader.rawToParses(singleStep)

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
     * Modifies the state of the MainActivity. Takes the URL of the recipe and returns the latest
     * step being dictated to the user.
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
     * Modifies the state of MainActivity. Starts up the virtual assistant and returns the
     * latest step dictated by the assistant.
     * 
     * @return the latest step dictated by the assistant
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



    /***************************************************************************************************/
    /************************************** ONLINE SEARCH CHANNEL **************************************/
    /***************************************************************************************************/



    /**
     * Search online for recipes corresponding to the terms argument. Returns a map of Recipe selection
     * maps (essentially a list of objects).
     * 
     * @param[terms] terms to search by
     * @return a list of selections taken from online
     */
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

        return outerHashMap
    }



    /**
     * Given a URL, returns a more complete map of the recipe (represented at that URL).
     * 
     * @param[url] the URL to get the rest of the recipe details from
     * @return the recipe represented as a map, where each field is a string
     */
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



    /**
     * Loads the models in a seperate thread so that parsing with pre-trained models can be done on
     * incoming recipes.
     * 
     * @return true
     */
    private fun loadModels(): Boolean {
        
        GlobalScope.launch(newSingleThreadContext("LoadModelsThread")) {
            loader.loadSentenceDetector()
            loader.loadTokenizer()
            loader.loadParser()
        }

        return true;
    }



    
}

