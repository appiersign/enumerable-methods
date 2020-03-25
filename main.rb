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

  def my_select
    array = []
    my_each { |x| array << x if yield(x) }
    array
  end

  def my_all
    my_select { |x| x if yield(x) }
  end
end