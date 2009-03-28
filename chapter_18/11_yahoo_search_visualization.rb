#
# Example 18-11: Yahoo search visualization
#
load_library "pyahoo"
import "pyahoo"

# The names to search
NAMES = %w{ Aliki Cleopatra Penelope Daniel Peter }

def setup
  size 500, 300
  text_font create_font("Georgia", 20, true)
  smooth

  # Search for all names
  # The search() function is called for each name in the array.
  @yahoo = []
  NAMES.each do |name|
    # Create a YahooSearch object. 
    # You have to pass in the API key given to you by Yahoo.
    @yahoo << YahooSearch.new(self, "YOUR API KEY HERE")
    @yahoo.last.search(name)
  end

  @bubbles     = { }
  @search_count = 0
end

def draw
  background 255

  # poll all yahoo searches
  @yahoo.each do |yahoo|
    search_event(yahoo) if yahoo.available?
  end

  # Show all bubbles
  @bubbles.values.each do |bubble|
    bubble.display
  end
end

def search_event(yahoo)
  # Total # of results for each search
  # getTotalResultsAvailable() returns the total number of web pages that Yahoo found containing the search phrase. 
  # These numbers can be quite large so they are scaled down before being used as an ellipse size.
  total = yahoo.get_total_results_available

  # Scale down the number so that it can be viewable
  r = sqrt(total) / 75.0

  # Make a new bubble object
  # The search data is used to make a Bubble object for the visualization.
  search = yahoo.get_search_string
  return if @bubbles.has_key? search

  b = Bubble.new(search, r, 50 + @search_count * 100, $app.height / 2)
  @bubbles[search] = b
  @search_count   += 1
end

#
#  Simple "Bubble" class to represent each search
#
class Bubble
  def initialize(search, r, x, y)
    @search = search
    @r = r
    @x = x
    @y = y    
  end

  def display
    $app.stroke 0
    $app.fill 0, 50
    $app.ellipse @x, @y, @r, @r
    $app.text_align PApplet::CENTER
    $app.fill 0
    $app.text @search, @x, @y
  end
end
