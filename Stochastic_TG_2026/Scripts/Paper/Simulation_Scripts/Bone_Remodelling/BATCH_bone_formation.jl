import Stochastic_TG_2026 as MCTG
using JLD2

BatchSize = 1
# Domain Properties
Domain = MCTG.DomainProperties_t(N=45, R₀=60.0, btype="PerturbedCircle", m = 5)

# Cell Mechanics
CellMech = MCTG.CellMechProperties_t(kₛ=5, growth_dir="inward", kf = 35)

# Cell Behaviours
Prolif = MCTG.CellEvent_t()
Death = MCTG.CellEvent_t(true, 0.0001, "Constant")
Embed = MCTG.CellEvent_t(true, 0.000625*CellMech.kf, "Constant")
ProlifEmbed = MCTG.CellEvent_t()
# Simulation time parameters
#SimTime = MCTG.SimTime_t(Tmax=12, event_trigger="", event_δt=8.0, event_length=2.0)
SimTime = MCTG.SimTime_t(Tmax=56, δt=0.001, event_δt=0.001)

function run_simulation_with_init(CellMech, Domain, SimTime, Prolif, Death, Embed, ProlifEmbed, Seed, IC)
    HomCellMech = MCTG.generate_homogeneous_population(CellMech, Domain.N, Domain.m);
    num_t_save = round(Int64, SimTime.Tmax / 7) 
    sol, embed_pos, embed_count, embed_rates = MCTG.GrowthSimulation_given_IC(Domain, HomCellMech, SimTime, Prolif, Death, Embed, ProlifEmbed, Seed, num_t_save, IC);
    return sol, embed_pos, embed_count
end

embedded_count_iteration_results = Vector{Int64}[]
Ω_iteration_results = Vector{Float64}[]
t = Vector{Float64}[]
all_solutions = MCTG.SimResults_t[]
all_embedded_cell_pos = Vector{Matrix{Float64}}[]

prob_u0 = []

@time for iteration in 1:BatchSize
    #count = size(seeds)[1]
    if iteration == 1
        prob_u0 = MCTG.init_problem(Domain, CellMech, SimTime, Prolif, Death, Embed, ProlifEmbed)
    end
    HomCellMech = MCTG.generate_homogeneous_population(CellMech, Domain.N, Domain.m);
    sol, embedded_cells, embed_cell_count = run_simulation_with_init(CellMech, Domain, SimTime, Prolif, Death, Embed, ProlifEmbed, iteration, prob_u0)
    push!(all_solutions, sol)
    push!(all_embedded_cell_pos, embedded_cells)
    push!(embedded_count_iteration_results, convert(Vector{Int64}, embed_cell_count[1]))
    push!(Ω_iteration_results, sol.Ω[1] .- sol.Ω)
    if iteration == 1
        push!(t, sol.t)
    end
    println("Simulation $iteration / $BatchSize")
end

iteration = 1
PlotOsteon_Simulation(all_solutions[iteration], all_embedded_cell_pos[iteration])
MCTG.PlotGrowthSimulation_GL(all_solutions[iteration], all_embedded_cell_pos[iteration])
fig = MCTG.PlotMultiGrowthSimulations_GL(all_solutions[12:25], all_embedded_cell_pos[12:25])

dim2 = 1000
ξ_all = zeros(size(embedded_count_iteration_results[1],1)-1, dim2);
A_all = zeros(size(embedded_count_iteration_results[1],1)-1, dim2);
N_embed_all = zeros(size(embedded_count_iteration_results[1],1)-1, dim2);
total_ξ = zeros(dim2,1);

#for iteration in 1:size(all_solutions,1)
for iteration in 1:dim2
    ξ,A,N_embed = MCTG.WallDensity(embedded_count_iteration_results[iteration], Ω_iteration_results[iteration])
    for ii in eachindex(ξ)
        if ξ[ii] < 0.0
            ξ[ii] = 0.0
        end
    end
    ξ_all[1:size(ξ,1), iteration] .= ξ
    A_all[1:size(A,1), iteration] .= A
    N_embed_all[1:size(N_embed,1), iteration] .= N_embed
    total_ξ[iteration] = embedded_count_iteration_results[iteration][end] / ( Ω_iteration_results[iteration][end]) 
end

sol = all_solutions[28]; # 543 is a good one
embedded_pos = all_embedded_cell_pos[28];

f = MCTG.PlotWallEmbedDensities_GL(sol, embedded_pos, ξ_all, 0.000625, total_ξ)

CairoMakie.save("Fig7_Density_by_Wall_and_various_patterns.png", f; px_per_unit=2.0)

Analytic_cell_count = MCTG.N_analytic(Domain.N, Prolif.rate, Death.rate, Embed.rate, LinRange(0.0, SimTime.Tmax, 100));



