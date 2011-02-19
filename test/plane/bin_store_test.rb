require_relative '../test_helper'
require 'plane/bin_store'

class BinStoreTest < MiniTest::Unit::TestCase
  def setup
    @bin = Plane::BinStore.new(
      :size => "200x300",
      :bin_size => "10x10"
    )
  end

  def test_store_width
    assert_equal 200, @bin.width
  end

  def test_store_height
    assert_equal 300, @bin.height
  end

  def test_number_of_bins
    assert_equal 600, @bin.bin_count
  end

  def test_store_one_rectangle
    one_rectangle = Rectangle.new(0..20, 0..20)
    @bin.store one_rectangle

    query_results = @bin.query Rectangle.new(0..10, 0..10)
    assert_equal [one_rectangle], query_results
  end

  def test_store_multiple_rectangles

    rectangle_one = Rectangle.new(0..20, 0..20)
    rectangle_two = Rectangle.new(20..40, 20..40)
    @bin.store rectangle_one
    @bin.store rectangle_two

    query_results = @bin.query Rectangle.new(0..10, 0..10)
    assert_equal [rectangle_one], query_results

    query_results = @bin.query Rectangle.new(30..40, 30..40)
    assert_equal [rectangle_two], query_results

    query_results = @bin.query Rectangle.new(20..20, 20..20)
    assert_equal [rectangle_one, rectangle_two], query_results
  end

end