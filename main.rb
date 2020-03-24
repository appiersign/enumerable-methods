module Enumerable
  def my_each
    if self.class == Range
      arr = to_a
      arr.length.times { |x| yield(arr[x]) }
    elsif self.class == Hash
      hash_keys = keys
      length.times { |x| yield(self[hash_keys[x]]) }
    else
      length.times { |x| yield(self[x]) }
    end
  end

  def my_each_with_index
    if is_a? Range
      arr = to_a
      arr.length.times { |x| yield(x, arr[x]) }
    elsif self.class == Hash
      hash_keys = keys
      length.times { |x| yield(hash_keys[x], self[hash_keys[x]]) }
    else
      length.times { |x| yield(x, self[x]) }
    end
  end
end

# [1, 2].my_each_with_index { |x, y| puts "#{x}, #{y}" }
# [1, 2, 4].my_each_with_index { |a, b| puts"(#{a}, #{b})" }
(1...5).to_a.my_each_with_index { |x, y| puts "#{x} => #{y}" }