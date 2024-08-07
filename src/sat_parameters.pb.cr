## Generated from sat_parameters.proto for operations_research.sat
require "protobuf"

module OperationsResearch
  module Sat
    
    class SatParameters
      include ::Protobuf::Message
      enum VariableOrder
        INORDER = 0
        INREVERSEORDER = 1
        INRANDOMORDER = 2
      end
      enum Polarity
        POLARITYTRUE = 0
        POLARITYFALSE = 1
        POLARITYRANDOM = 2
      end
      enum ConflictMinimizationAlgorithm
        NONE = 0
        SIMPLE = 1
        RECURSIVE = 2
        EXPERIMENTAL = 3
      end
      enum BinaryMinizationAlgorithm
        NOBINARYMINIMIZATION = 0
        BINARYMINIMIZATIONFIRST = 1
        BINARYMINIMIZATIONFIRSTWITHTRANSITIVEREDUCTION = 4
        BINARYMINIMIZATIONWITHREACHABILITY = 2
        EXPERIMENTALBINARYMINIMIZATION = 3
      end
      enum ClauseProtection
        PROTECTIONNONE = 0
        PROTECTIONALWAYS = 1
        PROTECTIONLBD = 2
      end
      enum ClauseOrdering
        CLAUSEACTIVITY = 0
        CLAUSELBD = 1
      end
      enum RestartAlgorithm
        NORESTART = 0
        LUBYRESTART = 1
        DLMOVINGAVERAGERESTART = 2
        LBDMOVINGAVERAGERESTART = 3
        FIXEDRESTART = 4
      end
      enum MaxSatAssumptionOrder
        DEFAULTASSUMPTIONORDER = 0
        ORDERASSUMPTIONBYDEPTH = 1
        ORDERASSUMPTIONBYWEIGHT = 2
      end
      enum MaxSatStratificationAlgorithm
        STRATIFICATIONNONE = 0
        STRATIFICATIONDESCENT = 1
        STRATIFICATIONASCENT = 2
      end
      enum SearchBranching
        AUTOMATICSEARCH = 0
        FIXEDSEARCH = 1
        PORTFOLIOSEARCH = 2
        LPSEARCH = 3
        PSEUDOCOSTSEARCH = 4
        PORTFOLIOWITHQUICKRESTARTSEARCH = 5
        HINTSEARCH = 6
        PARTIALFIXEDSEARCH = 7
        RANDOMIZEDSEARCH = 8
      end
      enum SharedTreeSplitStrategy
        SPLITSTRATEGYAUTO = 0
        SPLITSTRATEGYDISCREPANCY = 1
        SPLITSTRATEGYOBJECTIVELB = 2
        SPLITSTRATEGYBALANCEDTREE = 3
        SPLITSTRATEGYFIRSTPROPOSAL = 4
      end
      enum FPRoundingMethod
        NEARESTINTEGER = 0
        LOCKBASED = 1
        ACTIVELOCKBASED = 3
        PROPAGATIONASSISTED = 2
      end
      
      contract_of "proto2" do
        optional :name, :string, 171, default: ""
        optional :preferred_variable_order, SatParameters::VariableOrder, 1, default: SatParameters::VariableOrder::INORDER
        optional :initial_polarity, SatParameters::Polarity, 2, default: SatParameters::Polarity::POLARITYFALSE
        optional :use_phase_saving, :bool, 44, default: true
        optional :polarity_rephase_increment, :int32, 168, default: 1000
        optional :random_polarity_ratio, :double, 45, default: 0_f64
        optional :random_branches_ratio, :double, 32, default: 0_f64
        optional :use_erwa_heuristic, :bool, 75, default: false
        optional :initial_variables_activity, :double, 76, default: 0_f64
        optional :also_bump_variables_in_conflict_reasons, :bool, 77, default: false
        optional :minimization_algorithm, SatParameters::ConflictMinimizationAlgorithm, 4, default: SatParameters::ConflictMinimizationAlgorithm::RECURSIVE
        optional :binary_minimization_algorithm, SatParameters::BinaryMinizationAlgorithm, 34, default: SatParameters::BinaryMinizationAlgorithm::BINARYMINIMIZATIONFIRST
        optional :subsumption_during_conflict_analysis, :bool, 56, default: true
        optional :clause_cleanup_period, :int32, 11, default: 10000
        optional :clause_cleanup_target, :int32, 13, default: 0
        optional :clause_cleanup_ratio, :double, 190, default: 0.5_f64
        optional :clause_cleanup_protection, SatParameters::ClauseProtection, 58, default: SatParameters::ClauseProtection::PROTECTIONNONE
        optional :clause_cleanup_lbd_bound, :int32, 59, default: 5
        optional :clause_cleanup_ordering, SatParameters::ClauseOrdering, 60, default: SatParameters::ClauseOrdering::CLAUSEACTIVITY
        optional :pb_cleanup_increment, :int32, 46, default: 200
        optional :pb_cleanup_ratio, :double, 47, default: 0.5_f64
        optional :variable_activity_decay, :double, 15, default: 0.8_f64
        optional :max_variable_activity_value, :double, 16, default: 1e+100_f64
        optional :glucose_max_decay, :double, 22, default: 0.95_f64
        optional :glucose_decay_increment, :double, 23, default: 0.01_f64
        optional :glucose_decay_increment_period, :int32, 24, default: 5000
        optional :clause_activity_decay, :double, 17, default: 0.999_f64
        optional :max_clause_activity_value, :double, 18, default: 1e+20_f64
        repeated :restart_algorithms, SatParameters::RestartAlgorithm, 61
        optional :default_restart_algorithms, :string, 70, default: "LUBY_RESTART,LBD_MOVING_AVERAGE_RESTART,DL_MOVING_AVERAGE_RESTART"
        optional :restart_period, :int32, 30, default: 50
        optional :restart_running_window_size, :int32, 62, default: 50
        optional :restart_dl_average_ratio, :double, 63, default: 1_f64
        optional :restart_lbd_average_ratio, :double, 71, default: 1_f64
        optional :use_blocking_restart, :bool, 64, default: false
        optional :blocking_restart_window_size, :int32, 65, default: 5000
        optional :blocking_restart_multiplier, :double, 66, default: 1.4_f64
        optional :num_conflicts_before_strategy_changes, :int32, 68, default: 0
        optional :strategy_change_increase_ratio, :double, 69, default: 0_f64
        optional :max_time_in_seconds, :double, 36, default: inf_f64
        optional :max_deterministic_time, :double, 67, default: inf_f64
        optional :max_number_of_conflicts, :int64, 37, default: 9223372036854775807_i64
        optional :max_memory_in_mb, :int64, 40, default: 10000_i64
        optional :absolute_gap_limit, :double, 159, default: 0.0001_f64
        optional :relative_gap_limit, :double, 160, default: 0_f64
        optional :random_seed, :int32, 31, default: 1
        optional :permute_variable_randomly, :bool, 178, default: false
        optional :permute_presolve_constraint_order, :bool, 179, default: false
        optional :use_absl_random, :bool, 180, default: false
        optional :log_search_progress, :bool, 41, default: false
        optional :log_subsolver_statistics, :bool, 189, default: false
        optional :log_prefix, :string, 185, default: ""
        optional :log_to_stdout, :bool, 186, default: true
        optional :log_to_response, :bool, 187, default: false
        optional :use_pb_resolution, :bool, 43, default: false
        optional :minimize_reduction_during_pb_resolution, :bool, 48, default: false
        optional :count_assumption_levels_in_lbd, :bool, 49, default: true
        optional :presolve_bve_threshold, :int32, 54, default: 500
        optional :presolve_bve_clause_weight, :int32, 55, default: 3
        optional :probing_deterministic_time_limit, :double, 226, default: 1_f64
        optional :presolve_probing_deterministic_time_limit, :double, 57, default: 30_f64
        optional :presolve_blocked_clause, :bool, 88, default: true
        optional :presolve_use_bva, :bool, 72, default: true
        optional :presolve_bva_threshold, :int32, 73, default: 1
        optional :max_presolve_iterations, :int32, 138, default: 3
        optional :cp_model_presolve, :bool, 86, default: true
        optional :cp_model_probing_level, :int32, 110, default: 2
        optional :cp_model_use_sat_presolve, :bool, 93, default: true
        optional :detect_table_with_cost, :bool, 216, default: false
        optional :table_compression_level, :int32, 217, default: 2
        optional :expand_alldiff_constraints, :bool, 170, default: false
        optional :expand_reservoir_constraints, :bool, 182, default: true
        optional :max_lin_max_size_for_expansion, :int32, 280, default: 0
        optional :disable_constraint_expansion, :bool, 181, default: false
        optional :encode_complex_linear_constraint_with_integer, :bool, 223, default: false
        optional :merge_no_overlap_work_limit, :double, 145, default: 1000000000000_f64
        optional :merge_at_most_one_work_limit, :double, 146, default: 100000000_f64
        optional :presolve_substitution_level, :int32, 147, default: 1
        optional :presolve_extract_integer_enforcement, :bool, 174, default: false
        optional :presolve_inclusion_work_limit, :int64, 201, default: 100000000_i64
        optional :ignore_names, :bool, 202, default: true
        optional :infer_all_diffs, :bool, 233, default: true
        optional :find_big_linear_overlap, :bool, 234, default: true
        optional :use_sat_inprocessing, :bool, 163, default: true
        optional :inprocessing_dtime_ratio, :double, 273, default: 0.2_f64
        optional :inprocessing_probing_dtime, :double, 274, default: 1_f64
        optional :inprocessing_minimization_dtime, :double, 275, default: 1_f64
        optional :num_workers, :int32, 206, default: 0
        optional :num_search_workers, :int32, 100, default: 0
        optional :min_num_lns_workers, :int32, 211, default: 2
        repeated :subsolvers, :string, 207
        repeated :extra_subsolvers, :string, 219
        repeated :ignore_subsolvers, :string, 209
        repeated :subsolver_params, SatParameters, 210
        optional :interleave_search, :bool, 136, default: false
        optional :interleave_batch_size, :int32, 134, default: 0
        optional :share_objective_bounds, :bool, 113, default: true
        optional :share_level_zero_bounds, :bool, 114, default: true
        optional :share_binary_clauses, :bool, 203, default: true
        optional :debug_postsolve_with_full_solver, :bool, 162, default: false
        optional :debug_max_num_presolve_operations, :int32, 151, default: 0
        optional :debug_crash_on_bad_hint, :bool, 195, default: false
        optional :use_optimization_hints, :bool, 35, default: true
        optional :core_minimization_level, :int32, 50, default: 2
        optional :find_multiple_cores, :bool, 84, default: true
        optional :cover_optimization, :bool, 89, default: true
        optional :max_sat_assumption_order, SatParameters::MaxSatAssumptionOrder, 51, default: SatParameters::MaxSatAssumptionOrder::DEFAULTASSUMPTIONORDER
        optional :max_sat_reverse_assumption_order, :bool, 52, default: false
        optional :max_sat_stratification, SatParameters::MaxSatStratificationAlgorithm, 53, default: SatParameters::MaxSatStratificationAlgorithm::STRATIFICATIONDESCENT
        optional :propagation_loop_detection_factor, :double, 221, default: 10_f64
        optional :use_precedences_in_disjunctive_constraint, :bool, 74, default: true
        optional :max_size_to_create_precedence_literals_in_disjunctive, :int32, 229, default: 60
        optional :use_strong_propagation_in_disjunctive, :bool, 230, default: false
        optional :use_dynamic_precedence_in_disjunctive, :bool, 263, default: false
        optional :use_dynamic_precedence_in_cumulative, :bool, 268, default: false
        optional :use_overload_checker_in_cumulative, :bool, 78, default: false
        optional :use_timetable_edge_finding_in_cumulative, :bool, 79, default: false
        optional :max_num_intervals_for_timetable_edge_finding, :int32, 260, default: 100
        optional :use_hard_precedences_in_cumulative, :bool, 215, default: false
        optional :exploit_all_precedences, :bool, 220, default: false
        optional :use_disjunctive_constraint_in_cumulative, :bool, 80, default: true
        optional :use_timetabling_in_no_overlap_2d, :bool, 200, default: false
        optional :use_energetic_reasoning_in_no_overlap_2d, :bool, 213, default: false
        optional :use_area_energetic_reasoning_in_no_overlap_2d, :bool, 271, default: false
        optional :max_pairs_pairwise_reasoning_in_no_overlap_2d, :int32, 276, default: 1250
        optional :use_dual_scheduling_heuristics, :bool, 214, default: true
        optional :search_branching, SatParameters::SearchBranching, 82, default: SatParameters::SearchBranching::AUTOMATICSEARCH
        optional :hint_conflict_limit, :int32, 153, default: 10
        optional :repair_hint, :bool, 167, default: false
        optional :fix_variables_to_their_hinted_value, :bool, 192, default: false
        optional :use_probing_search, :bool, 176, default: false
        optional :use_extended_probing, :bool, 269, default: true
        optional :probing_num_combinations_limit, :int32, 272, default: 20000
        optional :use_shaving_in_probing_search, :bool, 204, default: true
        optional :shaving_search_deterministic_time, :double, 205, default: 0.001_f64
        optional :use_objective_lb_search, :bool, 228, default: false
        optional :use_objective_shaving_search, :bool, 253, default: false
        optional :pseudo_cost_reliability_threshold, :int64, 123, default: 100_i64
        optional :optimize_with_core, :bool, 83, default: false
        optional :optimize_with_lb_tree_search, :bool, 188, default: false
        optional :binary_search_num_conflicts, :int32, 99, default: -1
        optional :optimize_with_max_hs, :bool, 85, default: false
        optional :use_feasibility_jump, :bool, 265, default: true
        optional :test_feasibility_jump, :bool, 240, default: false
        optional :feasibility_jump_decay, :double, 242, default: 0.95_f64
        optional :feasibility_jump_linearization_level, :int32, 257, default: 2
        optional :feasibility_jump_restart_factor, :int32, 258, default: 1
        optional :feasibility_jump_var_randomization_probability, :double, 247, default: 0_f64
        optional :feasibility_jump_var_perburbation_range_ratio, :double, 248, default: 0.2_f64
        optional :feasibility_jump_enable_restarts, :bool, 250, default: true
        optional :feasibility_jump_max_expanded_constraint_size, :int32, 264, default: 100
        optional :num_violation_ls, :int32, 244, default: 0
        optional :violation_ls_perturbation_period, :int32, 249, default: 100
        optional :violation_ls_compound_move_probability, :double, 259, default: 0.5_f64
        optional :shared_tree_num_workers, :int32, 235, default: 0
        optional :use_shared_tree_search, :bool, 236, default: false
        optional :shared_tree_worker_objective_split_probability, :double, 237, default: 0.5_f64
        optional :shared_tree_worker_min_restarts_per_subtree, :int32, 282, default: 32
        optional :shared_tree_open_leaves_per_worker, :double, 281, default: 2_f64
        optional :shared_tree_max_nodes_per_worker, :int32, 238, default: 128
        optional :shared_tree_split_strategy, SatParameters::SharedTreeSplitStrategy, 239, default: SatParameters::SharedTreeSplitStrategy::SPLITSTRATEGYAUTO
        optional :enumerate_all_solutions, :bool, 87, default: false
        optional :keep_all_feasible_solutions_in_presolve, :bool, 173, default: false
        optional :fill_tightened_domains_in_response, :bool, 132, default: false
        optional :fill_additional_solutions_in_response, :bool, 194, default: false
        optional :instantiate_all_variables, :bool, 106, default: true
        optional :auto_detect_greater_than_at_least_one_of, :bool, 95, default: true
        optional :stop_after_first_solution, :bool, 98, default: false
        optional :stop_after_presolve, :bool, 149, default: false
        optional :stop_after_root_propagation, :bool, 252, default: false
        optional :use_lns, :bool, 283, default: true
        optional :use_lns_only, :bool, 101, default: false
        optional :solution_pool_size, :int32, 193, default: 3
        optional :use_rins_lns, :bool, 129, default: true
        optional :use_feasibility_pump, :bool, 164, default: true
        optional :use_lb_relax_lns, :bool, 255, default: false
        optional :fp_rounding, SatParameters::FPRoundingMethod, 165, default: SatParameters::FPRoundingMethod::PROPAGATIONASSISTED
        optional :diversify_lns_params, :bool, 137, default: false
        optional :randomize_search, :bool, 103, default: false
        optional :search_random_variable_pool_size, :int64, 104, default: 0_i64
        optional :push_all_tasks_toward_start, :bool, 262, default: false
        optional :use_optional_variables, :bool, 108, default: false
        optional :use_exact_lp_reason, :bool, 109, default: true
        optional :use_combined_no_overlap, :bool, 133, default: false
        optional :at_most_one_max_expansion_size, :int32, 270, default: 3
        optional :catch_sigint_signal, :bool, 135, default: true
        optional :use_implied_bounds, :bool, 144, default: true
        optional :polish_lp_solution, :bool, 175, default: false
        optional :lp_primal_tolerance, :double, 266, default: 1e-07_f64
        optional :lp_dual_tolerance, :double, 267, default: 1e-07_f64
        optional :convert_intervals, :bool, 177, default: true
        optional :symmetry_level, :int32, 183, default: 2
        optional :new_linear_propagation, :bool, 224, default: true
        optional :linear_split_size, :int32, 256, default: 100
        optional :linearization_level, :int32, 90, default: 1
        optional :boolean_encoding_level, :int32, 107, default: 1
        optional :max_domain_size_when_encoding_eq_neq_constraints, :int32, 191, default: 16
        optional :max_num_cuts, :int32, 91, default: 10000
        optional :cut_level, :int32, 196, default: 1
        optional :only_add_cuts_at_level_zero, :bool, 92, default: false
        optional :add_objective_cut, :bool, 197, default: false
        optional :add_cg_cuts, :bool, 117, default: true
        optional :add_mir_cuts, :bool, 120, default: true
        optional :add_zero_half_cuts, :bool, 169, default: true
        optional :add_clique_cuts, :bool, 172, default: true
        optional :add_rlt_cuts, :bool, 279, default: true
        optional :max_all_diff_cut_size, :int32, 148, default: 64
        optional :add_lin_max_cuts, :bool, 152, default: true
        optional :max_integer_rounding_scaling, :int32, 119, default: 600
        optional :add_lp_constraints_lazily, :bool, 112, default: true
        optional :root_lp_iterations, :int32, 227, default: 2000
        optional :min_orthogonality_for_lp_constraints, :double, 115, default: 0.05_f64
        optional :max_cut_rounds_at_level_zero, :int32, 154, default: 1
        optional :max_consecutive_inactive_count, :int32, 121, default: 100
        optional :cut_max_active_count_value, :double, 155, default: 10000000000_f64
        optional :cut_active_count_decay, :double, 156, default: 0.8_f64
        optional :cut_cleanup_target, :int32, 157, default: 1000
        optional :new_constraints_batch_size, :int32, 122, default: 50
        optional :exploit_integer_lp_solution, :bool, 94, default: true
        optional :exploit_all_lp_solution, :bool, 116, default: true
        optional :exploit_best_solution, :bool, 130, default: false
        optional :exploit_relaxation_solution, :bool, 161, default: false
        optional :exploit_objective, :bool, 131, default: true
        optional :detect_linearized_product, :bool, 277, default: false
        optional :mip_max_bound, :double, 124, default: 10000000_f64
        optional :mip_var_scaling, :double, 125, default: 1_f64
        optional :mip_scale_large_domain, :bool, 225, default: false
        optional :mip_automatically_scale_variables, :bool, 166, default: true
        optional :only_solve_ip, :bool, 222, default: false
        optional :mip_wanted_precision, :double, 126, default: 1e-06_f64
        optional :mip_max_activity_exponent, :int32, 127, default: 53
        optional :mip_check_precision, :double, 128, default: 0.0001_f64
        optional :mip_compute_true_objective_bound, :bool, 198, default: true
        optional :mip_max_valid_magnitude, :double, 199, default: 1e+20_f64
        optional :mip_treat_high_magnitude_bounds_as_infinity, :bool, 278, default: false
        optional :mip_drop_tolerance, :double, 232, default: 1e-16_f64
        optional :mip_presolve_level, :int32, 261, default: 2
      end
    end
    end
  end
