package com.example.chef


class Recipe {
    var title: String? = null
    var url: String? = null
    var imgUrl: String? = null
    var html: String? = null
    var steps: MutableList<String>? = null
    var ingredients: MutableList<String>? = null
    var cookTime = 0
}