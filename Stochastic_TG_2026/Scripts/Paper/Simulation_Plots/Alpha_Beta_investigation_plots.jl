import Stochastic_TG_2026 as MCTG  
using JLD2
using CSV
using DataFrames
using CairoMakie
using Statistics

# Load simulation data

idx = 1
all_sim_data = [simulation_outputs[1][idx][1]; simulation_outputs[1][idx][2]; simulation_outputs[2][idx][1]; simulation_outputs[2][idx][2]; simulation_outputs[3][idx][1]; simulation_outputs[3][idx][2]; simulation_outputs[4][idx][1]; simulation_outputs[4][idx][2]];
idx = 2
all_embed_data = [simulation_outputs[1][idx][1]; simulation_outputs[1][idx][2]; simulation_outputs[2][idx][1]; simulation_outputs[2][idx][2]; simulation_outputs[3][idx][1]; simulation_outputs[3][idx][2]; simulation_outputs[4][idx][1]; simulation_outputs[4][idx][2]];
idx = 3
all_embed_count = [simulation_outputs[1][idx][1]; simulation_outputs[1][idx][2]; simulation_outputs[2][idx][1]; simulation_outputs[2][idx][2]; simulation_outputs[3][idx][1]; simulation_outputs[3][idx][2]; simulation_outputs[4][idx][1]; simulation_outputs[4][idx][2]];

fig = Figure(size=(1000, 500))
ga = fig[1,1] = GridLayout()
gb = fig[2,1] = GridLayout()
gc = fig[1,2] = GridLayout()
gd = fig[2,2] = GridLayout()
ge = fig[1,3] = GridLayout()
gf = fig[2,3] = GridLayout()
gg = fig[1,4] = GridLayout()
gh = fig[2,4] = GridLayout()

growth1_sim_ax = Axis(ga[1,1], aspect=1, ylabel=L"$y\ [\mu\text{m}]$", xticklabelsvisible=false, xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20)
growth2_sim_ax = Axis(gb[1,1], aspect=1, xlabel=L"$x\ [\mu\text{m}]$", ylabel=L"$y\ [\mu\text{m}]$", xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20)
growth3_sim_ax = Axis(gc[1,1], aspect=1, xticklabelsvisible=false, yticklabelsvisible=false, xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20) 
growth4_sim_ax = Axis(gd[1,1], aspect=1, xlabel=L"$x\ [\mu\text{m}]$", yticklabelsvisible=false, xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20)
growth5_sim_ax = Axis(ge[1,1], aspect=1, xticklabelsvisible=false, yticklabelsvisible=false, xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20)
growth6_sim_ax = Axis(gf[1,1], aspect=1, xlabel=L"$x\ [\mu\text{m}]$", yticklabelsvisible=false, xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20)
growth7_sim_ax = Axis(gg[1,1], xticklabelsvisible=false, yticklabelsvisible=false, xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20)
growth8_sim_ax = Axis(gh[1,1], aspect=1, xlabel=L"$x\ [\mu\text{m}]$", yticklabelsvisible=false, xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20)

all_axes = [
    growth1_sim_ax, growth2_sim_ax, growth3_sim_ax,
    growth4_sim_ax, growth5_sim_ax, growth6_sim_ax,
    growth7_sim_ax, growth8_sim_ax
]
for ii in eachindex(all_axes)
    MCTG.plotGrowthSimulation_no_cb!(all_axes[ii], all_sim_data[ii].u, all_sim_data[ii].Density, all_embed_pos[ii], MCTG.BlueRedColors[:VeryDeepBlue], MCTG.BlueRedColors[:MidBlue2])
end

display(fig)
save("Different_α_simulations.png", fig)


beta_output_file = "/Users/shahakmac/Desktop/PhD/1-PhD_Papers/Paper_2a_Applied/Cell_Culture_Investigation/Simulation_Data/simulation_outputs_β_investigation_2.jld2"
@load beta_output_file simulation_outputs

final_times_stats = []
all_iteration_times = Vector{Float64}[]

for idx in eachindex(simulation_outputs)
    iteration_times = []
    for iteration in 1:length(simulation_outputs[idx][1])
        final_time = simulation_outputs[idx][1][iteration].t[end]
        push!(iteration_times, final_time)
    end
    println("Index: ", idx, " Iteration times: ", iteration_times)
    mean_time = mean(iteration_times)
    max_time = maximum(iteration_times)
    min_time = minimum(iteration_times)
    closest_idx = argmin(abs.(iteration_times .- mean_time))
    push!(final_times_stats, (mean=mean_time, max=max_time, min=min_time, closest_idx=closest_idx))
    push!(all_iteration_times, iteration_times)
end

println("Final times statistics: ", final_times_stats)
for idx in eachindex(simulation_outputs)
    println("Index mean ", final_times_stats[idx].mean, " final time: ", simulation_outputs[idx][1][final_times_stats[idx].closest_idx].t[end])
end


fig = Figure(resolution = (900, 450))
ax = Axis(fig[1, 1], xlabel = L"$\text{Time [days]}$", ylabel = L"$Ω(t)/Ω(0)$", aspect=1, xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20)
clrs = [MCTG.divColors[:DeepBlue], MCTG.divColors[:MidBlue1], MCTG.divColors[:LightBlue2]];
for index in eachindex(simulation_outputs)
    closest_idx = final_times_stats[index].closest_idx
    time_data = simulation_outputs[index][1][closest_idx].t
    area_coverage = 1 .- ((simulation_outputs[index][1][closest_idx].Ω[1] .- simulation_outputs[index][1][closest_idx].Ω) ./ simulation_outputs[index][1][closest_idx].Ω[1])
    if index == 1
        lines!(ax, time_data, area_coverage, label = L"$\beta = -0.05$", linewidth = 3, color = clrs[index])
    elseif index == 2
        lines!(ax, time_data, area_coverage, label = L"$\beta = 0$", linewidth = 3, color = clrs[index])
    elseif index == 3   
        lines!(ax, time_data, area_coverage, label = L"$\beta = 0.1$", linewidth = 3, color = clrs[index])
    end

end
scatter!(ax, all_days[1] .- all_days[1][1], 1 .- all_mean_coverage[1], markersize=15, color=MCTG.myColors[:DarkGrey], label=L"$\text{Exp. data}$");
axislegend(ax, position = :rt, labelsize=18)

ax2 = Axis(fig[1, 2], xlabel = L"$\beta$", xticks=(1:3, ["-0.05", "0", "0.1"]), ylabel = L"$\text{80% closure time [days]}$", aspect=1, xticklabelsize = 18, yticklabelsize = 18, xlabelsize = 20, ylabelsize = 20)

for index in eachindex(all_iteration_times)
    boxplot!(ax2, index .* ones(length(all_iteration_times[index])), all_iteration_times[index], show_outliers = false, label = "β = $(βs[index])", whiskerwidth = 0.5, color = clrs[index])
end

fig
save("Different_β_simulations.png", fig)
