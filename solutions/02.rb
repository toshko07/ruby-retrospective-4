class NumberSet
  include Enumerable

  attr_accessor :numbers_array

  def each(&block)
    @numbers_array.each(&block)
  end

  def initialize(numbers = [])
    @numbers_array = numbers
  end

  def <<(number)
    @numbers_array << number unless @numbers_array.include? number
  end

  def size
    @numbers_array.size
  end

  def empty?
    @numbers_array.empty?
  end

  def [](filter)
    NumberSet.new @numbers_array.select { |number| filter.match? number }
  end

 end

class Filter
  def initialize(&condition)
   @filter_condition =  condition
  end

  def match?(number)
    @filter_condition.call number
  end

  def &(other)
    Filter.new { |number| match? number and other.match? number }
  end

  def |(other)
    Filter.new { |number| match? number or other.match? number }
  end
end

class TypeFilter < Filter
  def initialize(argument)
    case argument
    when :integer then super() { |element| element.is_a? Integer }
    when :complex then super() { |element| element.is_a? Complex }
    else super() { |number| number.is_a? Float or number.is_a? Rational }
    end
  end
end

class SignFilter < Filter
  def initialize(argument)
    case argument
    when :positive     then super() { |element| element > 0 }
    when :non_positive then super() { |element| element <= 0 }
    when :negative     then super() { |element| element < 0 }
    when :non_negative then super() { |element| element >= 0 }
    end
  end
end
