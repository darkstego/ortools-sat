require "./cp_model.pb"

# TODO: Write documentation for `Ortools::Sat`
module ORTools::Sat
  VERSION = "0.1.0"

  class IntVar
    getter index : Int32
    def initialize(@index)
    end

    def to_le
      LinearExpression.new(self)
    end
  end

  class BoolVar < IntVar
  end

  class LinearExpression
    @variables : Array(Int32)
    @coefficients : Array(Int64)
    @constant : Int64

    def initialize(@variables,@coefficients,@constant=0_i64)
    end

    # Turn IntVar into LinearExpression
    def initialize(int_var : IntVar)
      initialize([int_var.index], [1_i64])
    end

    def to_proto
      LinearExpressionProto.new(vars: @variables, coeffs: @coefficients, offset: @constant)
    end

  end

  class Model

    def initialize
      @proto = CpModelProto.new(variables: [] of IntegerVariableProto,
                                constraints: [] of ConstraintProto)
    end

    def new_int_var(min : Int64, max : Int64, name="")
      variables = @proto.variables.not_nil!
      index = variables.size
      variables.push(IntegerVariableProto.new(name: name, domain: [min, max]))
      IntVar.new(index)
    end

    def new_bool_var(name="")
      variables = @proto.variables.not_nil!
      index = variables.size
      variables.push(IntegerVariableProto.new(name: name, domain: [0_i64, 1_i64]))
      BoolVar.new(index)
    end

    def add_not_equal(x : LinearExpression, y : LinearExpression)
      constraint_proto = ConstraintProto.new(all_diff: AllDifferentConstraintProto.new(exprs: [x.to_proto, y.to_proto]))
      @proto.constraints.try &.push(constraint_proto)
    end

  end
end

model = ORTools::Sat::Model.new
x = model.new_int_var(0, 2, "x")
y = model.new_int_var(0, 2, "y")
z = model.new_int_var(0, 2, "z")
model.add_not_equal(x.to_le, y.to_le)
