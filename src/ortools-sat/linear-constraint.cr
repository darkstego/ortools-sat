require "./linear-expression.cr"
require "./connector/cp_model.pb"

module ORTools::Sat

  # Factory Class to generate linear contraints 
  class LinearConstraint
    getter proto : ConstraintProto

    def initialize(@proto)
    end

    def self.less_or_equal(lhs : LinearExpression, rhs : LinearExpression)
      lexpr = lhs - rhs
      # negate the constant to move it to the right side of the equation
      domain = [Int64::MIN, -lexpr.constant]
      new ConstraintProto.new(linear: LinearConstraintProto.new(vars: lexpr.variables, coeffs: lexpr.coefficients, domain: domain))
    end

    def self.less_than(lhs : LinearExpression, rhs : LinearExpression)
      less_or_equal(lhs, rhs - 1)
    end

    def self.greater_or_equal(lhs : LinearExpression, rhs : LinearExpression)
      less_or_equal(rhs, lhs)
    end

    def self.greater_than(lhs : LinearExpression, rhs : LinearExpression)
      less_than(rhs, lhs)
    end

    def self.equal(lhs : LinearExpression, rhs : LinearExpression)
      lexpr = lhs - rhs
      # negate the constant to move it to the right side of the equation
      domain = [-lexpr.constant, -lexpr.constant]
      new ConstraintProto.new(linear: LinearConstraintProto.new(vars: lexpr.variables, coeffs: lexpr.coefficients, domain: domain))
    end

    def self.not_equal(lhs : LinearExpression, rhs : LinearExpression)
      lexpr = lhs - rhs
      # negate the constant to move it to the right side of the equation
      domain = [Int64::MIN, -lexpr.constant - 1, -lexpr.constant + 1, Int64::MAX]
      new ConstraintProto.new(linear: LinearConstraintProto.new(vars: lexpr.variables, coeffs: lexpr.coefficients, domain: domain))
    end
  end

end
