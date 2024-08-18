require "./aliases"
require "./linear-constraint"

module ORTools::Sat
  # LinearExpression class provides an expression of variables and fixed coefficients
  # The expression is used as input to constraints that accept linear expressions
  class LinearExpression
    getter variables : Array(Int32)
    getter coefficients : Array(Int64)
    getter constant : Int64

    def initialize(@variables=[] of Int32,@coefficients=[] of Int64,@constant=0_i64)
    end

    # Needed to allow *sum* of an array of LinearExpression
    def self.zero
      new
    end

    def proto
      LinearExpressionProto.new(vars: @variables, coeffs: @coefficients, offset: @constant)
    end

    def +(other : Expressible)
      other = other.to_lexpr
      LinearExpression.new(@variables + other.variables, @coefficients + other.coefficients, @constant + other.constant)
    end

    def -
      LinearExpression.new(@variables, @coefficients.map { |x| -x }, -@constant)
    end
    
    def -(other : Expressible)
      other = other.to_lexpr
      LinearExpression.new(@variables + other.variables, @coefficients + other.coefficients.map { |x| -x }, @constant - other.constant)
    end

    def to_lexpr : LinearExpression
      self
    end

    def <=(other : Expressible)
      LinearConstraint.less_or_equal(self, other.to_lexpr)
    end

    def <(other : Expressible)
      LinearConstraint.less_than(self, other.to_lexpr)
    end

    def >=(other : Expressible)
      LinearConstraint.greater_or_equal(self, other.to_lexpr)
    end

    def >(other : Expressible)
      LinearConstraint.greater_than(self, other.to_lexpr)
    end

    def ==(other : Expressible)
      LinearConstraint.equal(self, other.to_lexpr)
    end

    def !=(other : Expressible)
      LinearConstraint.not_equal(self, other.to_lexpr)
    end
  end
end
