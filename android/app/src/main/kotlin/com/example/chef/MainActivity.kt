package com.example.chef

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val ASSISTANT_CHANNEL = "com.example.chef/assistant"
    
    // Set up method channel
    // private val a_channel = MethodChannel(flutterView, ASSISTANT_CHANNEL)

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ASSISTANT_CHANNEL).setMethodCallHandler {
            call, result ->
            // Note: this method is invoked on the main thread.
            // TODO
        }
    }

    private fun startCooking() {
        // ...
    }

    private fun tellAssistant() {
        // ...
    }
}

