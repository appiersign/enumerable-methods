module Enumerable
  def self.my_each(array)
    for x in (0...array.length) do
      yield(array[x])
    end
  end
end

Enumerable.my_each([1, 2, 4]) { |a| puts a }