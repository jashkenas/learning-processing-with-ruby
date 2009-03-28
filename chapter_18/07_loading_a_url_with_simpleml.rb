#
# Example 18-7: Loading a URL with simpleML
#
load_library "simpleML"
import "simpleML"

def setup
  size 200, 200
  @html     = ""   # String to hold data from request
  @counter  = 0    # Counter to animate rectangle across window
  @back     = 255  # Background brightness

  # Create and make an asynchronous request using
  # the Request object from the library
  @request = HTMLRequest.new(self, "http://www.yahoo.com")
  @request.makeRequest
  @timer = Timer.new(5000)
  @timer.start
  background 0
end

def draw
  background @back

  # A request is made every 5s. 
  # The data is not received here, however, this is only the request.  
  if @timer.finished?
    @request.make_request
    # XXX: was println("Making request!");
    puts "Making request!" 
    @timer.start
  end

  # XXX: There are still issues related to events from imported library
  #      so we call the net_event method ourselves
  # When a request is finished the data the available flag is set to true 
  # and we get a chance to read the data returned by the request
  if @request.available?
    net_event(@request)
  end

  # Draw some lines with colors based on characters from data retrieved
  width.times do |i|
    if i < @html.length
      c = @html[i]
      stroke c, 150
      line i, 0, i, height
    end
  end

  # Animate rectangle and dim rectangle
  fill 255
  noStroke
  rect @counter, 0, 10, height
  @counter = (@counter + 1) % width
  @back    = constrain(@back - 1, 0, 255)
end

# When a request is finished the data is received in the netEvent() 
# function which is automatically called whenever data is ready.
def net_event(ml) 
  @html = ml.readRawSource      # Read the raw data
  @back = 255                   # Reset background
  puts "Request completed!"     # Print message 
end

#
# Timer Class from Chapter 10
#
class Timer
  def initialize(total_time)
    @total_time = total_time
    @running    = false
  end

  def start
    @running    = true
    @saved_time = $app.millis
  end

  def finished?
    finished = $app.millis - @saved_time > @total_time      
    if @running && finished
      @running = false
      return true
    else
      return false
    end
  end
end
