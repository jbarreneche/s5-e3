require 'set'
require_relative '../segmented_line'

module Plane
  class BinStore

    attr_reader :width, :height

    def initialize(opts = {})
      @width,     @height     = split_size(opts[:size], opts[:width], opts[:height])
      @bin_width, @bin_height = split_size(opts[:bin_size], opts[:bin_width], opts[:bin_height])
      @grid = SegmentedLine.new(@width, @bin_width) do
                SegmentedLine.new(@height, @bin_height) { Bin.new }
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

    def split_size(size, width, height)
      values = size ? size.split('x') : [width, height]
      values.map(&:to_i)
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