#
# Example 18-10: A Yahoo search
#
load_library "pyahoo"
import "pyahoo"

def setup
  size 400, 400
  # Create a YahooSearch object. 
  # You have to pass in the API key given to you by Yahoo.
  @yahoo = YahooSearch.new(self, "YOUR API KEY HERE")
end

def draw
  background 255
  
  # When a request is finished the available 
  # flag is set to true - and we get a chance to read
  # the data returned by the request
  if @yahoo.available?
    # Get Titles and URLs
    titles = @yahoo.get_titles
 
    # Search results arrive as an array of Strings. 
    # You can also get the summaries with getSummaries().
    urls = @yahoo.get_urls

    titles.each_with_index do |title, i|
      puts "__________"
      puts title
      puts urls[i]
    end
    
    no_loop
  end
end

def mouse_pressed
  # Search for a String. By default you will get back 10 results. 
  # If you want more (or less), you can request a specific number by 
  # saying: yahoo.search("processing.org", 30);
  @yahoo.search "processing.org"
end

# XXX: There are still issues related to events from imported library
#      so we're not implementing this yet.
#def search_event(yahoo)
#  # Get Titles and URLs
#  titles = yahoo.get_titles
#  # Search results arrive as an array of Strings. 
#  # You can also get the summaries with getSummaries().
#  urls = yahoo.get_urls
#
#  titles.each_with_index do |title, i|
#    puts "__________"
#    puts title
#    puts urls[i]
#  end
#end
