module Plane
  class BinStore
    attr_reader :width, :height
    def initialize(opts = {})
      @width,     @height     = split_size(opts[:size], opts[:width], opts[:height])
      @bin_width, @bin_height = split_size(opts[:bin_size], opts[:bin_width], opts[:bin_height])
      @bins = build_bins
    end
    def bin_count
      @bins.size * @bins.first.size
    end
    def store(rectangle)
      (rectangle.left/@bin_width..rectangle.right/@bin_width).each do |i|
        (rectangle.bottom/@bin_height..rectangle.top/@bin_height).each do |j|
          @bins[i][j].push(rectangle)
        end
      end
    end
    def query(query_rectangle)
      top, bottom = query_rectangle.top, query_rectangle.bottom
      left, right = query_rectangle.left, query_rectangle.right
      (left/@bin_width..right/@bin_width).collect_concat do |i|
        (bottom/@bin_height..top/@bin_height).collect_concat do |j|
          @bins[i][j].rectangles.select do |rectangle| 
            query_rectangle.intersects?(rectangle)
          end
        end
      end.uniq
    end
  private
    def build_bins
      horiz_number_of_bins = (@width / @bin_width.to_f).ceil
      vert_number_of_bins = (@height / @bin_height.to_f).ceil
      Array.new(horiz_number_of_bins) do
        Array.new(vert_number_of_bins) { Bin.new }
      end
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