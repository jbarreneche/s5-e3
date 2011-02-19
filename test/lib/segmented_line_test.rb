require_relative '../test_helper'

require 'segmented_line'

class SegmentedLineTest < MiniTest::Unit::TestCase

  def setup
    @line = SegmentedLine.new(100, 10) {|min, max| [min, max]}
  end

  def test_segment_count
    assert 10, @line.segments_count
  end
  
  def test_selecting_segments
    expected = @line.segments[1..3]
    assert_equal expected, @line[15..35]
  end

end