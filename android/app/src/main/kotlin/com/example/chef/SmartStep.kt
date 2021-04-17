package com.example.chef


// IMPORTS
import com.mbenzreba.RecipePatternFinder.RecipeWordTree


/**
 * Simply used as a wrapper for the RecipeWordTrees that represent each step of the recipe.
 */
class SmartStep {

    /** A smart object that organizes a sentence as a tree and is able to tell what parts of the tree
     * (ie what words in the sentence) correspond to what target the user is asking for (ie ingredient,
     * time, temperature)
     */
    var tree: RecipeWordTree = RecipeWordTree("(ANY )")
    
}