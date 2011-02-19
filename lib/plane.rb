class Plane

  attr_reader :store

  def initialize(width, height, options = {})
    @store = options[:store]
    @store ||= begin
      builder = options.delete(:store_builder) 
      builder ||= ->(width, height, opts) { BinStore.new(width, height, opts) }
      builder.call(width, height, options)
    end
  end

end

require_relative 'plane/bin_store'