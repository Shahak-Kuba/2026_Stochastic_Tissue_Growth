import Stochastic_TG_2026 as MCTG
using JLD2
using CairoMakie
# Plot 3: Cell stiffness vs Embedded cell orientation

# Load saved the outputs of 100 realisations 

@load loaded_file all_sim_outputs

iteration = 37 # random choice that looks centred 
fig3 = MCTG.PlotSiffnessVsOrientation_GL(all_sim_outputs[1][1][iteration], all_sim_outputs[1][2][iteration], all_sim_outputs[1][3][iteration], all_sim_outputs[2][1][iteration], all_sim_outputs[2][2][iteration], all_sim_outputs[2][3][iteration], all_sim_outputs[3][1][iteration], all_sim_outputs[3][2][iteration], all_sim_outputs[3][3][iteration])
CairoMakie.save("Fig3_stiffness_vs_orientation_3.png", fig3; px_per_unit=2.0)
# Cell density 

MCTG.PlotMultiGrowthSimulations_GL(mid_sim_outputs[1][1:12], mid_sim_outputs[2][1:12])
MCTG.PlotMultiGrowthSimulations_GL(all_sim_outputs[3][1][13:25], all_sim_outputs[3][2][13:25])
MCTG.PlotMultiGrowthSimulations_GL(all_sim_outputs[3][1][26:38], all_sim_outputs[3][2][26:38])
MCTG.PlotMultiGrowthSimulations_GL(all_sim_outputs[3][1][38:50], all_sim_outputs[3][2][38:50])


# Plot 4: Average orientation of embedded cells from all realisations
t_1_idx = 5;
t_2_idx = 8;
t_3_idx = 11;

# calculating averages over batch realisations
θ = MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]
low_ks_orientation_freq_avg_t_1 = zeros(size(MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]))
low_ks_orientation_freq_avg_t_2 = zeros(size(MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]))
low_ks_orientation_freq_avg_t_3 = zeros(size(MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]))
for ii in eachindex(all_sim_outputs[1][2])
    low_ks_orientation_freq_avg_t_1 += MCTG.calc_cell_orientation_at_t(all_sim_outputs[1][2][ii], vcat(all_sim_outputs[1][3][ii]...), t_1_idx)[2]
    low_ks_orientation_freq_avg_t_2 += MCTG.calc_cell_orientation_at_t(all_sim_outputs[1][2][ii], vcat(all_sim_outputs[1][3][ii]...), t_2_idx)[2]
    low_ks_orientation_freq_avg_t_3 += MCTG.calc_cell_orientation_at_t(all_sim_outputs[1][2][ii], vcat(all_sim_outputs[1][3][ii]...), t_3_idx)[2]
end


mid_ks_orientation_freq_avg_t_1 = zeros(size(MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]))
mid_ks_orientation_freq_avg_t_2 = zeros(size(MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]))
mid_ks_orientation_freq_avg_t_3 = zeros(size(MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]))
for ii in eachindex(all_sim_outputs[2][2])
    mid_ks_orientation_freq_avg_t_1 += MCTG.calc_cell_orientation_at_t(all_sim_outputs[2][2][ii], vcat(all_sim_outputs[2][3][ii]...), t_1_idx)[2]
    mid_ks_orientation_freq_avg_t_2 += MCTG.calc_cell_orientation_at_t(all_sim_outputs[2][2][ii], vcat(all_sim_outputs[2][3][ii]...), t_2_idx)[2]
    mid_ks_orientation_freq_avg_t_3 += MCTG.calc_cell_orientation_at_t(all_sim_outputs[2][2][ii], vcat(all_sim_outputs[2][3][ii]...), t_3_idx)[2]
end

high_ks_orientation_freq_avg_t_1 = zeros(size(MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]))
high_ks_orientation_freq_avg_t_2 = zeros(size(MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]))
high_ks_orientation_freq_avg_t_3 = zeros(size(MCTG.calc_cell_orientation(all_sim_outputs[1][2][1])[1]))
for ii in eachindex(all_sim_outputs[3][2])
    high_ks_orientation_freq_avg_t_1 += MCTG.calc_cell_orientation_at_t(all_sim_outputs[3][2][ii], vcat(all_sim_outputs[3][3][ii]...), t_1_idx)[2]
    high_ks_orientation_freq_avg_t_2 += MCTG.calc_cell_orientation_at_t(all_sim_outputs[3][2][ii], vcat(all_sim_outputs[3][3][ii]...), t_2_idx)[2]
    high_ks_orientation_freq_avg_t_3 += MCTG.calc_cell_orientation_at_t(all_sim_outputs[3][2][ii], vcat(all_sim_outputs[3][3][ii]...), t_3_idx)[2]
