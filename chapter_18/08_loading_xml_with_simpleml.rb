#
# Example 18-8: Loading XML with simpleML
#
load_library "simpleML"
import "simpleML"

def setup
  size 200, 200

  # Creating and starting the request
  # An array of XML elements can be retrieved using getElementArray. 
  # This only works for elements with the same name that appear multiple times in the XML document.
  @request = XMLRequest.new(self, "http://rss.news.yahoo.com/rss/topstories")
  @request.makeRequest
end

def draw
  # XXX: There are still issues related to events from imported library
  #      so we call the net_event method ourselves
  # When a request is finished the data the available flag is set to true 
  # and we get a chance to read the data returned by the request
  if @request.available?
    net_event(@request)
    no_loop
  end
end

# When a request is finished the data is received in the netEvent() 
# function which is automatically called whenever data is ready.
def net_event(ml)
  # Retrieving an array of all XML elements inside "  title*  " tags
  headlines = ml.getElementArray("title")
  headlines.each do |headline|
    puts headline # XXX: was println(headlines[i]);
  end
end