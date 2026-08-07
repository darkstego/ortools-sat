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

    # Combines duplicate variables by summing their coefficients and drops any
    # term whose coefficient is zero; the constant is preserved. Returns a new,
    # equivalent expression in which each variable appears at most once. This
    # keeps expressions like `x + x` from emitting a proto with repeated
    # variable references.
    def normalize : LinearExpression
      merged = {} of Int32 => Int64
      @variables.each_with_index do |var, i|
        merged[var] = (merged[var]? || 0_i64) + @coefficients[i]
      end
      vars = [] of Int32
      coeffs = [] of Int64
      merged.each do |var, coeff|
        next if coeff.zero?
        vars << var
        coeffs << coeff
      end
      LinearExpression.new(vars, coeffs, @constant)
    end

    def proto
      norm = normalize
      LinearExpressionProto.new(vars: norm.variables, coeffs: norm.coefficients, offset: norm.constant)
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
