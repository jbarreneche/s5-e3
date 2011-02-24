module Bin
  class SegmentedLine

    attr_reader :segments

    def initialize(total_width, number_of_segments)
      @segment_width = total_width / number_of_segments.to_f
      @segments      = Array.new(number_of_segments.ceil) { yield }
    end

    def [](range)
      lower  = map_lower_bound(range.min)
      higher = map_higher_bound(range.max)
      segments[lower..higher]
    end

    private

    def map_lower_bound(bound)
      return 0 unless bound > 0
      
      (bound / @segment_width).ceil - 1
    end

    def map_higher_bound(bound)
      return -1 unless bound < max_bound
      
      (bound / @segment_width).ceil - 1
    end

    def max_bound
      @segment_width * (segments.size - 1)
    end

  end
  
end
