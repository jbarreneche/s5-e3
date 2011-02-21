require_relative '../../test_helper'

require 'bin/rectangle'

class RectangleTest < MiniTest::Unit::TestCase

  def setup
    @rectangle = Bin::Rectangle.new(5..25, 10..20)
  end

  def test_left
    assert_equal 5, @rectangle.left
  end

  def test_right
    assert_equal 25, @rectangle.right
  end

  def test_top
    assert_equal 20, @rectangle.top
  end

  def test_bottom
    assert_equal 10, @rectangle.bottom
  end

  def test_no_intersection_above
    new_rectangle = Bin::Rectangle.new(5..25, 25..30)
    refute @rectangle.intersects? new_rectangle
  end

  def test_no_intersection_right
    new_rectangle = Bin::Rectangle.new(26..35, 10..20)
    refute @rectangle.intersects? new_rectangle
  end

  def test_intersect_right_border
    new_rectangle = Bin::Rectangle.new(25..30, 11..19)
    assert @rectangle.intersects? new_rectangle
  end

  def test_intersect_top_border
    new_rectangle = Bin::Rectangle.new(6..24, 20..29)
    assert @rectangle.intersects? new_rectangle
  end

  def test_auto_intersects
    assert @rectangle.intersects?(@rectangle)
  end

  def test_validates_build_range
    assert_raises(ArgumentError) do
      Bin::Rectangle.new 4..10, 15..11
    end
  end

end