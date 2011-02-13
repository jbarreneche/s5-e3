class Rectangle
  attr_reader :top, :bottom, :left, :right
  def initialize(bottom, top, left, right)
    @top    = top
    @bottom = bottom
    @left   = left
    @right  = right
  end
  def intersects?(rectangle)
    self.right  >= rectangle.left &&
    self.left   <= rectangle.right &&
    self.top    >= rectangle.bottom &&
    self.bottom <= rectangle.top
  end
end