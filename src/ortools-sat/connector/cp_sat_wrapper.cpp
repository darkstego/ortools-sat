#include <cstdlib>
#include <cstring>
#include <iostream>
#include <vector>

#include <absl/types/span.h>
#include <ortools/sat/cp_model.h>
#include <ortools/sat/cp_model_checker.h>

namespace sat = operations_research::sat;

extern "C" unsigned char*
cp_sat_wrapper_solve(
    unsigned char* model_buf,
    size_t model_size,
    size_t* out_size)
{
    sat::CpModelProto model;
    if (!model.ParseFromArray(model_buf, model_size)) {
        *out_size = 0;
        return nullptr;
    }

    sat::CpSolverResponse response = sat::Solve(model);

    *out_size = response.ByteSizeLong();
    // Allocate at least one byte so a successful (possibly empty) response is
    // never confused with the nullptr returned on failure below.
    unsigned char* out_buf = (unsigned char*) malloc(*out_size + 1);
    if (out_buf == nullptr || !response.SerializeToArray(out_buf, *out_size)) {
        free(out_buf);
        *out_size = 0;
        return nullptr;
    }

    return out_buf;
}

 extern "C" unsigned char*
 cp_sat_wrapper_solve_with_parameters(
     unsigned char* model_buf,
     size_t model_size,
     unsigned char* params_buf,
     size_t params_size,
     size_t* out_size)
 {
    sat::CpModelProto model;
    if (!model.ParseFromArray(model_buf, model_size)) {
        *out_size = 0;
        return nullptr;
    }

    sat::SatParameters params;
    if (!params.ParseFromArray(params_buf, params_size)) {
        *out_size = 0;
        return nullptr;
    }

    sat::CpSolverResponse response = sat::SolveWithParameters(model, params);

    *out_size = response.ByteSizeLong();
    // Allocate at least one byte so a successful (possibly empty) response is
    // never confused with the nullptr returned on failure below.
    unsigned char* out_buf = (unsigned char*) malloc(*out_size + 1);
    if (out_buf == nullptr || !response.SerializeToArray(out_buf, *out_size)) {
        free(out_buf);
        *out_size = 0;
        return nullptr;
    }

    return out_buf;
}

extern "C" char*
cp_sat_wrapper_cp_model_stats(unsigned char* model_buf, size_t model_size) {
    sat::CpModelProto model;
    if (!model.ParseFromArray(model_buf, model_size)) {
        return strdup("Failed to parse CpModelProto");
    }

    const std::string stats = sat::CpModelStats(model);
    return strdup(stats.c_str());
}

extern "C" char*
cp_sat_wrapper_cp_solver_response_stats(
    unsigned char* response_buf,
    size_t response_size,
    bool has_objective)
{
    sat::CpSolverResponse response;
    if (!response.ParseFromArray(response_buf, response_size)) {
        return strdup("Failed to parse CpSolverResponse");
    }

    const std::string stats = sat::CpSolverResponseStats(response, has_objective);
    return strdup(stats.c_str());
}

extern "C" char*
cp_sat_wrapper_validate_cp_model(unsigned char* model_buf, size_t model_size) {
    sat::CpModelProto model;
    if (!model.ParseFromArray(model_buf, model_size)) {
        return strdup("Failed to parse CpModelProto");
    }

    // Returns an empty string when the model is valid, otherwise a description
    // of the first validation error found.
    const std::string stats = sat::ValidateCpModel(model);
    return strdup(stats.c_str());
}

extern "C" bool
cp_sat_wrapper_solution_is_feasible(
    unsigned char* model_buf,
    size_t model_size,
    const int64_t* solution_buf,
    size_t solution_size)
{
    sat::CpModelProto model;
    if (!model.ParseFromArray(model_buf, model_size)) {
        return false;
    }

    absl::Span<const int64_t> variable_values(solution_buf, solution_size);

    return sat::SolutionIsFeasible(model, variable_values);
}
