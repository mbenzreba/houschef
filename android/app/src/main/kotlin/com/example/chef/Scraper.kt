package com.example.chef

import android.util.Log
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import java.io.IOException
import java.util.*


//CLASS       : Scraper
//DESCRIPTION : Class to retrieve and update recipes from the web
class Scraper {


    //METHOD      : search
    //PARAMETERS  : searchTerm: String
    //RETURNS     : List<Recipe>
    //DESCRIPTION : Goes and retrieves data based on a search term
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


    //METHOD      : getDetails
    //PARAMETERS  : r: Recipe
    //RETURNS     : Recipe
    //DESCRIPTION : A recipe is submitted and the details are updated based on the info in the url
    //              returns the same thing as submitted if blank
    fun getDetails(r: Recipe): Recipe {

        var doc: Document? = null

        //try to connect
        doc = try {
            Jsoup.connect(r.url).get()
        } catch (e: IOException) {
            e.printStackTrace()
            return r
        }

        
        var steps = doc?.select("p")
        var ingredients = doc?.select("span.ingredients-item-name")


        //grabbing the steps
        var index: Int = 0
        for(i in steps!!){
            
            if(index > 0 && index < steps!!.size - 2){
                r.steps?.add(i.text())
            }

            Log.d("s found", "Added to steps: " + i.text())
            index++
        }

        //grabbing the ingredients
        index = 0
        for(i in ingredients!!){

            r.ingredients?.add(i.text())

            Log.d("i found", "Added to ingredients: " + i.text())
            index++
        }

        return r
    }
}
