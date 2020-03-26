module Enumerable
  def my_each
    if block_given?
      if self.class == Range
        arr = to_a
        arr.length.times { |x| yield(arr[x]) }
      elsif self.class == Hash
        hash_keys = keys
        length.times { |x| yield(self[hash_keys[x]]) }
      else
        length.times { |x| yield(self[x]) }
      end
      self
    else
      to_enum(:my_each)
    end
  end

  def my_each_with_index
    if block_given?
      if is_a? Range
        arr = to_a
        arr.length.times { |x| yield(x, arr[x]) }
      elsif self.class == Hash
        hash_keys = keys
        length.times { |x| yield(hash_keys[x], self[hash_keys[x]]) }
      else
        length.times { |x| yield(x, self[x]) }
      end
      self
    else
      to_enum(:my_each_with_index)
    end
  end

  def my_select
    if block_given?
      array = []
      my_each { |x| array << x if yield(x) }
      array
    else
      to_enum(:my_select)
    end
  end

  def my_all?(arg = nil)
    array = []
    if arg
      my_select { |x| array << x if x.to_s.match(arg) and x.is_a? nil == false }
    elsif block_given?
      my_select { |x| array << x if yield(x) and x.is_a? nil == false }
    else
      my_select { |x| array << x }
    end
    array.length == length
  end

  def my_any?
    if block_given?
      my_each { |x| true if yield(x) }
      false
    end
    true
  end

  def my_none?(args = nil)
    array = []
    if args.nil?
      my_select { |x| array << x unless yield(x) }
    else
      my_select { |x| array << x if x.match(args) }
    end
    array.empty?
  end

  def my_count
    my_select { |x| x if yield(x) }.length
  end

  def my_map(proc = nil)
    array = []
    proc ? my_each { |x| array << proc.call(x) } : my_each { |x| array << yield(x) }
    array
  end

  def my_inject(memo = 0)
    my_each { |x| memo = yield(memo, x) }
    memo
  end

  def multiply_els(array)
    array.my_inject(1) { |p, x| p * x }
  end
end

print [1, 2, 3].my_all?(/d/)
puts
print [1, 2, 3].all?(/d/)