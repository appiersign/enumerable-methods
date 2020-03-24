module Enumerable
  def self.my_each(array)
    for x in array do
      yield(x)
    end
  end

  def self.my_each_with_index(array)
    for x in (0...array.length) do
      yield(x, array[x])
    end
  end
end

# Enumerable.my_each([1, 2, 4]) { |a| puts a }
Enumerable.my_each_with_index([1, 2, 4]) { |a, b| puts(a, b) }