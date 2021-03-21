package com.example.chef

class Recipe(val title: String, val instructions: String)
{
    public var steps: MutableList<Step> = mutableListOf()

    init {
        // TODO: Write instructions to an internal file
        // TODO: Send resource file through model loading to arrive at final parsed resource
    }

    
}