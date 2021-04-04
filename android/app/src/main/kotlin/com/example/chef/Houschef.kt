package com.example.chef

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.speech.RecognizerIntent
import android.speech.tts.TextToSpeech
import android.util.Log
import android.widget.Toast
import java.util.*

class Houschef : Activity {
    private lateinit var tts:TextToSpeech // a TextToSpeech object used to have text read to the user

    var ingredients:List<String> // the list of ingredients of the recipe
    var ingredientStep:Int = -1 // the current ingredient that the user is on of the recipe
    var finishedIngredients:Boolean = false

    var instructions:List<String> // recipe instructions that will be read to the user
    var currentStep:Int = -1  // the current step that the user is on of the recipe

    var unrecognizedRequest:Boolean = false // keeps track if user responded with an unrecognized command
    var cancelRequest:Boolean = false // keeps track if the user responded with a cancel command
    var invalidStepRequest:Boolean = false // keeps track if the user requests an invalid step

    var currentContext:Context? = null // keeps track of the context of the activity that called the Houschef class
    var currentActivity:Activity // keeps track of the activity that called the Houschef class

    // constants used to determine which speech operation to carry out
    private val kRequestCodeSpeechInput = 100
    private val kRequestCodeConfirmation = 101



    // Function:    constructor()
    // Description: a constructor that initializes the Houschef object
    // Parameters:
    // Return:      N/A
    constructor(context: Context, activity: Activity, recipeInstructions: List<String>, recipeIngredients: List<String>) {
        currentContext = context
        currentActivity = activity
        instructions = recipeInstructions
        ingredients = recipeIngredients

        tts = TextToSpeech(context, TextToSpeech.OnInitListener { status ->
            if (status == TextToSpeech.SUCCESS) {
                val result = tts.setLanguage(Locale.CANADA)

                if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                    Log.e("TTS", "Language not supported")
                }
            }
        })
    }



    // Function:    listenForRequest()
    // Description: setups an intent to begin listening for user requests to interact with the recipe
    // Parameters:  listenCode: an integer that is used to determine which type of response is expected from the user
    // Return:      N/A
    fun listenForRequest(listenCode: Int) {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        intent.putExtra(
            RecognizerIntent.EXTRA_LANGUAGE_MODEL,
            RecognizerIntent.LANGUAGE_MODEL_FREE_FORM
        )
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault())

        if (listenCode === kRequestCodeSpeechInput) {
            intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Hi, say something")
        }
        else if (listenCode == kRequestCodeConfirmation) {
            intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Confirm Cancellation?")
        }

        try {
            currentActivity.startActivityForResult(intent, listenCode)
        }
        catch (e: Exception) {
            Toast.makeText(currentContext, e.message, Toast.LENGTH_SHORT).show()
        }
    }


    // Function:    activityResult()
    // Description: called upon when a request is retrieved by the user and processes the request
    // Parameters:  N/A
    // Return:      N/A
    open fun activityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when(requestCode) {
            kRequestCodeSpeechInput -> {
                if (resultCode == Activity.RESULT_OK && null != data) {
                    val result = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)

                    determineRequest(result[0])
                    processRequest()
                }
            }
            kRequestCodeConfirmation -> {
                if (resultCode == RESULT_OK && null != data) {
                    val result = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)

                    // if the user response is no to the cancellation prompt, the recipe will continue being read
                    if (result[0].toLowerCase() == "no") {
                        tts.speak("Okay, returning to recipe instructions", TextToSpeech.QUEUE_ADD, null)
                        listenForRequest(kRequestCodeSpeechInput)
                    }
                    // if the user responds with yes to the cancellation prompt,
                    else if (result[0].toLowerCase() == "yes") {
                        tts.speak("Okay, cancelling recipe instructions.", TextToSpeech.QUEUE_ADD, null)
                    }
                }
            }
        }
    }



    // Function:    determineRequest()
    // Description: takes in the input from the user and sets class attributes depending on their desired request
    // Parameters:  inputResult: the input that was given by the user
    // Return:      N/A
    private fun determineRequest(inputResult: String) {
        // if the user indicates to go to the next step of the instructions, the current step counter is incremented
        if (inputResult.toLowerCase().contains("next"))
        {
            // if the current step has not exceeded the amount of steps in the recipe, it will be incremented
            if (currentStep != instructions.size - 1) {
                currentStep += 1
            }

//            if (!finishedIngredients) {
//                ingredientStep += 1
//            }
//            else {
//                // if the current step has not exceeded the amount of steps in the recipe, it will be incremented
//                if (currentStep != instructions.size - 1) {
//                    currentStep += 1
//                }
//            }
        }
        // if the user indicates to go to the previous step of the instructions, the current step counter is decremented
        else if (inputResult.toLowerCase().contains("previous") || inputResult.toLowerCase().contains("last"))
        {
            if (currentStep == -1) {
                currentStep = 0
            }

            if (currentStep != 0) {
                currentStep -= 1
            }
        }
        // if the user indicates to have the last read step to be repeated, the current step stays the same
        else if (inputResult.toLowerCase().contains("repeat")) {
//            if (ingredientStep == -1) {
//                ingredientStep = 0
//            }
            if (currentStep == -1) {
                currentStep = 0
            }
        }
        // if the user indicates to go to a specific step, the current step will be set to the desired step to be read
        else if (inputResult.toLowerCase().contains("what is") && inputResult.toLowerCase().contains("step")) {
            findStepNumber(inputResult)
        }
        // if the user indicates to cancel the recipe guide, the recipe will end and the previous screen is displayed
        else if (inputResult.toLowerCase().contains("cancel")) {
            cancelRequest = true
        }
        // else, the input was not valid and a prompt to repeat the command is displayed
        else {
            unrecognizedRequest = true
        }
    }



    // Function:    processRequest()
    // Description: carries out the user's request based on the class attributes
    // Parameters:  N/A
    // Return:      N/A
    private fun processRequest() {
        // if the current step has exceeded the max index of the instructions list, the assistant indicates the
        // recipe has been finished
        if (currentStep >= instructions.size) {
            tts.speak("The recipe has been completed.", TextToSpeech.QUEUE_FLUSH, null)
        }
        // if the recipe has not been cancelled, the current step the user has requested is read to them
        else if (!cancelRequest) {

            // if the last command said by the user was unrecognized, another prompt for a command is made a prompt
            // for clarification is made
            if (unrecognizedRequest) {
                tts.speak("Command not recognized or invalid. Please repeat your request.", TextToSpeech.QUEUE_FLUSH, null)
                unrecognizedRequest = false
            }
            // else, the requested step is read to the user
            else {
//                if (!finishedIngredients) {
//                    tts.speak(ingredients[ingredientStep], TextToSpeech.QUEUE_FLUSH, null)
//
//                    if (ingredientStep == ingredients.size - 1) {
//                        finishedIngredients = true
//                    }
//                }
//                else {
//                    tts.speak(instructions[currentStep], TextToSpeech.QUEUE_FLUSH, null)
//                }
                tts.speak(instructions[currentStep], TextToSpeech.QUEUE_FLUSH, null)
            }

            Thread.sleep(2000)
            listenForRequest(kRequestCodeSpeechInput)
        }
        // if the current recipe has been cancelled, a prompt to confirm the cancellation is asked
        else if (cancelRequest) {
            tts.speak("Are you sure you would like to cancel?", TextToSpeech.QUEUE_FLUSH, null)
            cancelRequest = false
            listenForRequest(kRequestCodeConfirmation)
        }
    }



    // Function:    findStepNumber()
    // Description: attempts to search a string to determine which number step the user
    //              is requesting to be read to them
    // Parameters:  inputToSearch: the string that will be searched for the requested step number
    // Return:      N/A
    private fun findStepNumber(inputToSearch: String) {
        val stepRegex = Regex("\\b([1-9]|[1-9][0-9]|100)\\b")
        val match = stepRegex.find(inputToSearch)
        var newStep = convertAlphaToNumeric(inputToSearch)

        // if the user response did not include words for a numeric step, an attempt to
        // retrieve an int value is made
        if (newStep == -1) {
            try {
                newStep = match?.value!!.toInt()

                // if the requested step is greater than the amount of steps in the recipe,
                // an exception is thrown
                if (newStep > instructions.size) {
                    throw Exception("Invalid Step")
                }

                currentStep = newStep - 1
            }
            catch (e: Exception) {
                unrecognizedRequest = true
            }
        }
        // else, current step is set to the step requested by the user
        else {
            currentStep = newStep -1
        }
    }



    // Function:    convertAlphaToNumeric()
    // Description: takes a string and if there are any worded numbers within the string
    //              the represented numeric value is returned
    // Parameters:  alphaString: the string to be searched for a worded numeric value
    // Return:      convertedNum: the numeric value of the worded number, if none are present
    //                            -1 is returned
    private fun convertAlphaToNumeric(alphaString: String) : Int {
        var convertedNum = -1

        when {
            alphaString.contains("one") -> {
                convertedNum = 1
            }
            alphaString.contains("two") -> {
                convertedNum = 2
            }
            alphaString.contains("three") -> {
                convertedNum = 3
            }
            alphaString.contains("for") -> {
                convertedNum = 4
            }
            alphaString.contains("five") -> {
                convertedNum = 5
            }
            alphaString.contains("six") -> {
                convertedNum = 6
            }
            alphaString.contains("seven") -> {
                convertedNum = 7
            }
            alphaString.contains("eight") -> {
                convertedNum = 8
            }
            alphaString.contains("nine") -> {
                convertedNum = 9
            }
        }

        return convertedNum
    }
}