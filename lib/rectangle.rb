class Rectangle
  attr_reader :x_range, :y_range

  class << self

    NOT_RANGE_MESSAGE = "Expected %{obj} to be a range"
    NOT_INCREASING_RANGE = "Should be an increasing range: %{obj} (ie. min <= max)"

    def validate_ranges(*ranges)
      ranges.each do |range|
        raise NOT_RANGE_MESSAGE % {obj: range} unless range?(range)
        raise NOT_RANGE_MESSAGE % {obj: range} unless increasing_range?(range)
      end
    end
    
    def range?(obj)
      obj.respond_to?(:max) && obj.respond_to?(:min) 
    end

    def increasing_range?(obj)
      obj.min <= obj.max 
    end

  end
  
  def initialize(x_range, y_range)
    self.class.validate_ranges(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
  end

  def intersects?(rectangle)
    self.right  >= rectangle.left &&
    self.left   <= rectangle.right &&
    self.top    >= rectangle.bottom &&
    self.bottom <= rectangle.top
  end

  def top
    self.y_range.max
  end
  
  def bottom
    self.y_range.min
  end

  def left
    self.x_range.min
  end
  
  def right
    self.x_range.max
  end

end