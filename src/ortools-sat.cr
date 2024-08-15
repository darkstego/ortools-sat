require "./cp_model.pb"

# Module to access ORTools::Sat from within Crystal
module ORTools::Sat
  VERSION = "0.1.0"

  @[Link(ldflags: "#{__DIR__}/cp_sat_wrapper.o -lortools -lstdc++ -lprotobuf")]
  lib CPSATWrapper
	  fun cp_sat_wrapper_solve(Pointer(UInt8),LibC::SizeT, Pointer(LibC::SizeT)) : Pointer(UInt8)
  end

  # All types that can be converted to a `LinearExpression` with #to_lexpr
  alias Expressible = (Int32|Int64|IntVar|LinearExpression)

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
      LinearExpression.new([@index], [1_i64])
    end
  end

  # This class is identical to IntVar, but is used to type check the input to literal constraints
  class BoolVar < IntVar
  end

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

    def -(other : Expressible)
      other = other.to_lexpr
      LinearExpression.new(@variables + other.variables, @coefficients + other.coefficients.map { |x| -x }, @constant - other.constant)
    end

    def to_lexpr : LinearExpression
      self
    end

    def <=(other : Expressible)
      other = other.to_lexpr
      LinearConstraint.less_or_equal(self, other)
    end

    def <(other : Expressible)
      other = other.to_lexpr
      LinearConstraint.less_than(self, other)
    end

    def >=(other : Expressible)
      other = other.to_lexpr
      LinearConstraint.greater_or_equal(self, other)
    end

    def >(other : Expressible)
      other = other.to_lexpr
      LinearConstraint.greater_than(self, other)
    end

    def ==(other : Expressible)
      other = other.to_lexpr
      LinearConstraint.equal(self, other)
    end

    def !=(other : Expressible)
      other = other.to_lexpr
      LinearConstraint.not_equal(self, other)
    end

  end

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

    # Farces at least one of the provided boolean variables to be false
    def add_not_all(vars : Array(BoolVar))
      add_bool_or vars.map { |b| -b }
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

    def solve
      io = @proto.to_protobuf
      buffer, size = make_buffer(io)
      return_size_pointer = Pointer(LibC::SizeT).malloc
      result = CPSATWrapper.cp_sat_wrapper_solve(buffer, size, return_size_pointer)
      io = make_io(result, return_size_pointer.value)
      Solution.new CpSolverResponse.from_protobuf(io)
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

  class Solution
    getter proto : CpSolverResponse

    def initialize(@proto)
    end

    def status : CpSolverStatus
      @proto.status
    end

    def solved? : Bool
      @proto.status == CpSolverStatus::FEASIBLE || proto.status == CpSolverStatus::OPTIMAL
    end

    def objective_value : Int64
      @proto.objective_value
    end

    def true?(bool_var : BoolVar) : Bool
      index = bool_var.index
      value = value(bool_var) == 1
      index >= 0 ? value : !value
    end

    def value(int_var : BoolVar) : Int64
      index = int_var.index
      value = raw_value index
      index >= 0 ? value : 1_i64-value
    end

    def value(int_var : IntVar) : Int64
      index = int_var.index
      value = raw_value index
      index >= 0 ? value : -value
    end

    private def raw_value(index : Int) : Int64
      solution = @proto.solution.not_nil!
      positive_index = index >= 0 ? index : -index - 1
      solution[positive_index]
    end
  end

end
