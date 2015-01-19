class NumberSet
  include Enumerable

  attr_accessor :numbers_array

  def each(&block)
    @numbers_array.each(&block)
  end

  def initialize
    @numbers_array = []
  end

  def <<(number)
    converted_number = number.to_c
    unless @numbers_array.include?(converted_number)
      @numbers_array << number
    end
  end

  def size
    @numbers_array.size
  end

  def empty?
    @numbers_array.empty?
  end

  def [](filter)
  end
 end

class Filter
  def initialize
   @filter_result =  yield
  end
end

class TypeFilter < NumberSet
  def initialize(argument)
   @type_filter_result = case arg
    when :integer then select { |element| element.is_a? Integer }
    when :real    then select { |element| element.is_a? Real or
                                          element.is_a? Float }
    when :complex then select { |element| element.is_a? Complex }
  end
end
end
class SignFilter < NumberSet
  def initialize(argument)
   @sign_filter_result =  case arg
    when :positive     then select { |element| element > 0 }
    when :non_positive then select { |element| element <= 0 }
    when :negative     then select { |element| element < 0 }
    when :non_negative then select { |element| element >= 0 }
    end
  end
end
