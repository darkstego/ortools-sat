require "./connector/cp_model.pb"

module ORTools::Sat
  # Class contains solution of Sat-Model
  class Solution
    getter proto : CpSolverResponse

    def initialize(@proto)
    end
    
    def status : CpSolverStatus
      @proto.status.not_nil!
    end

    # Returns true is solution was found
    def valid? : Bool
      @proto.status == CpSolverStatus::FEASIBLE || proto.status == CpSolverStatus::OPTIMAL
    end

    # Returns true if the response *proto* passed indicates a solution was found
    def self.valid?(proto : CpSolverResponse) : Bool
      proto.status == CpSolverStatus::FEASIBLE || proto.status == CpSolverStatus::OPTIMAL
    end
  end

  # Class should only contain solutions deemed valid 
  class ValidSolution < Solution
    
    # Returns the value of the objective function if found
    def objective_value
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
