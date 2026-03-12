import Stochastic_TG_2026 as MCTG
using JLD2
using CSV
using DataFrames
using CairoMakie
using GLMakie

output_file = "/Users/shahakmac/Desktop/PhD/1-PhD_Papers/Kuba_2025/Simulation_Data/Stiffness_vs_orientation/simulation_outputs_v3.jld2"
@load output_file all_sim_outputs

iteration = 5
idx0 = 8
idx = 11
f = MCTG.PlotGrowthSimulation_clr_by_Orientation_at_t_GL(all_sim_outputs[2][1][iteration], all_sim_outputs[2][2][iteration], vcat(all_sim_outputs[2][3][iteration]...), idx)
save("Example_1_clr_by_orientation_at_t_10_days.png", f; px_per_unit=2.0)
f3, θ, R, orientations= MCTG.PlotGrowthSimulation_clr_by_Orientation_between_t_GL(all_sim_outputs[2][1][iteration], all_sim_outputs[2][2][iteration], vcat(all_sim_outputs[2][3][iteration]...), idx0, idx)
f3_2 = MCTG.PlotCellOrientation(θ, R)
f2 = MCTG.PlotGrowthSimulation_clr_by_Orientation_GL(all_sim_outputs[2][1][iteration], all_sim_outputs[2][2][iteration])

# testing the cell orientation calculation
θ, R, cell_orientation = MCTG.calc_cell_orientation(all_sim_outputs[2][2][iteration][1:5])
f = Figure()
ax = Axis(f[1, 1], aspect = 1)
ii = 1
for cell in all_sim_outputs[2][2][iteration][1:5]
    lines!(ax, cell[1, :], cell[2, :], linewidth = 5, label = "Cell $ii")
    ii += 1
end
Legend(f[1, 2], ax, ["Cell Orientation"], title = "Cell Orientation")
display(f)

# filtering data to that which interface does not overlap
filtered_sim_outputs = [[[], [], []], [[], [], []], [[], [], []]]
for ii in eachindex(all_sim_outputs[1][2])
    if !MCTG.interface_overlaps(all_sim_outputs[1][1][ii].u[end]) 
        #println("low stiffness $ii good")
        if !MCTG.interface_overlaps(all_sim_outputs[2][1][ii].u[end])
            #println("mid stiffness $ii good")
            if !MCTG.interface_overlaps(all_sim_outputs[3][1][ii].u[end])
                println("high stiffness $ii good")
                push!(filtered_sim_outputs[1][1], all_sim_outputs[1][1][ii])
                push!(filtered_sim_outputs[1][2], all_sim_outputs[1][2][ii])
                push!(filtered_sim_outputs[1][3], all_sim_outputs[1][3][ii])
                push!(filtered_sim_outputs[2][1], all_sim_outputs[2][1][ii])
                push!(filtered_sim_outputs[2][2], all_sim_outputs[2][2][ii])
                push!(filtered_sim_outputs[2][3], all_sim_outputs[2][3][ii])
                push!(filtered_sim_outputs[3][1], all_sim_outputs[3][1][ii])
                push!(filtered_sim_outputs[3][2], all_sim_outputs[3][2][ii])
                push!(filtered_sim_outputs[3][3], all_sim_outputs[3][3][ii])
            end
        end
    end
end

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

f3 = MCTG.PlotStiffnessVsOrientationAVG_GL( θ, low_ks_orientation_freq_avg_t_1, mid_ks_orientation_freq_avg_t_1, high_ks_orientation_freq_avg_t_1, low_ks_orientation_freq_avg_t_2, mid_ks_orientation_freq_avg_t_2, high_ks_orientation_freq_avg_t_2, low_ks_orientation_freq_avg_t_3, mid_ks_orientation_freq_avg_t_3, high_ks_orientation_freq_avg_t_3)
