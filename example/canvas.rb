require 'bin'

# To run the example make sure the bin project is in the load_path
# you can run it from the project root like:
# ruby -Ilib example/canvas.rb
class Canvas

  attr_reader :store

  def initialize(width, height, options = {})
    @store = options[:store]
    @store ||= begin
      builder = options.delete(:store_builder) 
      builder ||= ->(width, height, opts) { Bin::Grid.new(width, height, opts) }
      builder.call(width, height, options)
    end
  end

  def draw_rectangle(x_range, y_range, value = nil)
    Bin::Rectangle.new(x_range, y_range, value).tap do |rect|
      store.insert rect
    end
  end

  def drawings(x_range = 0..store.width, y_range = 0..store.height)
    store.query Bin::Rectangle.new(x_range, y_range)
  end

  def erase_drawing(drawing)
    store.delete(drawing)
  end

  def empty?
    drawings.empty?
  end
end

puts "It's time to paint!"
puts 

# grab a new canvas
canvas = Canvas.new(640, 480)

canvas.draw_rectangle(  0..320,   0..240, :blue)
canvas.draw_rectangle(321..640,   0..240, :red)
canvas.draw_rectangle(  0..320, 241..480, :yellow)
canvas.draw_rectangle(321..640, 241..480, :green)

canvas.draw_rectangle(100..540, 100..380, :black)

puts <<CANVAS
  Canvas: 640 x 480

  5 rectangles
  _________________
  |Yellow | Green |
  |    ___|___    |
  |___|_Black_|___|
  |   |___|___|   |
  | Blue  | Red   |
  |_______|_______|

CANVAS

puts "Colors in the center:"
canvas.drawings(320..321, 240..241).each do |rectangle|
  puts "- #{rectangle.value}"
end
puts 

puts "Colors in the right half:"
canvas.drawings(321..640, 0..480).each do |rectangle|
  puts "- #{rectangle.value}"
end
puts 

puts "Colors in the top half:"
canvas.drawings(0..640, 241..480).each do |rectangle|
  puts "- #{rectangle.value}"
end
puts 

puts "Cleanining up the canvas..."
canvas.drawings.each do |rectangle|
  canvas.erase_drawing(rectangle)
end
puts 

puts "Now the canvas is empty!" if canvas.empty?