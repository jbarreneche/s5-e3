require_relative '../test_helper'

require 'canvas'

class CanvasTest < MiniTest::Unit::TestCase
  def setup
    @canvas = Canvas.new(640, 480)
  end
  
  def test_plane_starts_empty
    assert @canvas.empty?
  end
  
  def test_plane_draws_rectangles
    rectangle = @canvas.draw_rectangle(0..10, 20..30)

    refute @canvas.empty?
    assert_equal [rectangle], @canvas.drawings
  end
  
  def test_removing_rectangles
    rectangle = @canvas.draw_rectangle(0..10, 20..30)
    @canvas.erase_drawing(rectangle)

    assert @canvas.empty?
  end
end