require_relative '../test_helper'
require 'minitest/benchmark'
require 'plane/bin_store'

#
# http://en.wikipedia.org/wiki/Bin_(computational_geometry)
#
class BinStorePerformance < MiniTest::Unit::TestCase

  def self.bench_range
    bench_exp 10, 10_000, 2
  end

  def setup
    @vertical_bin = Plane::BinStore.new(
      :size     => "10x100_000",
      :bin_size => "10x10"
    )
  end

  # inserting a candidate into 1 bin is constant time. 
  def test_insert_is_constant
    assert_performance_constant 0.9 do |n|
      concentrated_bin(n)
    end
  end 
  
  # Insertion is linear to the number of bins a candidate intersects because 
  def test_insertion_linear_to_number_of_candidates
    assert_performance_linear 0.9 do |n|
      @vertical_bin.store Rectangle.new(0, n, 0, 9)
    end
  end

  # Then query is O(n), where n is the number of candidates.
  def test_query_linear_to_number_of_candidates_in_bin
    assert_performance_linear 0.9 do |n|
      concentrated_bin(n).query Rectangle.new(0, 9, 0, 9)
    end
  end 

  # delete is O(n), where n is the number of candidates.
  # def test_deletion_linear_to_number_of_candidates_in_bin
  #   assert_performance_linear do |n|
  #     concentrated_bin(n).delete @last_rectangle
  #   end
  # end

  def concentrated_bin(number_of_bins)
    bin = Plane::BinStore.new(
      :size     => "20x20",
      :bin_size => "10x10"
    )
    number_of_bins.times do
      @last_rectangle = Rectangle.new(0, 9, 0, 9)
      bin.store @last_rectangle
    end
    bin
  end

end