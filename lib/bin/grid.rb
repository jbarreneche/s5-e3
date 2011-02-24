require 'set'
require_relative 'segmented_line'

module Bin
  class Grid

    attr_reader :width, :height

    def initialize(width, height, options = {})
      @width, @height = width, height
      @grid  = build_grid(options)
    end

    def insert(rectangle)
      each_bin_in(rectangle) do |bin|
        bin << rectangle
      end

      self
    end

    def query(query)
      results = Set.new

      each_bin_in(query) do |bin|
        bin.rectangles.each do |rectangle| 
          results << rectangle if query.intersects?(rectangle)
        end
      end

      results.to_a
    end

    def delete(rectangle)
      each_bin_in(rectangle) do |bin|
        bin.delete(rectangle)
      end
    end

    private

    def each_bin_in(rectangle)
      return enum_for(:each_bin_in, rectangle) unless block_given?

      @grid[rectangle.x_range].each do |line|
        line[rectangle.y_range].each {|bin| yield(bin) }
      end
    end

    def split_size(size)
      size.split('x').map(&:to_f)
    end

    def segment_counts(options)
      if options[:segmentation]

        [options[:segmentation], options[:segmentation]]

      else
        bin_size = options[:bin_size]

        bin_width, bin_height = split_size(bin_size) if bin_size
        bin_width  ||= options[:bin_width]  || (width / 100)
        bin_height ||= options[:bin_height] || (height / 100)

        [(width / bin_width).ceil, (height / bin_height).ceil]
      end
    end

    def build_grid(options)
      x_segment_count, y_segment_count = segment_counts(options)

      SegmentedLine.new(width, x_segment_count) do
        SegmentedLine.new(height, y_segment_count) do
           Bin.new
         end
      end
    end

    class Bin

      attr_reader :rectangles

      def initialize
        @rectangles = []
      end

      def <<(rectangle)
        @rectangles << rectangle
        self
      end

      alias :push :<<

      def delete(rectangle)
        @rectangles.delete(rectangle)
      end

    end

  end
  
end
