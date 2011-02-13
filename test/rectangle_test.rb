require_relative 'test_helper'

require 'rectangle'

class RectangleTest < MiniTest::Unit::TestCase
  def setup
    @rectangle = Rectangle.new(10, 20, 5, 25)
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
    new_rectangle = Rectangle.new(25, 30, 5, 25)
    refute @rectangle.intersects? new_rectangle
  end
  def test_no_intersection_right
    new_rectangle = Rectangle.new(10, 20, 26, 35)
    refute @rectangle.intersects? new_rectangle
  end
  def test_intersect_right_border
    new_rectangle = Rectangle.new(11, 19, 25, 30)
    assert @rectangle.intersects? new_rectangle
  end
  def test_intersect_top_border
    new_rectangle = Rectangle.new(20, 29, 6, 24)
    assert @rectangle.intersects? new_rectangle
  end
  def test_auto_intersects
    assert @rectangle.intersects?(@rectangle)
  end
end