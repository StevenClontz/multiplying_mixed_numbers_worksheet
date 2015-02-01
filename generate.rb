require 'erb'

class MultiplicationProblem

  attr_reader :first_factor, :second_factor

  def initialize
    first_denominator = rand 4..10
    # roughly half should be proper fractions
    if rand(0...2) == 0
      first_numerator = rand 1...first_denominator
    else
      first_numerator = rand first_denominator...(3*first_denominator)
    end
    second_denominator_max = [2,21/first_denominator].max
    second_denominator = rand 2..second_denominator_max
    second_numerator = rand(7..20)
    # ensure at least one non-integer
    if (first_numerator % first_denominator == 0) && (second_numerator % second_denominator == 0)
      second_numerator += rand(1...second_denominator)
    end
    @first_factor = Rational first_numerator, first_denominator
    @second_factor = Rational second_numerator, second_denominator
    if rand(0...2) == 0
      @first_factor, @second_factor = @second_factor, @first_factor
    end
  end

  def product
    first_factor * second_factor
  end

  def first_mixed_integer
    rational_to_mixed_integer first_factor
  end

  def first_mixed_numerator
    rational_to_mixed_numerator first_factor
  end

  def first_mixed_denominator
    rational_to_mixed_denominator first_factor
  end

  def second_mixed_integer
    rational_to_mixed_integer second_factor
  end

  def second_mixed_numerator
    rational_to_mixed_numerator second_factor
  end

  def second_mixed_denominator
    rational_to_mixed_denominator second_factor
  end

  def product_mixed_integer
    rational_to_mixed_integer product
  end

  def product_mixed_numerator
    rational_to_mixed_numerator product
  end

  def product_mixed_denominator
    rational_to_mixed_denominator product
  end

  def to_s
    first_factor_str = rational_to_mixed_number_string first_factor
    second_factor_str = rational_to_mixed_number_string second_factor
    product_str = rational_to_mixed_number_string product
    "#{first_factor_str} × #{second_factor_str} = #{product_str}"
  end

  def to_latex_s
    str = ''
    if first_mixed_integer > 0
      str << first_mixed_integer.to_s
    end
    if first_mixed_numerator > 0
      str << "\\frac{#{first_mixed_numerator}}{#{first_mixed_denominator}}"
    end
    str << "\\times"
    if second_mixed_integer > 0
      str << second_mixed_integer.to_s
    end
    if second_mixed_numerator > 0
      str << "\\frac{#{second_mixed_numerator}}{#{second_mixed_denominator}}"
    end
    str << "=\\solution{"
    if product_mixed_integer > 0
      str << product_mixed_integer.to_s
    end
    if product_mixed_numerator > 0
      str << "\\frac{#{product_mixed_numerator}}{#{product_mixed_denominator}}"
    end
    str << "}"
  end


  private #---------------

  def rational_to_mixed_integer rational
    rational.floor
  end

  def rational_to_mixed_numerator rational
    rational.numerator % rational.denominator
  end

  def rational_to_mixed_denominator rational
    rational.denominator
  end

  def rational_to_mixed_number_string rational
    int = rational_to_mixed_integer rational
    num = rational_to_mixed_numerator rational
    den = rational_to_mixed_denominator rational
    str = ""
    if int > 0
      str << int.to_s
    end
    if int > 0 and num > 0
      str << " "
    end
    if num > 0
      str << "#{num}/#{den}"
    end
    str
  end
end


template_filename = 'test.tex.erb'
template_file = File.read template_filename
template_erb = ERB.new template_file
File.write 'test.tex', template_erb.result(binding)