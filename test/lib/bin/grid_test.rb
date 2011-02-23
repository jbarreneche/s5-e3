require_relative '../../test_helper'

require 'bin/grid'

class GridTest < MiniTest::Unit::TestCase

  def setup
    @bin = Bin::Grid.new(200, 300, :bin_size => "10x10")
  end

  def test_store_width
    assert_equal 200, @bin.width
  end

  def test_store_height
    assert_equal 300, @bin.height
  end

  def test_store_one_rectangle
    one_rectangle = Bin::Rectangle.new(0..20, 0..20)
    @bin.insert one_rectangle

    query_results = @bin.query Bin::Rectangle.new(0..10, 0..10)
    assert_equal [one_rectangle], query_results
  end

  def test_store_multiple_rectangles

    rectangle_one = Bin::Rectangle.new(0..20, 0..20)
    rectangle_two = Bin::Rectangle.new(20..40, 20..40)
    @bin.insert rectangle_one
    @bin.insert rectangle_two

    query_results = @bin.query Bin::Rectangle.new(0..10, 0..10)
    assert_equal [rectangle_one], query_results

    query_results = @bin.query Bin::Rectangle.new(30..40, 30..40)
    assert_equal [rectangle_two], query_results

    query_results = @bin.query Bin::Rectangle.new(20..20, 20..20)
    assert_equal [rectangle_one, rectangle_two], query_results
  end

end