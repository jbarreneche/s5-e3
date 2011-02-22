require_relative '../../test_helper'

require 'bin/grid'

#
# http://en.wikipedia.org/wiki/Bin_(computational_geometry)
#
class GridPerformanceTest < MiniTest::Unit::TestCase

  def self.bench_range
    bench_exp 10, 100_000
  end

  def setup
    @vertical_bin = Bin::Grid.new(10, 1000_000, :bin_size => "10x10")
  end

  # inserting a candidate into 1 bin is constant time. 
  def test_insert_is_constant
    assert_performance_constant 0.999 do |n|
      concentrated_bin(n)
    end
  end 
  
  # Insertion is linear to the number of bins a candidate intersects because 
  def test_insertion_linear_to_number_of_candidates
    assert_performance_linear 0.99 do |n|
      @vertical_bin.insert Bin::Rectangle.new(0..9, 0..n)
    end
  end

  # Then query is O(n), where n is the number of candidates.
  def test_query_linear_to_number_of_candidates_in_bin
    assert_performance_linear 0.999 do |n|
      concentrated_bin(n).query Bin::Rectangle.new(0..9, 0..9)
    end
  end

  # delete is O(n), where n is the number of candidates.
  def test_deletion_linear_to_number_of_candidates_in_bin
    assert_performance_linear 0.999 do |n|
      concentrated_bin(n).delete @last_rectangle
    end
  end

  def concentrated_bin(number_of_bins)
    bin = Bin::Grid.new(20, 20, :bin_size => "10x10")

    number_of_bins.times do
      @last_rectangle = Bin::Rectangle.new(0..9, 0..9)
      bin.insert @last_rectangle
    end

    bin
  end

end