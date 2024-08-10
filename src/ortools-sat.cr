require "./cp_model.pb"

# TODO: Write documentation for `Ortools::Sat`
module ORTools::Sat
  VERSION = "0.1.0"

  @[Link(ldflags: "#{__DIR__}/cp_sat_wrapper.o -lortools -lstdc++ -lprotobuf")]
  lib CPSATWrapper
	  fun cp_sat_wrapper_solve(Pointer(UInt8),LibC::SizeT, Pointer(LibC::SizeT)) : Pointer(UInt8)
  end


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

    def add_all_diff(*args : (LinearExpression|IntVar))
      vars = args.map { |arg| arg.is_a?(IntVar) ? arg.to_le : arg }.to_a
      constraint_proto = ConstraintProto.new(all_diff: AllDifferentConstraintProto.new(exprs: vars.map{ |x| x.to_proto }))
      @proto.constraints.try &.push(constraint_proto)
    end

    def solve
      io = @proto.to_protobuf
      buffer, size = make_buffer(io)
      return_size_pointer = Pointer(LibC::SizeT).malloc
      result = CPSATWrapper.cp_sat_wrapper_solve(buffer, size, return_size_pointer)
      io = make_io(result, return_size_pointer.value)
      response = CpSolverResponse.from_protobuf(io)
    end

    private def make_buffer(io : IO) : Tuple(Pointer(UInt8), LibC::SizeT)
      bytes = io.to_slice
      buffer = bytes.to_unsafe
      size = bytes.size
      {% if flag?(:bits64) %}
        size = size.to_u64
      {% else %}
        if value > UInt32::MAX || value < 0
          raise OverflowError.new("Value #{value} cannot be represented in UInt32")
        end
        size = size.to_u32
      {% end %}
      {buffer, size}
    end

    private def make_io(buffer : Pointer(UInt8), size : LibC::SizeT)
      bytes = Bytes.new(buffer, size)
      IO::Memory.new(bytes)
    end

  end
end