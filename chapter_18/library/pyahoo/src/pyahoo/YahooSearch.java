/* Processing Yahoo! Search Library
 * Daniel Shiffman, 8/02/2007
 * Processing bridge to Yahoo! Search API
 * Requires the Yahoo! Search SDK from 
 * http://developer.yahoo.com/download 
 * code on Yahoo! API example.
 */

package pyahoo;

import processing.core.*;

import java.io.IOException;
import java.lang.reflect.*;
import java.math.BigInteger;

import com.yahoo.search.SearchClient;
import com.yahoo.search.SearchException;
import com.yahoo.search.WebSearchRequest;
import com.yahoo.search.WebSearchResult;
import com.yahoo.search.WebSearchResults;

public class YahooSearch implements Runnable {

    PApplet parent;
    String key;
    Method eventMethod;
    Thread runner;
    boolean available = false;
    String searchString;
    int numRequested = 10;
    SearchClient client;
    WebSearchResults results;
    boolean searching = false;

    public YahooSearch(PApplet parent, String key) {
        client = new SearchClient(key); //Jm3V0PbV34GKpO58IjWbVvW26XjoKlrkriC2D4idXRBm8No3VDoCCjQLhBqsjJ9wRVI
        results = null;
        this.parent = parent;
        this.key = key;
        parent.registerDispose(this);
        try {
            eventMethod = parent.getClass().getMethod("searchEvent", new Class[] { 
                    YahooSearch.class             }
            );
        } 
        catch (Exception e) {
            //System.out.println("Hmmm, event method no go?");
        }
    }

    public void search(String searchString_) {
        search(searchString_,10);
    }

    public void search(String searchString_, int num) {
        if (!searching) {
            searching = true;
            numRequested = num;
            searchString = searchString_;
            runner = new Thread(this);
            runner.start();
        // This is maybe a bit hacky, but it'll make sure one search
        // doesn't overwrite another
        } else {
            YahooSearch ys = new YahooSearch(parent,key);
            ys.search(searchString_,num);
        }
    }

    public boolean available() {
        return available;
    }

    public WebSearchResults getResults() {
        return results;
    }

    public String[] getTitles() {
        if (results == null) return null;
        WebSearchResult[] resultsArray = results.listResults();
        String[] titles = new String[resultsArray.length];
        for (int i = 0; i < titles.length; i++) {
            titles[i] = resultsArray[i].getTitle();
        }
        return titles;
    }

    public String[] getUrls() {
        if (results == null) return null;
        WebSearchResult[] resultsArray = results.listResults();
        String[] urls = new String[resultsArray.length];
        for (int i = 0; i < urls.length; i++) {
            urls[i] = resultsArray[i].getUrl();
        }
        return urls;
    }

    public String[] getSummaries() {
        if (results == null) return null;
        WebSearchResult[] resultsArray = results.listResults();
        String[] summaries = new String[resultsArray.length];
        for (int i = 0; i < summaries.length; i++) {
            summaries[i] = resultsArray[i].getSummary();
        }
        return summaries;
    }

    public WebSearchResult[] getResultsArray() {
        if (results == null) return null;
        return results.listResults();
    }

    public int getTotalResultsAvailable() {
        int total = 0;
        if (results != null) {
            BigInteger count = results.getTotalResultsAvailable();
            total = count.intValue();
        }
        return total;
    }

    public void run() {
        try {
            available = false;
            WebSearchRequest request = new WebSearchRequest(searchString);
            System.out.println("Searching for " + searchString);
            request.setResults(numRequested);
            results = client.webSearch(request);
            available = true;
            if (eventMethod != null) {
                try {
                    eventMethod.invoke(parent, new Object[] { 
                            this                     }
                    );
                } 
                catch (Exception e) {
                    e.printStackTrace();
                    eventMethod = null;
                }
            }
            searching = false;
        } catch (IOException e) {
            System.out.println("Error calling Yahoo! Search Service: " + e.toString());
            e.printStackTrace();
        } catch (SearchException e) {
            System.out.println("Error calling Yahoo! Search Service: " + e.toString());
            e.printStackTrace();
        }
    }

    /**
     * Called by applets to stop.
     */
    public void stop() {
        runner = null; // unwind the thread
    }

    /**
     * Called by PApplet to shut down
     */
    public void dispose() {
        stop();
    }

    public String getSearchString() {
        return searchString;
    }

    public int getNumberRequested() {
        return numRequested;
    }

}
