module Enumerable
  def my_each
    if block_given?
      length.times { |x| yield(self[x]) }
    elsif self.class == Range
      arr = to_a
      arr.length.times { |x| yield(arr[x]) }
    elsif self.class == Hash
      hash_keys = keys
      length.times { |x| yield(self[hash_keys[x]]) }
    else
      return to_enum(:my_each)
    end
    self
  end

  def my_each_with_index
    if block_given?
      length.times { |x| yield(self[x], x) }
    elsif is_a? Range
      arr = to_a
      arr.length.times { |x| yield(arr[x], x) }
    elsif self.class == Hash
      hash_keys = keys
      length.times { |x| yield(self[hash_keys[x], hash_keys[x]]) }
    else
      return to_enum(:my_each_with_index)
    end
    self
  end

  def my_select
    if block_given?
      array = []
      my_each { |x| array << x if yield(x) }
    else
      return to_enum(:my_select)
    end
    array
  end

  def my_all?(arg = nil)
    if block_given?
      my_each { |x| return false if yield(x) == false }
    elsif arg.is_a?(Module)
      my_each { |x| return false if x.is_a?(arg) == false }
    elsif arg.is_a?(Regexp)
      my_each { |x| return false if x.match(arg) == false }
    elsif arg && !arg.is_a?(Module) && !arg.is_a?(Regexp)
      my_each { |x| return false if x != arg }
    else
      my_each { |x| return false unless x }
    end
    true
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

  def my_inject(initial)
    each do |i|
      if initial.nil?
        initial = i
      elsif initial.class == Range
        count = 0
        while count < length
          initial += self[count]
          count += 1
        end
      else
        initial = yield(initial, i)
      end
    end
    initial
  end

  def multiply_els(array)
    array.my_inject(1) { |p, x| p * x }
  end
end

p [1, true, 'hi', false].my_all?
p [1,1,1].my_all?(Integer)
p ['d','d'].my_all?(/d/)
p [3,3,3,3].my_all?(3)