end

fig4 = MCTG.PlotStiffnessVsOrientationAVG_GL( θ, low_ks_orientation_freq_avg_t_1, mid_ks_orientation_freq_avg_t_1, high_ks_orientation_freq_avg_t_1, low_ks_orientation_freq_avg_t_2, mid_ks_orientation_freq_avg_t_2, high_ks_orientation_freq_avg_t_2, low_ks_orientation_freq_avg_t_3, mid_ks_orientation_freq_avg_t_3, high_ks_orientation_freq_avg_t_3)
CairoMakie.save("Fig4_stiffness_vs_orientation_averaged.png", fig4; px_per_unit=2.0)

# Plot 5: Exploring Proliferation rates
output_file = "/Users/shahakmac/Desktop/PhD/1-PhD_Papers/Kuba_2025/Simulation_Data/Various_Prolif_Rates/simulation_outputs.jld2"
@load output_file sol_1 embed_pos_1 embed_count_1 embed_rates_1 sol_2 embed_pos_2 embed_count_2 embed_rates_2 sol_3 embed_pos_3 embed_count_3 embed_rates_3
fig5 = MCTG.PlotProlifRateExp_GL(sol_1, embed_count_1, sol_2, embed_count_2, sol_3, embed_count_3, avg_density_of_all_exp)
save("Fig5_Prolif_rate_exploration.png", fig5, px_per_unit = 2.0)

# Plot 6: Different Mechanism Models
output_file = "/Users/shahakmac/Desktop/PhD/1-PhD_Papers/Kuba_2025/Simulation_Data/Different_Mechanism_Models/simulation_outputs.jld2"
@load output_file sol_1 embed_pos_1 embed_count_1 embed_rates_1 sol_2 embed_pos_2 embed_count_2 embed_rates_2 sol_3 embed_pos_3 embed_count_3 embed_rates_3
fig6 = MCTG.PlotDifferentMechanismModels_GL(sol_1, sol_2, sol_3, embed_count_1, embed_count_2, embed_count_3)


################### BONE Formation ######################

# Plot 7: Bone formation
output_file = "/Users/shahakmac/Desktop/PhD/1-PhD_Papers/Kuba_2025/Simulation_Data/Bone_Formation_Batch/simulation_outputs_low_stiffness.jld2"
@load output_file all_solutions all_embedded_cell_pos embedded_count_iteration_results Ω_iteration_results
bad_iterations = [25, 105, 180, 306, 545] # remove iterations where interface overlaps
sort!(bad_iterations);
deleteat!(all_solutions, bad_iterations);
deleteat!(all_embedded_cell_pos, bad_iterations);
deleteat!(embedded_count_iteration_results, bad_iterations);
deleteat!(Ω_iteration_results, bad_iterations);
ξ_all = zeros(size(embedded_count_iteration_results[1],1)-1, size(embedded_count_iteration_results,1));
A_all = zeros(size(embedded_count_iteration_results[1],1)-1, size(embedded_count_iteration_results,1));
N_embed_all = zeros(size(embedded_count_iteration_results[1],1)-1, size(embedded_count_iteration_results,1));
for iteration in 1: size(all_solutions,1)
    ξ,A,N_embed = MCTG.WallDensity(embedded_count_iteration_results[iteration], Ω_iteration_results[iteration])
    for ii in eachindex(ξ)
        if ξ[ii] < 0.0
            ξ[ii] = 0.0
        end
    end
    ξ_all[:, iteration] .= ξ
    A_all[:, iteration] .= A
    N_embed_all[:, iteration] .= N_embed
end
sol = all_solutions[28];
embedded_pos = all_embedded_cell_pos[28];
fig7 = MCTG.PlotWallEmbedDensities_GL(sol, embedded_pos, ξ_all, 0.000625)

# Plot 8: Bone formation WTh_asymmetry_ratio
results = MCTG.analyse_wallThickness_density(all_solutions[1:500], all_embedded_cell_pos[1:500]);
sort!(results, :WThRatio);
println(results)
fig8_1, fig8_2 = MCTG.PlotWThAsymmetry_GL(results, all_solutions, all_embedded_cell_pos);
