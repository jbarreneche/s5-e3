class Plane

  attr_reader :store

  def initialize(store = Plane::BinStore.new)
    @store = store
  end

end