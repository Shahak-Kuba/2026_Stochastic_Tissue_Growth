using KubaPhD
using JLD2
using CairoMakie

Geometries = ["triangle", "cross", "VandenHeuvel_2023"]

# Load the CSV file into a DataFrame
all_days, all_mean_density, all_mean_coverage, avg_density_of_all_exp = KubaPhD.AnalyseCellCultureData("/Objective_2/Paper2_1/Simulation_Scripts/Cell_Culturing/Data/Lanaro_Browning_Data.csv");

CellMech = KubaPhD.CellMechProperties_t(kₛ=100, growth_dir="inward", a=20.0)

α = 0.2; β = 0;
E_total = (avg_density_of_all_exp * CellMech.kf);
P, E, PE = KubaPhD.calc_cc_mechanism_rates(α,β,E_total);

#All_CellMechs = [CellMech2]

SimTime = KubaPhD.SimTime_t(Tmax=21, δt = 0.0002, event_δt = 0.0002)

Prolif = KubaPhD.CellEvent_t(true, P, "Constant")
Death = KubaPhD.CellEvent_t()
Embed = KubaPhD.CellEvent_t(true, E, "Constant")
ProlifEmbed = KubaPhD.CellEvent_t(true, PE, "Constant")

# all_sim_outputs[Geomety][data][iteration], 
# for data: 1 = ODE solution, 2 = embedded cell positions, 3 = embedded cell counts at saved times

function run_simulation(CellMech, Domain, SimTime, Prolif, Death, Embed, ProlifEmbed, Seed)
    HomCellMech = KubaPhD.generate_homogeneous_population(CellMech, Domain.N, Domain.m);
    sol, embed_pos, embed_count, embed_rates = KubaPhD.GrowthSimulation(Domain, HomCellMech, SimTime, Prolif, Death, Embed, ProlifEmbed, Seed, 16);
    return sol, embed_pos, embed_count
end

function run_simulation_with_init(CellMech, Domain, SimTime, Prolif, Death, Embed, ProlifEmbed, Seed)
    HomCellMech = KubaPhD.generate_homogeneous_population(CellMech, Domain.N, Domain.m);
    sol, embed_pos, embed_count, embed_rates = KubaPhD.GrowthSimulation_with_init(Domain, HomCellMech, SimTime, Prolif, Death, Embed, ProlifEmbed, Seed, 16);
    return sol, embed_pos, embed_count
end

all_outputs = [[[],[],[]],[[],[],[]],[[],[],[]]] 

for ii in eachindex(Geometries)

    println("Geometry: ", Geometries[ii])
    if ii == 3
        CellMech = KubaPhD.CellMechProperties_t(kₛ=100, growth_dir="inward", a=20.0)
        Domain = KubaPhD.DomainProperties_t(R₀=100, btype=Geometries[ii], m=2, N=60) 
        sol, embed_pos, embed_count = run_simulation_with_init(CellMech, Domain, SimTime, Prolif, Death, Embed, ProlifEmbed, 2)
    elseif ii == 2
        CellMech = KubaPhD.CellMechProperties_t(kₛ=100, growth_dir="inward", a=20.0)
        Domain = KubaPhD.DomainProperties_t(R₀=169.2568750643269, btype=Geometries[ii], m=2, N=60) 
        sol, embed_pos, embed_count = run_simulation(CellMech, Domain, SimTime, Prolif, Death, Embed, ProlifEmbed, 8)
    else
        CellMech = KubaPhD.CellMechProperties_t(kₛ=100, growth_dir="inward", a=20.0)
        Domain = KubaPhD.DomainProperties_t(R₀=169.2568750643269, btype=Geometries[ii], m=2, N=60) 
        sol, embed_pos, embed_count = run_simulation(CellMech, Domain, SimTime, Prolif, Death, Embed, ProlifEmbed, 2)
    end

    push!(all_outputs[ii][1], sol)
    push!(all_outputs[ii][2], embed_pos)
    push!(all_outputs[ii][3], embed_count)

end

f_test = KubaPhD.PlotGrowthSimulation_GL(all_outputs[1][1][1], all_outputs[1][2][1])

f = Figure(size = (1186, 400))
ax_tri = Axis(f[1, 1], aspect = 1,  xlabel=L"$x\ [\mu\text{m}]$", ylabel=L"$y\ [\mu\text{m}]$", xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20, titlesize = 20)
ax_cross = Axis(f[1, 2], aspect = 1, xlabel=L"$x\ [\mu\text{m}]$", xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20, titlesize = 20) 
ax_P02 = Axis(f[1, 3], aspect = 1, xlabel=L"$x\ [\mu\text{m}]$", xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20, titlesize = 20)

KubaPhD.plotGrowthSimulation_no_cb!(ax_tri, all_outputs[1][1][1].u,  all_outputs[1][1][1].Density, all_outputs[1][2][1], KubaPhD.BlueRedColors[:VeryDeepBlue], KubaPhD.BlueRedColors[:MidBlue2])
KubaPhD.plotGrowthSimulation_no_cb!(ax_cross, all_outputs[2][1][1].u,  all_outputs[2][1][1].Density, all_outputs[2][2][1], KubaPhD.BlueRedColors[:VeryDeepBlue], KubaPhD.BlueRedColors[:MidBlue2])
KubaPhD.plotGrowthSimulation_no_cb!(ax_P02, all_outputs[3][1][1].u,  all_outputs[3][1][1].Density, all_outputs[3][2][1], KubaPhD.BlueRedColors[:VeryDeepBlue], KubaPhD.BlueRedColors[:MidBlue2])

save("Cell_Culture_Example_Geometries.png", f)

