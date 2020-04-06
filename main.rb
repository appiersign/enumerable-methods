module Enumerable
  def my_each
    to_enum(:my_each) unless block_given?
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
  end

  def my_each_with_index
    to_enum(:my_each_with_index) unless block_given?
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
  end

  def my_select
    to_enum(:my_select) unless block_given?
    array = []
    my_each { |x| array << x if yield(x) }
    array
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

  def my_any?(arg = nil)
    any = false
    if arg.nil? && block_given?
      my_each { |obj| any = true if yield(obj) }
    elsif arg.is_a?(Module)
      my_each { |obj| any = true if obj.is_a?(arg) }
    elsif arg.is_a?(Regexp)
      my_each { |obj| any = true if obj.match(arg) }
    else
      my_each { |obj| any = true if obj }
    end
    any
  end

  def my_none?(arg = nil)
    if arg.nil? && block_given?
      my_each { |x| return false if yield(x) == true }
    elsif arg.is_a?(Regexp)
      my_each { |x| return false if x.match(arg) }
    elsif arg.is_a?(Module)
      my_each { |x| return false if x.is_a?(arg) }
    else
      my_each { |x| return false if x == arg }
    end
  end

  def my_count(arg = nil)
    if arg.nil? && block_given?
      my_select { |x| x if yield(x) }.length
    elsif arg
      my_select { |x| x if x == arg }.length
    else
      length
    end
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