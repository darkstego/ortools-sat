require "./aliases"
require "./linear-expression"

module ORTools::Sat

  # The base variable used in Constraing Programming (CP) problems.
  #
  # This variable should not be instantiated directly, but created with `Model#new_int_var`
  class IntVar
    getter index : Int32
    def initialize(@index)
    end

    # Required to allow Array#sum of IntVar variables
    # to be summed into a LinearExpression
    def self.zero
      LinearExpression.new
    end

    # Negative index -1 is used to represent the negation of a variable in the model
    # In the Case of IntVar, this will mean the negative of the variable
    # In the case of BoolVar, this will mean the logical NOT of the variable
    # These are used to simplify model constraints and for model efficiency
    def - : self
      self.class.new( -@index - 1)
    end

    # Macro to create methods for all operators
    {% for op in %w(+ - <= < >= > == !=) %}
      def {{op.id}}(other : Expressible)
        to_lexpr {{op.id}} other
      end
    {% end %}

    def to_lexpr : LinearExpression
      # A negative index encodes the negation of a variable (see #-).
      # In a linear expression OR-Tools requires a real, non-negative
      # variable index, so the negation must be carried by a -1
      # coefficient rather than by the index itself. For an IntVar the
      # negation is arithmetic (-x), matching ValidSolution#value(IntVar).
      if @index >= 0
        LinearExpression.new([@index], [1_i64])
      else
        LinearExpression.new([-@index - 1], [-1_i64])
      end
    end
  end

  # A subclass of IntVar for Booleans where 0 is false and 1 is true
  class BoolVar < IntVar
    def ~ : self
      -self
    end

    def not : self
      -self
    end

    # For a BoolVar a negative index is the logical NOT, i.e. (1 - x),
    # matching ValidSolution#value(BoolVar).
    def to_lexpr : LinearExpression
      if @index >= 0
        LinearExpression.new([@index], [1_i64])
      else
        LinearExpression.new([-@index - 1], [-1_i64], 1_i64)
      end
    end
  end

  # Methods added to the Int class to make building constraints easier
  struct ::Int
    def to_lexpr : ORTools::Sat::LinearExpression
      ORTools::Sat::LinearExpression.new(constant: self)
    end

    def *(other : (ORTools::Sat::IntVar|ORTools::Sat::LinearExpression)) : ORTools::Sat::LinearExpression
      other = other.to_lexpr
      ORTools::Sat::LinearExpression.new(other.variables, other.coefficients.map { |x| x * self }, other.constant * self)
    end

    # Macro to create methods for all operators
    {% for op in %w(+ - <= < >= > == !=) %}
      def {{op.id}}(other : (ORTools::Sat::IntVar|ORTools::Sat::LinearExpression))
        to_lexpr {{op.id}} other
      end
    {% end %}
  end

end
