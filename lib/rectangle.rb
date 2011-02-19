class Rectangle
  attr_reader :x_range, :y_range, :value

  class << self

    ERRORS = {
      :not_a_range    => "Expected %{arg} to be a range",
      :not_increasing => "Expected %{arg} to have a min and a max"
    }

    def validate_ranges(*ranges)
      ranges.each do |range|
        invalid_arg(range, :not_a_range)    unless range?(range)
        invalid_arg(range, :not_increasing) unless increasing_range?(range)
      end
    end

    def range?(obj)
      obj.respond_to?(:max) && obj.respond_to?(:min) 
    end

    def increasing_range?(obj)
      obj.min && obj.max
    end
    
    def invalid_arg(arg, message)
      raise ArgumentError, ERRORS[message] % {:arg => arg} 
    end

  end
  
  def initialize(x_range, y_range, value = nil)
    self.class.validate_ranges(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
    @value   = value
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