#
# Example 18-9: Using Processing's XML library
#
import "processing.xml"

def setup
  size 200, 200
  smooth
  # Load an XML document
  xml = XMLElement.new(self, "bubbles.xml")

  # Getting the total number of Bubble objects with getChildCount().  
  totalBubbles = xml.get_child_count
  @bubbles = []

  # Get all the child elements
  children = xml.get_children

  children.each do |child|
    # The diameter is child 0
    diameterElement = child.get_child(0)

    # The diameter is the content of the first element while red and green are attributes of the second.
    diameter = diameterElement.get_content.to_i

    # Color is child 1
    colorElement = child.get_child(1)
    r = colorElement.get_int_attribute("red")
    g = colorElement.get_int_attribute("green")

    # Make a new Bubble object with values from XML document
    @bubbles << Bubble.new(r, g, diameter)
  end
end

def draw
  background 255

  # Display and move all bubbles
  @bubbles.each do |bubble|
    bubble.display
    bubble.drift
  end
end

#
# A Bubble class
#
class Bubble
  def initialize(r, g, diameter)
    @x = $app.random($app.width)
    @y = $app.height
    @r = r
    @g = g
    @diameter = diameter
  end

  # XXX: Unused - probably best to remove instead
  # True or False if point is inside circle
  #def rollover(mx, my)
  #  return $app.dist(mx, my, @x, @y) < @diameter / 2
  #end
  
  
  # XXX: Unused - probably best to remove instead
  # Change Bubble variables
  #def change
  #  @r = $app.constrain(@r + $app.random(-10, 10), 0, 255)
  #  @g = $app.constrain(@g + $app.random(-10, 10), 0, 255)
  #  @diameter = $app.constrain(@diameter + $app.random(-2, 4), 4, 72)
  #end

  # Display Bubble
  def display
    $app.stroke 0
    $app.fill @r, @g, 255, 150
    $app.ellipse @x, @y, @diameter, @diameter
  end

  # Bubble drifts upwards
  def drift
    @y += $app.random(-3, -0.1)
    @x += $app.random(-1, 1)
    if @y < -@diameter * 2
      @y = $app.height + @diameter * 2 
    end
  end
end
