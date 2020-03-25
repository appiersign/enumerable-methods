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

  def my_all?
    array = []
    my_select { |x| array << x if yield(x) }
    array.length == length
  end

  def my_any?
    if block_given?
      my_each { |x| true if yield(x) }
      false
    end
    true
  end

  def my_none?
    array = []
    my_select { |x| array << x unless yield(x) }
    array.length == length
  end

  def my_count
    my_select { |x| x if yield(x) } .length
  end

  def my_map
    my_each_with_index { |x, y| self[x] = yield(y) }
    self
  end
end