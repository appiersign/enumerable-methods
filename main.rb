# rubocop: disable Metrics/ModuleLength
# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

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
    elsif is_a?(Range)
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
    return to_enum(:my_select) unless block_given?

    array = []
    my_each { |x| array << x if yield(x) }
    array
  end

  def my_all?(arg = nil)
    if block_given?
      my_each { |x| return false if yield(x) == false }
    elsif arg.is_a?(Module)
      my_each { |x| return false if x.is_a?(arg) == false }
    elsif arg.is_a?(Regexp)
      my_each { |x| return false unless x.match(arg) }
    elsif arg && !arg.is_a?(Module) && !arg.is_a?(Regexp)
      my_each { |x| return false if x != arg }
    else
      my_each { |x| return false unless x }
    end
    true
  end

  def my_any?(arg = nil)
    any = false
    if block_given?
      my_each { |x| return true if yield(x) == true }
    elsif arg.is_a?(Module)
      my_each { |x| return true if x.is_a?(arg) }
    elsif arg.is_a?(Regexp)
      my_each { |x| return true if x.match(arg) }
    elsif arg && !arg.is_a?(Module) && !arg.is_a?(Regexp)
      my_each { |x| return true if x == arg }
    else
      my_each { |x| any = true if x }
    end
    any
  end

  def my_none?(arg = nil)
    none = true
    if block_given?
      my_each { |x| return false if yield(x) == true }
    elsif arg.is_a?(Module)
      my_each { |x| return false if x.is_a?(arg) }
    elsif arg.is_a?(Regexp)
      my_each { |x| return false if x.match(arg) }
    elsif arg && !arg.is_a?(Module) && !arg.is_a?(Regexp)
      my_each { |x| return false if x == arg }
    else
      my_each { |x| return false if x }
    end
    none
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
    return to_enum(:my_map) unless block_given?

    array = []
    proc ? my_each { |x| array << proc.call(x) } : my_each { |x| array << yield(x) }
    array
  end

  def my_inject(initial = nil, symbol = nil)
    arr = is_a?(Array) ? self : to_a
    sym = initial if initial.is_a?(Symbol) || initial.is_a?(String)
    acc = initial.is_a?(Integer) ? initial : arr[0]
    arr.shift unless initial.is_a?(Integer)

    if initial.is_a?(Integer)
      sym = symbol if symbol.is_a?(Symbol) || symbol.is_a?(String)
    end

    if sym
      arr.my_each { |x| acc = acc.__send__(sym, x) }
    elsif block_given?
      arr.my_each { |x| acc = yield(acc, x) }
    end
    acc
  end

  def multiply_els(array)
    array.my_inject(1) { |p, x| p * x }
  end
end

# rubocop: enable Metrics/ModuleLength
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
