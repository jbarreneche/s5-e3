module Bin
  class Rectangle
    ERRORS = {
      :not_a_range    => "Expected %{arg} to be a range",
      :not_increasing => "Expected %{arg} to have a min and a max"
    }

    attr_reader :x_range, :y_range, :value

    def initialize(x_range, y_range, value = nil)
      validate_ranges(x_range, y_range)

      @x_range = x_range
      @y_range = y_range
      @value   = value
    end

    def intersects?(rectangle)
      right  >= rectangle.left &&
      left   <= rectangle.right &&
      top    >= rectangle.bottom &&
      bottom <= rectangle.top
    end

    def top
      y_range.max
    end

    def bottom
      y_range.min
    end

    def left
      x_range.min
    end

    def right
      x_range.max
    end

    private

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
end