module Enumerable
  def self.my_each(array)
    for x in array do
      yield(x)
    end
  end
end

Enumerable.my_each([1, 2, 4]) { |a| puts a }