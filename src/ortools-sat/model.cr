require "./connector/cp_model.pb"
require "./aliases"
require "./int-var"
require "./solution"


module ORTools::Sat

  @[Link(ldflags: "#{__DIR__}/connector/cp_sat_wrapper.o -lortools -lstdc++ -lprotobuf")]
  lib CPSATWrapper
    fun cp_sat_wrapper_solve(Pointer(UInt8),LibC::SizeT, Pointer(LibC::SizeT)) : Pointer(UInt8)
  end

  # Model class contains all the variables and constraints that define the problem
  # The variables and constraints are stored in the CpModelProto object
  # The Class also provides all the methods used to add variables and define constraints
  class Model

    def initialize
      @proto = CpModelProto.new(variables: [] of IntegerVariableProto,
                                                 constraints: [] of ConstraintProto)
    end

    # VARIABLES

    # Provides an IntVar for integer variables
    def new_int_var(min : Int64, max : Int64, name="")
      # Must use not_nil! because the compiler cannot guarantee that the array is not nil
      # even though it is initialized in the constructor
      variables = @proto.variables.not_nil!
      index = variables.size
      variables.push(IntegerVariableProto.new(name: name, domain: [min, max]))
      IntVar.new(index)
    end

    # Provides a `BoolVar` for boolean variables
    def new_bool_var(name="")
      variables = @proto.variables.not_nil!
      index = variables.size
      variables.push(IntegerVariableProto.new(name: name, domain: [0_i64, 1_i64]))
      BoolVar.new(index)
    end

    # CONSTRAINTS

    # Boolean Constraints

    # Forces at least one of the boolean variables to be true
    #
    # When *enforcement_literals* are provided, this constraint will only be followed if
    # all literals are true.
    def add_bool_or(vars : Array(BoolVar), enforcement_literals=[] of BoolVar)
      contraint_proto = ConstraintProto.new(bool_or: BoolArgumentProto.new(literals: vars.map{ |x| x.index }),
                                            enforcement_literal: enforcement_literals.map{ |x| x.index })
      @proto.constraints.try &.push(contraint_proto)
    end

    # Forces all of the boolean variables to be true
    #
    # When *enforcement_literals* are provided, this constraint will only be followed if
    # all literals are true.
    def add_bool_and(vars : Array(BoolVar), enforcement_literals=[] of BoolVar)
      contraint_proto = ConstraintProto.new(bool_and: BoolArgumentProto.new(literals: vars.map{ |x| x.index }),
                                            enforcement_literal: enforcement_literals.map{ |x| x.index })
      @proto.constraints.try &.push(contraint_proto)
    end

    # Forces an odd number of the provided boolean variables to be true
    def add_bool_xor(vars : Array(BoolVar))
      contraint_proto = ConstraintProto.new(bool_xor: BoolArgumentProto.new(literals: vars.map{ |x| x.index }))
      @proto.constraints.try &.push(contraint_proto)
    end

    # Forces exactly one of the provided boolean variables to be true
    def add_exactly_one(vars : Array(BoolVar))
      contraint_proto = ConstraintProto.new(exactly_one: BoolArgumentProto.new(literals: vars.map{ |x| x.index }))
      @proto.constraints.try &.push(contraint_proto)
    end

    # Forces at most one of the provided boolean variables to be true
    def add_at_most_one(vars : Array(BoolVar))
      contraint_proto = ConstraintProto.new(at_most_one: BoolArgumentProto.new(literals: vars.map{ |x| x.index }))
      @proto.constraints.try &.push(contraint_proto)
    end

    # Forces at least one of the provided boolean variables to be false
    def add_not_all(vars : Array(BoolVar),enforcement_literals=[] of BoolVar)
      add_bool_or(vars.map { |b| -b },enforcement_literals)
    end

    # Forces all BoolVars provided to be false
    def add_none(vars : Array(BoolVar),enforcement_literals=[] of BoolVar)
      add_bool_and(vars.map { |b| -b },enforcement_literals)
    end

    # Linear Constraints

    # Forces the target to equal exprs[0] / exprs[1].
    # The division is rounded towards zero.
    # For exact integer division, use product constraint and place the target as an expr.
    # E.g. a = b * target
    def add_int_div(target : Expressible, exprs : Array(Expressible))
      target = target.to_lexpr
      exprs = exprs.map { |arg| arg.to_lexpr }
      constraint_proto = ConstraintProto.new(int_div: LinearArgumentProto.new(target: target.proto, exprs: exprs.map{ |x| x.proto }))
      @proto.constraints.try &.push(constraint_proto)
    end

    # Forces the target to be equal exprs[0] % exprs[1].
    def add_int_mod(target : Expressible, exprs : Array(Expressible))
      target = target.to_lexpr
      exprs = exprs.map { |arg| arg.to_lexpr }
      constraint_proto = ConstraintProto.new(int_mod: LinearArgumentProto.new(target: target.proto, exprs: exprs.map{ |x| x.proto }))
      @proto.constraints.try &.push(constraint_proto)
    end

    # Forces the target to be equal to the product of the exprs.
    # The product must fit in an int64 or the model will be invalid.
    def add_int_prod(target : Expressible, exprs : Array(Expressible))
      target = target.to_lexpr
      exprs = exprs.map { |arg| arg.to_lexpr }
      constraint_proto = ConstraintProto.new(int_prod: LinearArgumentProto.new(target: target.proto, exprs: exprs.map{ |x| x.proto }))
      @proto.constraints.try &.push(constraint_proto)
    end

    # Forces *target* to equal the max of all *exprs*
    def add_max(target : Expressible, exprs : Array(Expressible))
      target = target.to_lexpr
      exprs = exprs.map { |expr| expr.to_lexpr }
      constraint_proto = ConstraintProto.new(lin_max: LinearArgumentProto.new(target: target.proto, exprs: exprs.map{ |x| x.proto }))
      @proto.constraints.try &.push(constraint_proto)
    end

    # Forces *target* to equal the min of all *exprs*
    def add_min(target : Expressible, exprs : Array(Expressible))
      target = target.to_lexpr
      exprs = exprs.map { |expr| expr.to_lexpr }
      constraint_proto = ConstraintProto.new(lin_max: LinearArgumentProto.new(target: (-target).proto, exprs: exprs.map{ |x| (-x).proto }))
      @proto.constraints.try &.push(constraint_proto)
    end

    # Implements a linear constraint in the form of a <= b  or a == b.
    #
    # E.g. model.add_constraint( 2*x + 3*y <= 44)
    def add_constraint(constraint : LinearConstraint)
      @proto.constraints.try &.push(constraint.proto)
    end

    def add_all_diff(vars : Array(Expressible))
      vars = vars.map { |arg| arg.to_lexpr }
      constraint_proto = ConstraintProto.new(all_diff: AllDifferentConstraintProto.new(exprs: vars.map{ |x| x.proto }))
      @proto.constraints.try &.push(constraint_proto)
    end


    # Creates and equivelence between target variable and the result of the logical OR of the vars
    def set_to_bool_or(target : BoolVar, vars : Array(BoolVar))
      add_bool_or(vars, [target])
      add_bool_and(vars.map { |x| -x }, [-target])
    end

    # Creates and equivelence between target variable and the result of the logical AND of the vars
    def set_to_bool_and(target : BoolVar, vars : Array(BoolVar))
      add_bool_and(vars, [target])
      add_bool_or(vars.map { |x| -x }, [-target])
    end

    # Create an objective to minimize
    def minimize(expr : LinearExpression, domain=[] of Int64, offset : (Float64|Nil) = nil, scaling_factor : (Float64|Nil)=nil)
      @proto.objective = CpObjectiveProto.new(vars: expr.variables, coeffs: expr.coefficients, offset: offset,
                                              scaling_factor: scaling_factor, domain: domain)
    end

    # Attempts to solve
    def solve : Solution
      io = @proto.to_protobuf
      buffer, size = make_buffer(io)
      return_size_pointer = Pointer(LibC::SizeT).malloc
      result = CPSATWrapper.cp_sat_wrapper_solve(buffer, size, return_size_pointer)
      io = make_io(result, return_size_pointer.value)
      proto = CpSolverResponse.from_protobuf(io)
      if Solution.valid? proto
        ValidSolution.new proto
      else
        Solution.new proto
      end
    end

    # Private methods

    private def make_buffer(io : IO) : Tuple(Pointer(UInt8), LibC::SizeT)
      bytes = io.to_slice
      buffer = bytes.to_unsafe
      size = bytes.size.to_u64
      {buffer, size}
    end

    private def make_io(buffer : Pointer(UInt8), size : LibC::SizeT)
      bytes = Bytes.new(buffer, size)
      IO::Memory.new(bytes)
    end

  end
end
