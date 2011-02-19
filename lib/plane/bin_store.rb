require 'set'
require_relative '../segmented_line'

module Plane
  class BinStore

    attr_reader :width, :height

    def initialize(width, height, options = {})
      @width,     @height     = width, height

      if options[:segmentation]
        x_segment_count = y_segment_count = options[:segmentation]
      else
        x_segment_count,  y_segment_count = segmentation_from_bin_size(options)
      end
      
      @grid = SegmentedLine.new(@width, x_segment_count) do
                SegmentedLine.new(@height, y_segment_count) { Bin.new }
              end
    end

    def bin_count
      grid.size * grid.segments.first.size
    end

    def store(rectangle)
      grid.select_in_range(rectangle.x_range).each do |line|
        line.select_in_range(rectangle.y_range).each do |bin|
          bin.push(rectangle)
        end
      end
    end

    def query(query)
      results = Set.new

      grid.select_in_range(query.x_range).each do |line|
        line.select_in_range(query.y_range).each do |bin|
          bin.rectangles.each do |rectangle| 
            results << rectangle if query.intersects?(rectangle)
          end
        end
      end
      
      results.to_a
    end

  private

    def grid
      @grid
    end

    def split_size(size)
      size.split('x').map(&:to_f)
    end

    def segmentation_from_bin_size(options)
      bin_size = options[:bin_size]

      bin_width, bin_height = split_size(bin_size) if bin_size
      bin_width  ||= options[:bin_width] || (width / 100)
      bin_height ||= options[:bin_height] || (height / 100)
      
      [(width / bin_width).ceil, (height / bin_height).ceil]
    end

  end

  class Bin

    attr_reader :rectangles

    def initialize
      @rectangles = []
    end

    def push(rectangle)
      @rectangles << rectangle
    end

    def remove(rectangle)
      @rectangles.delete(rectangle)
    end

  end
end