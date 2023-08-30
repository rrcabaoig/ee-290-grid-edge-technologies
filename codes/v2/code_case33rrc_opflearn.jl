results = nothing

using Distributed

# Create worker processes
nproc = 4 # The desired number of CPUs to run with
# Clear any existing worker processes if present
Distributed.nprocs() > 1 && Distributed.rmprocs(Distributed.workers())
# Create worker processes
Distributed.addprocs(nproc - 1; exeflags="--project")

# Import functions used on all worker processes
Distributed.@everywhere using OPFLearn

N = 30000
pd_max_twice = [0.002, 0.0018, 0.0024, 0.0012, 0.0012, 0.004, 0.004, 0.0012, 0.0012, 0.0009, 0.0012, 0.0012, 0.0024, 0.0012, 0.0012, 0.0012, 0.0018, 0.0018, 0.0018, 0.0018, 0.0018, 0.0018, 0.0084, 0.0084, 0.0012, 0.0012, 0.0012, 0.0024, 0.004, 0.003, 0.0042, 0.0012]
outputs = ["p_gen", "vm_gen"]

results = dist_create_samples("case33rrc_opflearn.m", N, output_vars = outputs, pd_max = pd_max_twice, pf_min = 0.8)

save_results_csv(results, "case33rrc_opflearn_30000samples")