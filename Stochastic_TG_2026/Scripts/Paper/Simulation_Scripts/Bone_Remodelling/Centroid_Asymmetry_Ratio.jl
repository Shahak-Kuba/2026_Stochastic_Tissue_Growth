# load data
output_file = "/Users/shahakmac/Desktop/PhD/1-PhD_Papers/Kuba_2025/Simulation_Data/Bone_Formation_Batch/simulation_outputs.jld2"
@load output_file all_solutions all_embedded_cell_pos embedded_count_iteration_results Ω_iteration_results

# focusing on one realisations
sol = all_solutions[28];
# calculating the centroid of the start
centroid_0 = sum(sol.u[1], dims=2) ./ size(sol.u[1], 2)

# find radius from centroid to outer Wall
radius_t_0 = zeros(size(sol.u[1], 2))
for i in 1:size(sol.u[1],2)
    radius_t_0[i] = √( (sol.u[1][1,i]-centroid[1])^2 + (sol.u[1][2,i]-centroid[2])^2 )
end

max_radius_0, max_index_0 = findmax(radius_t_0)
min_radius_0, min_index_0 = findmin(radius_t_0)

# calculating the centroid of the end
centroid_1 = sum(sol.u[end], dims=2) ./ size(sol.u[end], 2)

centroid_asymmetry_ratio = (min_radius_0) / (max_radius_0 ) * √( (centroid_1[1]-centroid_0[1])^2 + (centroid_1[2]-centroid_0[2])^2 )