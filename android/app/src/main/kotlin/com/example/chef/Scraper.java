
package com.example.webscraping;
import android.util.Log;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Scraper {

    public Scraper() {

    }

    public List<Recipe> search(String url){

        List<Recipe> recipes = new ArrayList<>();

        Document doc = null;


        //attempt to connect to a url
        try {
            doc = Jsoup.connect(url).get();

        }catch(IOException e){

            e.printStackTrace();
            return recipes;
        }
        //GET ENTRIES FOR TITLE AND IMG

        Elements titles = doc.select("h3.card__title");

        Elements images = doc.getElementsByAttributeValueStarting("src","https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%");

        Elements links = doc.getElementsByAttributeValueStarting("href", "https://www.allrecipes.com/recipe/");

        for(int i = 0; i<titles.size(); i++){

            Log.d("Title #" + (i), titles.eq(i).text());
            Log.d("Image #" + (i), images.eq(i).attr("src") + "-");
            Log.d("Link #" + (i), links.eq((i + 1) * 2).attr("href"));

            Recipe r = new Recipe();

            r.setTitle(titles.eq(i).text());
            r.setImgUrl(images.eq(i).attr("src"));
            r.setUrl(links.eq((i + 1) * 2).attr("href"));

            recipes.add(r);
        }


        return recipes;

    }

    

    public Recipe getRecipeByUrl(Recipe r){



        return r;
    }
}
