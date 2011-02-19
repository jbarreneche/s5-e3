class SegmentedLine

  attr_reader :segments

  def initialize(total_width, segment_width)
    @segment_width = segment_width.to_f
    size           = (total_width / segment_width).ceil
    @segments      = Array.new(size) { yield }
  end

  def select_in_range(range)
    lower  = map_lower_bound(range.min)
    higher = map_higher_bound(range.max)
    segments[lower..higher]
  end

  def size
    segments.size
  end

private 

  def segment_width
    @segment_width
  end
  
  def map_lower_bound(bound)
    return 0 unless bound > 0
    (bound / segment_width).ceil - 1
  end

  def map_higher_bound(bound)
    return -1 unless bound < max_bound
    (bound / segment_width).ceil - 1
  end

  def max_bound
    segment_width * (segments.size - 1)
  end

end