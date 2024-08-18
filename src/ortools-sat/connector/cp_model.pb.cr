## Generated from cp_model.proto for operations_research.sat
require "protobuf"

module ORTools::Sat
  enum CpSolverStatus
    UNKNOWN = 0
    MODELINVALID = 1
    FEASIBLE = 2
    INFEASIBLE = 3
    OPTIMAL = 4
  end

  struct IntegerVariableProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :name, :string, 1
      repeated :domain, :int64, 2
    end
  end

  struct BoolArgumentProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :literals, :int32, 1
    end
  end

  struct LinearExpressionProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :vars, :int32, 1
      repeated :coeffs, :int64, 2
      optional :offset, :int64, 3
    end
  end

  struct LinearArgumentProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :target, LinearExpressionProto, 1
      repeated :exprs, LinearExpressionProto, 2
    end
  end

  struct AllDifferentConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :exprs, LinearExpressionProto, 1
    end
  end

  struct LinearConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :vars, :int32, 1
      repeated :coeffs, :int64, 2
      repeated :domain, :int64, 3
    end
  end

  struct ElementConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :index, :int32, 1
      optional :target, :int32, 2
      repeated :vars, :int32, 3
    end
  end

  struct IntervalConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :start, LinearExpressionProto, 4
      optional :end, LinearExpressionProto, 5
      optional :size, LinearExpressionProto, 6
    end
  end

  struct NoOverlapConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :intervals, :int32, 1
    end
  end

  struct NoOverlap2DConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :x_intervals, :int32, 1
      repeated :y_intervals, :int32, 2
    end
  end

  struct CumulativeConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :capacity, LinearExpressionProto, 1
      repeated :intervals, :int32, 2
      repeated :demands, LinearExpressionProto, 3
    end
  end

  struct ReservoirConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :min_level, :int64, 1
      optional :max_level, :int64, 2
      repeated :time_exprs, LinearExpressionProto, 3
      repeated :level_changes, LinearExpressionProto, 6
      repeated :active_literals, :int32, 5
    end
  end

  struct CircuitConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :tails, :int32, 3
      repeated :heads, :int32, 4
      repeated :literals, :int32, 5
    end
  end

  struct RoutesConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :tails, :int32, 1
      repeated :heads, :int32, 2
      repeated :literals, :int32, 3
      repeated :demands, :int32, 4
      optional :capacity, :int64, 5
    end
  end

  struct TableConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :vars, :int32, 1
      repeated :values, :int64, 2
      optional :negated, :bool, 3
    end
  end

  struct InverseConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :f_direct, :int32, 1
      repeated :f_inverse, :int32, 2
    end
  end

  struct AutomatonConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :starting_state, :int64, 2
      repeated :final_states, :int64, 3
      repeated :transition_tail, :int64, 4
      repeated :transition_head, :int64, 5
      repeated :transition_label, :int64, 6
      repeated :vars, :int32, 7
    end
  end

  struct ListOfVariablesProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :vars, :int32, 1
    end
  end

  struct ConstraintProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :name, :string, 1
      repeated :enforcement_literal, :int32, 2
      optional :bool_or, BoolArgumentProto, 3
      optional :bool_and, BoolArgumentProto, 4
      optional :at_most_one, BoolArgumentProto, 26
      optional :exactly_one, BoolArgumentProto, 29
      optional :bool_xor, BoolArgumentProto, 5
      optional :int_div, LinearArgumentProto, 7
      optional :int_mod, LinearArgumentProto, 8
      optional :int_prod, LinearArgumentProto, 11
      optional :lin_max, LinearArgumentProto, 27
      optional :linear, LinearConstraintProto, 12
      optional :all_diff, AllDifferentConstraintProto, 13
      optional :element, ElementConstraintProto, 14
      optional :circuit, CircuitConstraintProto, 15
      optional :routes, RoutesConstraintProto, 23
      optional :table, TableConstraintProto, 16
      optional :automaton, AutomatonConstraintProto, 17
      optional :inverse, InverseConstraintProto, 18
      optional :reservoir, ReservoirConstraintProto, 24
      optional :interval, IntervalConstraintProto, 19
      optional :no_overlap, NoOverlapConstraintProto, 20
      optional :no_overlap_2d, NoOverlap2DConstraintProto, 21
      optional :cumulative, CumulativeConstraintProto, 22
      optional :dummy_constraint, ListOfVariablesProto, 30
    end
  end

  struct CpObjectiveProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :vars, :int32, 1
      repeated :coeffs, :int64, 4
      optional :offset, :double, 2
      optional :scaling_factor, :double, 3
      repeated :domain, :int64, 5
      optional :scaling_was_exact, :bool, 6
      optional :integer_before_offset, :int64, 7
      optional :integer_after_offset, :int64, 9
      optional :integer_scaling_factor, :int64, 8
    end
  end

  struct FloatObjectiveProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :vars, :int32, 1
      repeated :coeffs, :double, 2
      optional :offset, :double, 3
      optional :maximize, :bool, 4
    end
  end

  struct DecisionStrategyProto
    include ::Protobuf::Message
    enum VariableSelectionStrategy
      CHOOSEFIRST = 0
      CHOOSELOWESTMIN = 1
      CHOOSEHIGHESTMAX = 2
      CHOOSEMINDOMAINSIZE = 3
      CHOOSEMAXDOMAINSIZE = 4
    end
    enum DomainReductionStrategy
      SELECTMINVALUE = 0
      SELECTMAXVALUE = 1
      SELECTLOWERHALF = 2
      SELECTUPPERHALF = 3
      SELECTMEDIANVALUE = 4
    end

    contract_of "proto3" do
      repeated :variables, :int32, 1
      repeated :exprs, LinearExpressionProto, 5
      optional :variable_selection_strategy, DecisionStrategyProto::VariableSelectionStrategy, 2
      optional :domain_reduction_strategy, DecisionStrategyProto::DomainReductionStrategy, 3
    end
  end

  struct PartialVariableAssignment
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :vars, :int32, 1
      repeated :values, :int64, 2
    end
  end

  struct SparsePermutationProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :support, :int32, 1
      repeated :cycle_sizes, :int32, 2
    end
  end

  struct DenseMatrixProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :num_rows, :int32, 1
      optional :num_cols, :int32, 2
      repeated :entries, :int32, 3
    end
  end

  struct SymmetryProto
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :permutations, SparsePermutationProto, 1
      repeated :orbitopes, DenseMatrixProto, 2
    end
  end

  struct CpModelProto
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :name, :string, 1
      repeated :variables, IntegerVariableProto, 2
      repeated :constraints, ConstraintProto, 3
      optional :objective, CpObjectiveProto, 4
      optional :floating_point_objective, FloatObjectiveProto, 9
      repeated :search_strategy, DecisionStrategyProto, 5
      optional :solution_hint, PartialVariableAssignment, 6
      repeated :assumptions, :int32, 7
      optional :symmetry, SymmetryProto, 8
    end
  end

  struct CpSolverSolution
    include ::Protobuf::Message

    contract_of "proto3" do
      repeated :values, :int64, 1
    end
  end

  struct CpSolverResponse
    include ::Protobuf::Message

    contract_of "proto3" do
      optional :status, CpSolverStatus, 1
      repeated :solution, :int64, 2
      optional :objective_value, :double, 3
      optional :best_objective_bound, :double, 4
      repeated :additional_solutions, CpSolverSolution, 27
      repeated :tightened_variables, IntegerVariableProto, 21
      repeated :sufficient_assumptions_for_infeasibility, :int32, 23
      optional :integer_objective, CpObjectiveProto, 28
      optional :inner_objective_lower_bound, :int64, 29
      optional :num_integers, :int64, 30
      optional :num_booleans, :int64, 10
      optional :num_conflicts, :int64, 11
      optional :num_branches, :int64, 12
      optional :num_binary_propagations, :int64, 13
      optional :num_integer_propagations, :int64, 14
      optional :num_restarts, :int64, 24
      optional :num_lp_iterations, :int64, 25
      optional :wall_time, :double, 15
      optional :user_time, :double, 16
      optional :deterministic_time, :double, 17
      optional :gap_integral, :double, 22
      optional :solution_info, :string, 20
      optional :solve_log, :string, 26
    end
  end

end
