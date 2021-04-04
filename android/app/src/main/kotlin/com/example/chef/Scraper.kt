package com.example.chef

import android.util.Log
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import java.io.IOException
import java.util.*

class Scraper {
    fun search(searchTerm: String): List<Recipe> {
        val recipes: MutableList<Recipe> = ArrayList()
        var doc: Document? = null
        val url = "https://www.allrecipes.com/search/results/?search=$searchTerm"

        //attempt to connect to a url
        doc = try {
            Jsoup.connect(url).get()
        } catch (e: IOException) {
            e.printStackTrace()
            return recipes
        }
        //GET ENTRIES FOR TITLE AND IMG
        var titles = doc?.select("h3.card__title")
        var images = doc?.getElementsByAttributeValueStarting("src", "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%")
        var links = doc?.getElementsByAttributeValueStarting("href", "https://www.allrecipes.com/recipe/")

        var x = 0
        for (i in titles!!) {
            Log.d("Title #$i", titles.eq(x).text())
            Log.d("Image #$i", images!!.eq(x).attr("src") + "-")
            Log.d("Link #$i", links!!.eq((x + 1) * 2).attr("href"))
            val r = Recipe()
            r.title = titles!!.eq(x).text()
            r.imgUrl = images!!.eq(x).attr("src")
            r.url = links!!.eq((x + 1) * 2).attr("href")
            recipes.add(r)
            x++;
        }
        return recipes
    }

    fun getDetails(r: Recipe): Recipe {
        try {
            r.html = Jsoup.connect(r.url).get().html()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return r
    }
}