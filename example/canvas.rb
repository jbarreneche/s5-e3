require 'bin'

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